/datum/admins/proc/print_chemistry_recipes_wiki()
	set name = "Print Wiki Chemistry Info"
	set category = "Debug"
	set desc = "Outputs all valid recipes in Github Wiki markdown format."

	usr << "<br>"
	usr << "| Chemical | Recipe | Product | Effects |"
	usr << "| --- | --- | --- | --- | --- | --- | --- |"

	var/list/checked = list()

	for(var/var/datum/chemical_reaction/react in all_chemical_reactions)
		if(!istype(react) || react.loaded_at_runtime || !react.required_reagents || !react.required_reagents.len)
			continue
		var/datum/reagent/reagent = chemical_reagents_list[react.result]
		if(!istype(reagent))
			continue
		checked += react.id

		var/recipe_string = ""
		for(var/rid in react.required_reagents)
			recipe_string += "[react.required_reagents[rid]] [rid] "
		if(react.catalysts && react.catalysts.len)
			recipe_string += "**Catalysts:** "
			for(var/rid in react.catalysts)
				recipe_string += "[react.catalysts[rid]] [rid] "
		if(react.inhibitors && react.inhibitors.len)
			recipe_string += "**Inhibitors:** "
			for(var/rid in react.inhibitors)
				recipe_string += "[react.inhibitors[rid]] [rid] "

		usr <<  "| [react.name] | [recipe_string] | [react.result_amount]u | [reagent.description] |"

	usr << "<br>"
	usr << "| Chemical | Effects |"
	usr << "| --- | --- |"

	for(var/rid in chemical_reagents_list)
		if(rid in checked)
			continue
		var/datum/reagent/reagent = chemical_reagents_list[rid]
		usr <<  "| [reagent.name] | [reagent.description] |"

	usr << "<br>"
