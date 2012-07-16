# @Author = Nada Nasr

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  submitType = 0;
  $("#warn_comment").click ->
    submitType = 1

  $("#ban_comment").click ->
    submitType = 2

  $("#reason_comment_button").click ->
    if submitType is 1
      target = " ../admin/comments/warn "
      $("#comments_form").attr "action", target
      $("#comments_form").submit()
    if submitType is 2
      target = " ../admin/comments/ban "
      $("#comments_form").attr "action", target
      $("#comments_form").submit()
      
  $("#delete_comment").click ->
  	if window.confirm("Are you sure you want to delete these comments?")
    	target = " ../admin/comments/delete "
    	$("#comments_form").attr "action", target
    	$("#comments_form").submit()


  # @Author: Nada Nasr
  # @Summary: changes target action of comments_form after clicking hide
  $("#hide_comment").click ->
    target = " /admins/hide_marked_comments "
    $("#comments_form").attr "action", target
    $("#comments_form").submit()


  # @Author: Nada Nasr
  # @Summary: disables and re-enables buttons on the reported comments page according to whether there are checkboxes checked or not.
  $("input:checkbox").click ->
    buttonsChecked = $("input:checkbox:checked")
    if buttonsChecked.length
      $("#warn_comment").removeAttr "disabled"
      $("#ban_comment").removeAttr "disabled"
      $("#delete_comment").removeAttr "disabled"
      $("#hide_comment").removeAttr "disabled"
    else
      $("#warn_comment").attr "disabled", "disabled"
      $("#ban_comment").attr "disabled", "disabled"
      $("#delete_comment").attr "disabled", "disabled"
      $("#hide_comment").attr "disabled", "disabled"