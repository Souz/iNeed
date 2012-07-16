# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  submitType = 0;
  $("#warn_supplier").click ->
    submitType = 1

  $("#ban_supplier").click ->
    submitType = 2


  $("#reason_supplier_button").click ->
    if submitType is 1
      target = " suppliers/warn "
      $("#users_form").attr "action", target
      $("#users_form").submit()
      
    if submitType is 2
      target = " suppliers/ban "
      $("#users_form").attr "action", target
      $("#users_form").submit()


  $("input:checkbox").click ->
    buttonsChecked = $("input:checkbox:checked")
    if buttonsChecked.length
      $("#ban_supplier").removeAttr "disabled"
      $("#warn_supplier").removeAttr "disabled"
    else
      $("#warn_supplier").attr "disabled", "disabled"
      $("#ban_supplier").attr "disabled", "disabled"
