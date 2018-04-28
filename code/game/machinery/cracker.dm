/obj/machinery/portable_atmospherics/cracker
	name = "molecular cracking unit"
	desc = "An integrated catalytic water cracking system used to break H2O down into H and O. An advanced molecular extractor also allows it to isolate liquid deuterium from seawater."
	icon = 'icons/obj/machines/cracker.dmi'
	icon_state = "cracker"
	density = 1
	anchored = 1
	waterproof = TRUE

	var/list/reagent_buffer = list()
	var/tmp/fluid_consumption_per_tick = 100
	var/tmp/gas_generated_per_tick = 1
	var/tmp/max_reagents = 100
	var/tmp/deuterium_generation_chance = 10
	var/tmp/deuterium_generation_amount = 1

	volume = 5000
	use_power = 1
	idle_power_usage = 100
	active_power_usage = 10000

/obj/machinery/portable_atmospherics/cracker/update_icon()
	if(use_power == 2)
		icon_state = "cracker_on"
	else
		icon_state = "cracker"

/obj/machinery/portable_atmospherics/cracker/attack_ai(var/mob/user)
	if(istype(user, /mob/living/silicon/ai) || user.Adjacent(src))
		attack_hand(user)

/obj/machinery/portable_atmospherics/cracker/attack_hand(var/mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	if(use_power == 1)
		use_power = 2
	else
		use_power = 1
	user.visible_message("<span class='notice'>\The [user] [use_power == 2 ? "engages" : "disengages"] \the [src].</span>")
	update_icon()

/obj/machinery/portable_atmospherics/cracker/attackby(var/obj/item/thing, var/mob/user)
	// remove deuterium as a reagent
	if(thing.is_open_container() && thing.reagents)
		if(!reagent_buffer["deuterium"] || reagent_buffer["deuterium"] <= 0)
			to_chat(user, "<span class='warning'>There is no deuterium stored in \the [src].</span>")
			return
		var/transfer_amt = min(thing.reagents.maximum_volume, reagent_buffer["deuterium"])
		thing.reagents.add_reagent("deuterium", transfer_amt)
		thing.update_icon()
		reagent_buffer["deuterium"] -= transfer_amt
		user.visible_message("<span class='notice'>\The [user] siphons [transfer_amt] unit\s of deuterium from \the [src] into \the [thing].</span>")
		return
	. = ..()

/obj/machinery/portable_atmospherics/cracker/process()

	. = ..()

	if(. == PROCESS_KILL)
		return

	if(stat & (BROKEN|NOPOWER))
		use_power = 1
		update_icon()
		return

	if(use_power == 1)
		return

	// Produce materials.
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/fluid/F = T.return_fluid()
		if(istype(F))

			// Drink more water!
			var/consuming = min(F.fluid_amount, fluid_consumption_per_tick)
			LOSE_FLUID(F, consuming)
			T.show_bubbles()

			// Gas production.
			var/datum/gas_mixture/produced = new
			var/gen_amt = min(1, (gas_generated_per_tick * (consuming/fluid_consumption_per_tick)))
			produced.adjust_gas("oxygen",  gen_amt)
			produced.adjust_gas("hydrogen", gen_amt * 2)
			produced.temperature = T20C //todo water temperature
			air_contents.merge(produced)

			// Deuterium extraction.
			if(prob(deuterium_generation_chance) && (!reagent_buffer["deuterium"] || reagent_buffer["deuterium"] <= max_reagents))
				if(!reagent_buffer["deuterium"])
					reagent_buffer["deuterium"] = 0
				reagent_buffer["deuterium"] += deuterium_generation_amount
