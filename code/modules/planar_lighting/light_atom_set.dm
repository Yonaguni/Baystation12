// Destroys and removes a light; replaces previous system's set_light(0).
/atom/proc/kill_light()
	if(light_obj)
		qdel(light_obj)
		light_obj = null
	return

// Updates all appropriate lighting values and then applies all changed values
// to the objects light_obj overlay atom.
/atom/proc/set_light(var/l_range, var/l_power, var/l_color, var/fadeout)

	// Update or retrieve our variable data.
	if(isnull(l_range))
		l_range = light_range
	else
		light_range = l_range
//	if(isnull(l_power))
//		l_power = light_power
//	else
//		light_power = l_power
	if(isnull(l_color))
		l_color = light_color
	else
		light_color = l_color

	// Apply data and update light casting/bleed masking.
	var/update_cast
	if(!light_obj)
		update_cast = 1
		light_obj = new(src)
//	var/use_alpha = max(1,min(255,(l_power * 50)))
//	if(light_obj.light_overlay.alpha != use_alpha)
//		update_cast = 1
//		light_obj.light_overlay.alpha = use_alpha
	if(light_obj.color != l_color)
		update_cast = 1
		light_obj.color = l_color
//	if(light_obj.light_overlay.icon_state != light_type)
//		update_cast = 1
//		light_obj.light_overlay.icon_state = light_type
	if(light_obj.light_range != l_range)
		update_cast = 1
		light_obj.light_range = l_range

	// Makes sure the obj isn't somewhere weird (like inside the holder). Also calls bleed masking.
	if(update_cast)
		light_obj.follow_holder()

	// Rare enough that we can probably get away with calling animate(). Currently used by muzzle flashes and sparks.
//	if(fadeout) animate(light_obj, time=fadeout, alpha=0)
