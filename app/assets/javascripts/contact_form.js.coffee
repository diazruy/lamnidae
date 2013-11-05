# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('form.contactform').on 'submit', (event, data, status, xhr) ->
    $(@).find('.errors').empty().slideUp()

  $('form.contactform').on 'ajax:success', (event, data, status, xhr) ->
    $('.success').html(data.message).slideDown()


  $('form.contactform').on 'ajax:error', (event, xhr, status, error) ->
    responseObject = $.parseJSON(xhr.responseText)
    errors = $('<ul />')

    $.each responseObject.errors, (index, value) ->
      errors.append('<li>' + value + '</li>')

    $(@).find('.errors').html(errors).slideDown();

