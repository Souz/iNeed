# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  $("#delete_comp").click ->
    if window.confirm("Are you sure you want to delete these messages ?")
      target = " complaints/delete "
      $("#complaints_form").attr "action", target
      $("#complaints_form").submit()

  $("#read").click ->
    target = " complaints/mark_as_read "
    $("#complaints_form").attr "action", target
    $("#complaints_form").submit()

  $("#unread").click ->
    target = " complaints/mark_as_unread "
    $("#complaints_form").attr "action", target
    $("#complaints_form").submit()
