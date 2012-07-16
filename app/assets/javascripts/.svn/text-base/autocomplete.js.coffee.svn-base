$(document).ready ->
	$('#need_name_auto').autocomplete
		source: "/autocomplete/needs_categories"
		focus: (event,ui) -> 
			$("#need_id").val(ui.item.id)
			$("#autocomplete_type").val(ui.item.type)
			$("#need_name_auto").val(ui.item.name)

	$('#need_name').autocomplete
		source: "/autocomplete/needs"
		focus: (event,ui) -> 
			$("#need_id").val(ui.item.id)
			$("#need_name").val(ui.item.name)
			$("#autocomplete_type").val(ui.item.type+'_new')

	$("#need_search").submit (e) ->
		e.preventDefault()  unless $("#need_name_auto").val()