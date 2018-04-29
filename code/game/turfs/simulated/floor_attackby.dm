/turf/simulated/floor/attackby(obj/item/C as obj, var/mob/user)

	if(!C || !user)
		return 0

	if(C.iscoil() || (flooring && istype(C, /obj/item/stack/rods)))
		return ..(C, user)

	if(flooring)
		if(C.iscrowbar())
			if(broken || burnt)
				user << "<span class='notice'>You remove the broken [flooring.descriptor].</span>"
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				user << "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>"
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				user << "<span class='notice'>You lever off the [flooring.descriptor].</span>"
				make_plating(1)
			else
				return
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			return
		else if(C.isscrewdriver() && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			user << "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>"
			make_plating(1)
			playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
			return
		else if(C.iswrench() && (flooring.flags & TURF_REMOVE_WRENCH))
			user << "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>"
			make_plating(1)
			playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/pickaxe/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			user << "<span class='notice'>You shovel off the [flooring.descriptor].</span>"
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return
		else if(C.iscoil())
			user << "<span class='warning'>You must remove the [flooring.descriptor] first.</span>"
			return
	else

		if(istype(C, /obj/item/stack))
			if(broken || burnt)
				user << "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>"
				return
			var/obj/item/stack/S = C
			if(!S.builds_flooring)
				return
			var/decl/flooring/use_flooring = get_flooring_data(S.builds_flooring)
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				user << "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>"
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs.
		else if(C.iswelder())
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0,user))
						user << "<span class='notice'>You fix some dents on the broken plating.</span>"
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						user << "<span class='warning'>You need more welding fuel to complete this task.</span>"
					return
	return ..()


/turf/simulated/floor/can_build_cable(var/mob/user)
	if(!is_plating() || flooring)
		user << "<span class='warning'>Removing the tiling first.</span>"
		return 0
	if(broken || burnt)
		user << "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>"
		return 0
	return 1
