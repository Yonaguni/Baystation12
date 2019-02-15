var/list/mining_walls = list()
var/list/mining_floors = list()

/**********************Mineral deposits**************************/
/turf/unsimulated/wall/natural
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"

/turf/simulated/wall/natural //wall piece
	name = "rock"
	icon_state = "rock_preview"
	initial_gas = null
	temperature = T0C
	floor_type = /turf/simulated/floor/asteroid
	var/material/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.
	var/image/ore_overlay

	has_resources = 1

/turf/simulated/wall/natural/New(var/newloc)
	if (!mining_walls["[src.z]"])
		mining_walls["[src.z]"] = list()
	mining_walls["[src.z]"] += src
	spawn(0)
		MineralSpread()
	spawn(2)
		update_icon(1)
	return ..(newloc, MATERIAL_LIMESTONE)

/turf/simulated/wall/natural/Destroy()
	if (mining_walls["[src.z]"])
		mining_walls["[src.z]"] -= src
	return ..()

/turf/simulated/wall/natural/can_build_cable()
	return !density

/turf/simulated/wall/natural/is_plating()
	return 1

/turf/simulated/wall/natural/on_update_icon(var/update_neighbors)

	..() //wall_icon cuts overlays and reconstructs wall
	//Now we need to reconstruct ore overlays etc.

	if(!istype(mineral))
		SetName(initial(name))
	else
		SetName("[mineral.ore_name] deposit")

	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(update_neighbors && istype(turf_to_check,/turf/simulated/floor/asteroid))
			var/turf/simulated/floor/asteroid/T = turf_to_check
			T.updateMineralOverlays()

	if(ore_overlay)
		overlays += ore_overlay

/turf/simulated/wall/natural/ex_act(severity)
	switch(severity)
		if(2.0)
			if (prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
		if(1.0)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

/turf/simulated/wall/natural/bullet_act(var/obj/item/projectile/Proj)

	// Emitter blasts
	if(istype(Proj, /obj/item/projectile/beam/emitter))
		emitter_blasts_taken++

		if(emitter_blasts_taken > 2) // 3 blasts per tile
			mined_ore = 1
			GetDrilled()

/turf/simulated/wall/natural/Bumped(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/weapon/pickaxe)) && (!H.hand))
			attackby(H.l_hand,H)
		else if((istype(H.r_hand,/obj/item/weapon/pickaxe)) && H.hand)
			attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/weapon/pickaxe))
			attackby(R.module_active,R)

/turf/simulated/wall/natural/proc/MineralSpread()
	if(istype(mineral) && mineral.ore_spread_chance > 0)
		for(var/trydir in GLOB.cardinal)
			if(prob(mineral.ore_spread_chance))
				var/turf/simulated/wall/natural/target_turf = get_step(src, trydir)
				if(istype(target_turf) && isnull(target_turf.mineral))
					target_turf.mineral = mineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()


/turf/simulated/wall/natural/proc/UpdateMineral()
	clear_ore_effects()
	ore_overlay = image('icons/turf/mining_decals.dmi', "[mineral.ore_icon_overlay]")
	if(prob(50))
		var/matrix/M = matrix()
		M.Scale(-1,1)
		ore_overlay.transform = M
	ore_overlay.color = mineral.icon_colour
	ore_overlay.layer = DECAL_LAYER
	update_icon()

//Not even going to touch this pile of spaghetti
/turf/simulated/wall/natural/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!user.IsAdvancedToolUser())
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if (istype(W, /obj/item/weapon/pickaxe))
		if(!istype(user.loc, /turf))
			return

		var/obj/item/weapon/pickaxe/P = W
		if(last_act + P.digspeed > world.time)//prevents message spam
			return
		last_act = world.time

		playsound(user, P.drill_sound, 20, 1)

		to_chat(user, "<span class='notice'>You start [P.drill_verb] \the [src].</span>")
		if(do_after(user,P.digspeed, src))
			to_chat(user, "<span class='notice'>You finish [P.drill_verb] \the [src].</span>")
			GetDrilled(0)
	else
		return ..()

/turf/simulated/wall/natural/proc/clear_ore_effects()
	overlays -= ore_overlay
	ore_overlay = null

/turf/simulated/wall/natural/proc/DropMineral()
	if(!mineral)
		return
	clear_ore_effects()
	return new /obj/item/weapon/ore(src, mineral.name)

/turf/simulated/wall/natural/proc/GetDrilled()
	//var/destroyed = 0 //used for breaking strange rocks
	if (mineral && mineral.ore_result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.ore_result_amount - mined_ore)
			DropMineral()

	var/turf/simulated/floor/asteroid/N = ChangeTurf(floor_type)
	if(istype(N))
		N.overlay_detail = "asteroid[rand(0,9)]"
		N.updateMineralOverlays(1)

/turf/simulated/wall/natural/random
	name = "mineral deposit"

/turf/simulated/wall/natural/random/New(var/newloc, var/mineral_name, var/default_mineral_list = GLOB.weighted_minerals_sparse)
	if(!mineral_name && LAZYLEN(default_mineral_list))
		mineral_name = pickweight(default_mineral_list)

	if(!mineral && mineral_name)
		mineral = SSmaterials.get_material_by_name(mineral_name)
	if(istype(mineral))
		UpdateMineral()
	..(newloc)

/turf/simulated/wall/natural/random/high_chance/New(var/newloc, var/mineral_name, var/default_mineral_list)
	..(newloc, mineral_name, GLOB.weighted_minerals_rich)

/**********************Asteroid**************************/

// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"

	initial_flooring = null
	initial_gas = null
	temperature = TCMB
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug
	var/overlay_detail
	has_resources = 1

/turf/simulated/floor/asteroid/New()
	if (!mining_floors["[src.z]"])
		mining_floors["[src.z]"] = list()
	mining_floors["[src.z]"] += src
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"

/turf/simulated/floor/asteroid/Destroy()
	if (mining_floors["[src.z]"])
		mining_floors["[src.z]"] -= src
	return ..()

/turf/simulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if (prob(70))
				gets_dug()
		if(1.0)
			gets_dug()
	return

/turf/simulated/floor/asteroid/is_plating()
	return !density

/turf/simulated/floor/asteroid/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!W || !user)
		return 0

	var/list/usable_tools = list(
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe/diamonddrill,
		/obj/item/weapon/pickaxe/drill,
		/obj/item/weapon/pickaxe/borgdrill
		)

	var/valid_tool
	for(var/valid_type in usable_tools)
		if(istype(W,valid_type))
			valid_tool = 1
			break

	if(valid_tool)
		if (dug)
			to_chat(user, "<span class='warning'>This area has already been dug</span>")
			return

		var/turf/T = user.loc
		if (!(istype(T)))
			return

		to_chat(user, "<span class='warning'>You start digging.</span>")
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

		if(!do_after(user,40, src)) return

		to_chat(user, "<span class='notice'>You dug a hole.</span>")
		gets_dug()

	else if(istype(W,/obj/item/weapon/storage/ore))
		var/obj/item/weapon/storage/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/weapon/ore/O in contents)
				O.attackby(W,user)
				return

	else
		..(W,user)
	return

/turf/simulated/floor/asteroid/proc/gets_dug()

	if(dug)
		return

	for(var/i=0;i<(rand(3)+2);i++)
		new/obj/item/weapon/ore/glass(src)

	dug = 1
	icon_state = "asteroid_dug"
	return

/turf/simulated/floor/asteroid/proc/updateMineralOverlays(var/update_neighbors)

	overlays.Cut()

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		if(istype(get_step(src, step_overlays[direction]), /turf/space))
			var/image/aster_edge = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = step_overlays[direction])
			aster_edge.layer = DECAL_LAYER
			overlays += aster_edge

	//todo cache
	if(overlay_detail)
		var/image/floor_decal = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
		floor_decal.layer = DECAL_LAYER
		overlays |= floor_decal

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				var/turf/simulated/floor/asteroid/A = get_step(src, direction)
				A.updateMineralOverlays()
			if(istype(get_step(src, direction), /turf/simulated/wall))
				var/turf/simulated/wall/W = get_step(src, direction)
				W.update_connections()
				W.update_icon()

/turf/simulated/floor/asteroid/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module)
			if(istype(R.module_state_1,/obj/item/weapon/storage/ore))
				attackby(R.module_state_1,R)
			else if(istype(R.module_state_2,/obj/item/weapon/storage/ore))
				attackby(R.module_state_2,R)
			else if(istype(R.module_state_3,/obj/item/weapon/storage/ore))
				attackby(R.module_state_3,R)
			else
				return
