/obj/item/reagent_containers/food/snacks/meat/fish
	name = "fillet"
	desc = "A fillet of fish."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = "x=17;y=13"
	var/fish_type = "fish"

// Subtypes.
/obj/item/reagent_containers/food/snacks/meat/fish/carp
	fish_type = "carp"

/obj/item/reagent_containers/food/snacks/meat/fish/shark
	fish_type = "shark"

/obj/item/reagent_containers/food/snacks/meat/fish/octopus
	fish_type = "tako"

/obj/item/reagent_containers/food/snacks/meat/fish/chicken
	fish_type = "chicken" // �\_(:))_/�

// End subtypes.

/obj/item/reagent_containers/food/snacks/meat/fish/produce_sliced_product()
	new /obj/item/reagent_containers/food/snacks/sashimi(get_turf(src), fish_type)
	new /obj/item/reagent_containers/food/snacks/sashimi(get_turf(src), fish_type)
	new /obj/item/reagent_containers/food/snacks/sashimi(get_turf(src), fish_type)

/obj/item/reagent_containers/food/snacks/meat/fish/poison/initialize()
	..()
	reagents.add_reagent(REAGENT_CARPOTOXIN, 6)

///////////
// SUSHI //
///////////
/obj/item/reagent_containers/food/snacks/sushi
	name = "sushi"
	desc = "A small, neatly wrapped morsel. Itadakimasu!"
	icon = 'icons/obj/food/sushi.dmi'
	icon_state = "sushi_rice"
	var/fish_type = "fish"

/obj/item/reagent_containers/food/snacks/sushi/New(var/newloc, var/obj/item/reagent_containers/food/snacks/rice, var/obj/item/reagent_containers/food/snacks/topping)
	..(newloc)

	if(istype(topping))

		for(var/taste_thing in topping.nutriment_desc)
			if(!nutriment_desc[taste_thing]) nutriment_desc[taste_thing] = 0
			nutriment_desc[taste_thing] += topping.nutriment_desc[taste_thing]

		if(istype(topping, /obj/item/reagent_containers/food/snacks/sashimi))
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = topping
			fish_type = sashimi.fish_type
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/friedegg))
			fish_type = "egg"
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/tofu))
			fish_type = "tofu"
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/rawcutlet) || istype(topping, /obj/item/reagent_containers/food/snacks/cutlet))
			fish_type = "meat"

		if(topping.reagents) topping.reagents.trans_to(src, topping.reagents.total_volume)
		var/mob/M = topping.loc
		if(istype(M)) M.drop_from_inventory(topping)
		qdel(topping)

	if(istype(rice))
		if(rice.reagents)
			rice.reagents.trans_to(src, 1)
		if(!rice.reagents || !rice.reagents.total_volume)
			var/mob/M = rice.loc
			if(istype(M)) M.drop_from_inventory(rice)
			qdel(rice)

	update_icon()

/obj/item/reagent_containers/food/snacks/sushi/update_icon()
	name = "[fish_type] sushi"
	overlays = list("[fish_type]", "nori")

/////////////
// SASHIMI //
/////////////
/obj/item/reagent_containers/food/snacks/sashimi
	name = "sashimi"
	icon = 'icons/obj/food/sushi.dmi'
	desc = "Thinly sliced raw fish. Tasty."
	icon_state = "sashimi"
	gender = PLURAL
	var/fish_type = "fish"
	var/slices = 1

/obj/item/reagent_containers/food/snacks/sashimi/New(var/newloc, var/_fish_type)
	..(newloc)
	if(_fish_type) fish_type = _fish_type
	name = "[fish_type] sashimi"
	update_icon()

/obj/item/reagent_containers/food/snacks/sashimi/update_icon()
	icon_state = "sashimi_base"
	var/list/adding = list()
	var/slice_offset = (slices-1)*2
	for(var/slice = 1 to slices)
		var/image/I = image(icon = 'icons/obj/food/sushi.dmi', icon_state = "sashimi")
		I.pixel_x = slice_offset-((slice-1)*4)
		I.pixel_y = I.pixel_x
		adding += I
	overlays = adding

/obj/item/reagent_containers/food/snacks/sashimi/attackby(var/obj/item/I, var/mob/user)

	if(locate(/obj/structure/table) in loc)

		// Add more slices.
		if(istype(I, /obj/item/reagent_containers/food/snacks/sashimi))
			var/obj/item/reagent_containers/food/snacks/sashimi/other_sashimi = I
			if(slices + other_sashimi.slices > 5)
				to_chat(user, "<span class='warning'>Show some restraint, would you?</span>")
				return
			slices += other_sashimi.slices
			update_icon()
			user.drop_from_inventory(I)
			if(I.reagents) I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)
			return

		// Make sushi.
		if(istype(I, /obj/item/reagent_containers/food/snacks/boiledrice))
			if(slices > 1)
				to_chat(user, "<span class='warning'>Putting more than one slice of fish on your sushi is just greedy.</span>")
			else
				new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), I, src)
			return
	. = ..()

// Used for turning rice into sushi.
/obj/item/reagent_containers/food/snacks/boiledrice/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc))

		if(istype(I, /obj/item/reagent_containers/food/snacks/sashimi))
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = I
			if(sashimi.slices > 1)
				to_chat(user, "<span class='warning'>Putting more than one slice of fish on your sushi is just greedy.</span>")
			else
				new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), src, I)
			return

		if(istype(I, /obj/item/reagent_containers/food/snacks/friedegg) || \
		 istype(I, /obj/item/reagent_containers/food/snacks/tofu) || \
		 istype(I, /obj/item/reagent_containers/food/snacks/cutlet) || \
		 istype(I, /obj/item/reagent_containers/food/snacks/rawcutlet))
			new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), src, I)
			return
	. = ..()

// Used for turning other food into sushi.
/obj/item/reagent_containers/food/snacks/friedegg/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), I, src)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/tofu/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), I, src)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/rawcutlet/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), I, src)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/cutlet/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), I, src)
		return
	. = ..()
// End non-fish sushi.
