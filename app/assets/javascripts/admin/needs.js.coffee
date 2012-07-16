# @Author = Nada Nasr

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  submitType = 0;
  $("#warn_need").click ->
    submitType = 1

  $("#ban_need").click ->
    submitType = 2

  $("#delete_need").click ->
  	if window.confirm("Are you sure you want to delete these needs?")
    	target = " ../admin/needs/delete "
    	$("#needs_form").attr "action", target
    	$("#needs_form").submit()

  # @Author: Nada Nasr
  # @Summary: changes target action of needs_form after clicking hide
  $("#hide").click ->
    target = " /admins/hide_marked_needs "
    $("#needs_form").attr "action", target
    $("#needs_form").submit()

  $("#reason_need_button").click ->
    if submitType is 1
      target = " ../admin/needs/warn "
      $("#needs_form").attr "action", target
      $("#needs_form").submit()
    if submitType is 2
      target = " ../admin/needs/ban "
      $("#needs_form").attr "action", target
      $("#needs_form").submit()


  # @Author: Nada Nasr
  # @Summary: disables and re-enables buttons on the reported comments page according to whether there are checkboxes checked or not.
  $("input:checkbox").click ->
    buttonsChecked = $("input:checkbox:checked")
    if buttonsChecked.length
      $("#warn_need").removeAttr "disabled"
      $("#ban_need").removeAttr "disabled"
      $("#delete_need").removeAttr "disabled"
      $("#hide").removeAttr "disabled"
    else
      $("#warn_need").attr "disabled", "disabled"
      $("#ban_need").attr "disabled", "disabled"
      $("#delete_need").attr "disabled", "disabled"
      $("#hide").attr "disabled", "disabled"

