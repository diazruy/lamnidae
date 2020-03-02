class window.SkillsChart
  defaultOptions:
    width: 650
    margin:
      top: 0
      right: 20
      bottom: 20
      left: 20
    bar:
      height: 10
      gap: 5
      colorRange:[
        "#003af9"
        "#00f9bf"
      ]
    font:
      size: 7

  constructor: (chartSel, options) ->
    @$chart = $(chartSel)
    @options = $.extend({}, @defaultOptions, options)
    @_parseSkills()
    @_buildControls()
    @_buildChart()

  _buildControls: ->
    @$controls = $('<ul>', class: 'list-unstyled list-inline')
    for category in @_categories()
      $li = $('<li>', class: 'skillcontrol')
      @$controls.append($li.append(@_buildCategoryLabelControl(category)))

    @$chart.append(@$controls)

  _buildCategoryLabelControl: (category) ->
    $label = $('<label>')
    $checkbox = $("<input type='checkbox' value='#{category}' checked>")
      .data('category', category)
      .on 'click', @_handleCategoryChange
    $label.append($checkbox)
    $label.append($('<div>', class: 'skillcontrol-circle', css: {backgroundColor: @_colorForCategory(category)}))
    $label.append($('<span>', text: category))

  _handleCategoryChange: (e) =>
    e.stopImmediatePropagation()
    $checkbox = $(e.currentTarget)
    isSelected = $checkbox.prop('checked')
    $checkbox.parents('li').toggleClass('is-disabled', !isSelected)
    @_filterActiveSkillsSkills();

  _filterActiveSkillsSkills: ->
    activeCategories = @_activeCategories()
    activeSkills = @skills.filter (skill) -> activeCategories.includes(skill.category)
    @_updateSkills([])
    @_updateSkills(activeSkills)

  _activeCategories: ->
    activeCategories = []
    @$controls.find('input:checked').each (index, checkbox) ->
      activeCategories.push checkbox.value
    activeCategories

  _buildChart: ->
    fromDates = @skills.map((d) -> d.from).sort( -> (a, b) -> a.getTime() - b.getTime() )
    earliestDate = new Date(fromDates[0])
    earliestDate.setFullYear(earliestDate.getFullYear() - 2) # So that labels don't get chopped off

    # TODO: Resize dynamically with window
    containerWidth = @$chart.outerWidth()
    chartWidth = containerWidth - @options.margin.left - @options.margin.right
    chartHeight = @skills.length * (@options.bar.gap + @options.bar.height) + @options.bar.gap

    @xScale = d3.scaleTime()
      .domain([earliestDate, Date.now()])
      .range([0, chartWidth])

    @yScale = d3.scaleLinear()
      .domain([0, @skills.length])
      .range([0, chartHeight])


    svg = d3.select(@$chart.get(0)).append("svg")
      .attr("width", containerWidth )
      .attr("height", chartHeight + @options.margin.top + @options.margin.bottom)

    mainGroup = svg
      .append("g")
      .attr("transform", "translate(#{@options.margin.left},#{@options.margin.top})")

    xAxis = d3.axisBottom()
      .scale(@xScale)
      .tickSize(10)

    mainGroup
      .append('g')
      .attr("transform", "translate(0,#{chartHeight})")
      .call(xAxis)

    @skillBars = mainGroup.append('g')
    @_updateSkills(@skills)

  _updateSkills: (skills) ->
    selection = @skillBars
      .selectAll("g")
      .data(skills, (d) -> d.name )

    selection.exit().remove()
    selection
      .enter().call(@_addBar)
      .merge(selection).call(@_updateBar)

  _addBar: (enter) =>
    skillBar = enter
      .append("g")

    radius = @options.bar.height / 2
    skillBar
      .append("rect")
      .attr("rx", radius)
      .attr("ry", radius)
      .attr("stroke", "none")

    skillBar
      .append('text')
      .attr("class", "label")
      .attr("x", -5)
      .attr("text-anchor", "end")

  _updateBar: (update) =>
    skillBar = update
      .selectAll("g")
      .attr("transform", @_barPosition)

    skillBar
      .selectAll("rect")
      .attr("width", @_barWidth)
      .attr("height", @options.bar.height)
      .attr("fill", @_barColor)

    skillBar
      .selectAll('text')
      .attr("y", @options.font.size + ((@options.bar.height - @options.font.size) / 2))
      .text((d,i) => d.name)

  _barPosition: (d, i) =>
    x = @xScale(d.from)
    y = @options.bar.gap + i * (@options.bar.height + @options.bar.gap)
    "translate(#{x},#{y})"

  _barWidth: (d, i) =>
    endDate = d.to || Date.now() # If no end, assume ongoing
    @xScale(endDate) - @xScale(d.from)

  _barColor: (d) =>
    @_colorForCategory(d.category)

  _parseSkills: ->
    @skills = []

    @skillsByCategory = @$chart.data('skills')

    for category, skills of @skillsByCategory
      for skill in skills
        @skills.push @_formatSkill(skill, category)

    @skills.sort @_sortSkills

  _formatSkill: (skill, category) ->
    parseDate = d3.timeParse('%Y-%m-%d')
    {
      name: skill.name
      from: parseDate(skill.from)
      to: parseDate(skill.to)
      category: category
    }

  _sortSkills: (a, b) ->
    byStart = a.from.getTime() - b.from.getTime()
    if byStart == 0
      if a.category == b.category
        byEnd = (a.to || new Date()).getTime() - (b.to || new Date()).getTime()
        if byEnd == 0
          byName = a.name > b.name ? 1 : -1
        else
          byEnd
      else
        a.category > b.category
    else
      byStart

  _categories: ->
    @categories ?= Object.keys(@skillsByCategory).sort()

  _colorScale: (index) ->
    @colorScale ?= d3.scaleLinear()
      .domain([0, @_categories().length])
      .range(@options.bar.colorRange)
      .interpolate(d3.interpolateHcl)

    @colorScale(index)

  _colorForCategory: (category) ->
    d3.rgb(@_colorScale(@_categories().indexOf(category)))
