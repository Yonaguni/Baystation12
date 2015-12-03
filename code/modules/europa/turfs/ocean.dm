#define OCEAN_SPREAD_DEPTH 500

var/image/ocean_overlay_img
/proc/get_ocean_overlay()
	if(!ocean_overlay_img)
		ocean_overlay_img = image('icons/effects/xgm_overlays.dmi', "ocean")
		ocean_overlay_img.color = "#66D1FF"
		ocean_overlay_img.layer = GAS_OVERLAY_LAYER+0.1 //So it renders over other gas mixes (hypothetically)
		ocean_overlay_img.alpha = GAS_MAX_ALPHA
		ocean_overlay_img.mouse_opacity = 0

	return ocean_overlay_img

/turf/unsimulated/fake_ocean
	name = "seafloor"
	desc = "Silty."
	density = 0
	opacity = 0
	blocks_air = 1
	icon = 'icons/turf/seafloor.dmi'
	icon_state = "seafloor"

/turf/unsimulated/fake_ocean/New()
	..()
	if(prob(20)) overlays |= get_mining_overlay("asteroid[rand(0,9)]")
	overlays |= get_ocean_overlay()

/turf/unsimulated/ocean
	name = "seafloor"
	desc = "Silty."
	density = 0
	opacity = 0
	blocks_air = 1
	var/sleeping = 0
	icon = 'icons/turf/seafloor.dmi'
	icon_state = "seafloor"
	var/datum/gas_mixture/water
	var/detail_decal
	accept_lattice = 1

/turf/unsimulated/ocean/is_plating()
	return 1

/turf/unsimulated/ocean/get_fluid_depth()
	return 1200

/turf/unsimulated/ocean/abyss_open
	name = "abyss"
	desc = "You're pretty sure it's staring into you."
	density = 1
	icon_state = "abyss"
	detail_decal = 0

/turf/unsimulated/ocean/plating
	name = "plating"
	desc = "The naked hull."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	detail_decal = 0

/turf/unsimulated/ocean/abyss
	name = "sand"
	desc = "Uncomfortably gritty."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/unsimulated/ocean/abyss/plating
	name = "stone floor"
	desc = "Waterlogged and decrepit."
	icon_state = "asteroidfloor"
	detail_decal = 0

/turf/unsimulated/ocean/New()
	..()
	processing_turfs -= src
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		initialize()
	else
		init_turfs += src

/turf/unsimulated/ocean/initialize()
	processing_turfs += src
	update_icon()

/turf/unsimulated/ocean/update_icon()
	overlays.Cut()
	..()
	if(isnull(detail_decal))
		if(prob(20))
			detail_decal = "asteroid[rand(0,9)]"
		else
			detail_decal = 0
	if(detail_decal)
		overlays |= get_mining_overlay(detail_decal)
	overlays |= get_ocean_overlay()

/turf/unsimulated/ocean/Destroy()
	processing_turfs -= src
	..()

/turf/unsimulated/ocean/proc/can_spread_into(var/turf/simulated/target)
	if (!target || target.density || !Adjacent(target))
		return 0
	for(var/obj/O in target.contents)
		if(!O.CanAtmosPass(src))
			return 0
	return 1

/turf/unsimulated/ocean/proc/refresh()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		sleeping = 0
		processing_turfs |= src

/turf/unsimulated/ocean/process()
	sleeping = 1
	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in src)
		blocked_dirs |= W.dir
	for(var/obj/machinery/door/window/D in src)
		blocked_dirs |= D.dir
	for(var/step_dir in cardinal)
		var/turf/simulated/T = get_step(src, step_dir)
		if(!istype(T) || istype(T, /turf/simulated/open) || !can_spread_into(T) || (get_dir(src,T) in blocked_dirs))
			continue
		var/datum/gas_mixture/GM = T.return_air()
		if(GM && GM.gas["water"] < 1500)
			GM.adjust_gas("water", 1500, 1)
			T.air_update_turf()
		sleeping = 0
	if(sleeping)
		processing_turfs -= src

/turf/unsimulated/ocean/is_flooded()
	return 1

/turf/unsimulated/ocean/return_air()
	if(!water)
		water = new/datum/gas_mixture      // Make our 'air', freezing water.
		water.temperature = 250            // -24C
		water.adjust_gas("water", 1500, 1) // Should be higher.
		water.volume = CELL_VOLUME
	return water

#undef OCEAN_SPREAD_DEPTH

/turf/simulated/floor/fixed/dirt
	name = "seafloor"
	desc = "Silthy."
	icon = 'icons/turf/floors.dmi'
	icon_state = "seafloor"
	accept_lattice = 1
