/datum/random_map/noise/seafloor
	descriptor = "Europan seafloor (roundstart)"
	smoothing_iterations = 3
	target_turf_type = /turf/unsimulated/ocean

/datum/random_map/noise/seafloor/get_appropriate_path(var/value)
	return

/datum/random_map/noise/seafloor/get_additional_spawns(var/value, var/turf/T)
	var/val = min(9,max(0,round((value/cell_range)*10)))

	var/turf/unsimulated/ocean/O = T
	if(!istype(O) || !O.detail_decal) // Only draw over naked ocean turfs.
		return

	if(isnull(val)) val = 0
	switch(val)
		if(6)
			if(prob(60))
				new /obj/structure/seaweed(T)
		if(7)
			if(prob(60))
				new /obj/structure/seaweed(T)
			else if(prob(30))
				new /obj/structure/seaweed/large(T)
			else
				new /obj/structure/seaweed/glow(T)
		if(8)
			if(prob(60))
				new /obj/structure/seaweed/glow(T)
			else if(prob(30))
				new /obj/structure/seaweed(T)
			else
				new /obj/structure/seaweed/large(T)
		if(9)
			if(prob(70))
				new /obj/structure/seaweed/large(T)
			else
				new /obj/structure/seaweed/glow(T)
			if(prob(1))
				new /mob/living/simple_animal/hostile/retaliate/europa_shark(T)
	switch(val)
		if(6)
			T.icon_state = "mud_light"
		if(7 to 9)
			T.icon_state = "mud_dark"