/atom
	var/obj/light/light_obj
	var/light_type = LIGHT_SOFT
	var/light_power = 1
	var/light_range = 1
	var/light_color = "#FFFFFF"

/atom/Destroy()
	if(light_obj)
		qdel(light_obj)
		light_obj = null
	return ..()

// Used to change hard BYOND opacity; this means a lot of updates are needed.
/atom/proc/set_opacity(var/newopacity)
	//world << "[src] calling set_opacity with value [newopacity]"
	opacity = newopacity ? 1 : 0
/*	var/turf/T = get_turf(src)
	if(istype(T))
		T.blocks_light = -1
		for(var/turf/neighbor in range(1, T))
			neighbor.has_corners = -1
		for(var/obj/light/L in range(get_turf(src), world.view)) //view(world.view, dview_mob))
			L.cast_light()
*/
