# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

toggleForm = (formId) ->
	form = $(formId)
	form.toggle()
	
$ ->
	$('.toggle_form').click ->
		toggleForm @attributes['reference'].textContent
		