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

    data = @_getData()

    dataByCategories = d3.nest().key((d) -> d.category).entries(data)
    @categories = dataByCategories.map((d) -> d.key).sort()
    fromDates = data.map((d) -> d.from).sort( -> (a, b) -> a.getTime() - b.getTime() )
    earliestDate = fromDates[0]

    @colorScale = d3.scaleLinear()
      .domain([0, @categories.length])
      .range(@options.bar.colorRange)
      .interpolate(d3.interpolateHcl)

    # TODO: Resize dynamically with window
    containerWidth = @$chart.outerWidth()
    chartWidth = containerWidth - @options.margin.left - @options.margin.right
    chartHeight = data.length * (@options.bar.gap + @options.bar.height) + @options.bar.gap

    @xScale = d3.scaleTime()
      .domain([earliestDate, Date.now()])
      .range([0, chartWidth])
      .nice()

    @yScale = d3.scaleLinear()
      .domain([0, data.length])
      .range([0, chartHeight])

    # TODO: Change number of ticks in small screen
    xAxis = d3.axisBottom()
      .scale(@xScale)
      .tickSize(10)

    svg = d3.select(@$chart.get(0)).append("svg")
      .attr("width", containerWidth )
      .attr("height", chartHeight + @options.margin.top + @options.margin.bottom)

    mainGroup = svg
      .append("g")
      .attr("transform", "translate(#{@options.margin.left},#{@options.margin.top})")

    mainGroup
      .append('g')
      .attr("transform", "translate(0,#{chartHeight})")
      .call(xAxis)

    projects = mainGroup
      .append('g')
      .selectAll("this_is_empty")
      .data(data)
      .enter()

    radius = @options.bar.height / 2
    innerRects = projects
      .append("g")
      .attr("transform", (d, i) =>
        x = @xScale(d.from)
        y = @options.bar.gap + i * (@options.bar.height + @options.bar.gap)
        "translate(#{x},#{y})"
      )
    innerRects
      .append("rect")
      .attr("rx", radius)
      .attr("ry", radius)
      #.attr("x", (d, i) => @xScale(d.from) )
      #.attr("y", (d, i) => @options.bar.gap + i * (@options.bar.height + @options.bar.gap) )
      .attr("width", @_barWidth)
      .attr("height", @options.bar.height)
      .attr("fill", @_barColor)
      .attr("stroke", "none")
    innerRects
      .append('text')
      .attr("class", "label")
      .attr("x", -5)
      .attr("y", @options.font.size + ((@options.bar.height - @options.font.size) / 2))
      .attr("text-anchor", "end")
      .text((d,i) => d.name)



  _barWidth: (d, i) =>
    endDate = d.to || Date.now() # If no end, assume ongoing
    @xScale(endDate) - @xScale(d.from)

  _barColor: (d) =>
    d3.rgb(@colorScale(@categories.indexOf(d.category)))

  _getData: ->
    data = []
    parseDate = d3.timeParse('%Y-%m-%d')

    $dataSource = $(@$chart.data('target'))
    $dataSource.find('[data-skills-from]').each (_index, el) ->
      $el = $(el)
      elData = $el.data()
      data.push
        name: $el.text()
        from: parseDate(elData.skillsFrom)
        to: parseDate(elData.skillsTo)
        category: elData.skillsCategory

    data.sort (a, b) ->
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
