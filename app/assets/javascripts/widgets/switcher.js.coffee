$ ->
  $('.switcher').on 'click', (e)->
    e.preventDefault()
    $link = $(e.target)
    $target = $($link.attr('href') )
    $('.nav > li').removeClass('active')
    $link.parents('.nav li').addClass('active')
    $('.switcher-tab:visible').fadeOut ->
      $target.fadeIn()
    $('.nav-collapse').collapse('hide')
