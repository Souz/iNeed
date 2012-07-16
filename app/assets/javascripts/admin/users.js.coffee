# @Author = Nada Nasr

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#unban").click ->
    target = " un_ban_marked_user "
    $("#users_form").attr "action", target
    $("#users_form").submit()  

  # @Author: Nada Nasr
  # @Summary: changes target action of users_form after clicking email
  $("#email").click ->
    target = " /admin/users/mailto_users "
    $("#users_form").attr "action", target
    $("#users_form").submit()

  # @Author: Nada Nasr
  # @Summary: disables and re-enables buttons on the banned users page according to whether there are checkboxes checked or not.
  $("input:checkbox").click ->
    buttonsChecked = $("input:checkbox:checked")
    if buttonsChecked.length
      $("#unban").removeAttr "disabled"
      $("#email").removeAttr "disabled"
    else
      $("#unban").attr "disabled", "disabled"
      $("#email").attr "disabled", "disabled"
