# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $form = $('#contactform')
  $feedbackContainer = $form.find('[data-feedback]')

  $form.on 'submit', (event, data, status, xhr) ->
    $feedbackContainer.empty()

  $form.on 'ajax:success', (event) ->
    [data, status, xhr] = event.detail
    $alert =$('<div>',
      class: 'alert alert-success',
      text: data.message
    ).css 'display', 'none'
    $feedbackContainer.append($alert)
    $alert.slideDown()

  $form.on 'ajax:error', (event) ->
    [data, status, xhr] = event.detail
    responseObject = $.parseJSON(xhr.responseText)
    $errors = $('<div>',
      class: 'alert alert-warning'
    ).css('display', 'none')

    $list = $('<ul/>')
    $list.append("<li>#{error}</li>") for error in responseObject.errors

    $feedbackContainer.append($errors.append($list))
    $errors.slideDown()
