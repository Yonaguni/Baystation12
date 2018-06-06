
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
	possible_transfer_amounts = "1;5;10"
	center_of_mass = "x=16;y=6"
	volume = 50

	attackby(var/obj/item/W, var/mob/user)
		return

	attack_self(var/mob/user)
		return

	attack(var/mob/M, var/mob/user, var/def_zone)
		if(standard_feed_mob(user, M))
			return

	afterattack(var/obj/target, var/mob/user, var/proximity)
		if(!proximity)
			return

		if(standard_dispenser_refill(user, target))
			return
		if(standard_pour_into(user, target))
			return

		if(istype(target, /obj/item/reagent_containers/food/snacks)) // These are not opencontainers but we can transfer to them
			if(!reagents || !reagents.total_volume)
				user << "<span class='notice'>There is no condiment left in \the [src].</span>"
				return

			if(!target.reagents.get_free_space())
				user << "<span class='notice'>You can't add more condiment to \the [target].</span>"
				return

			var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
			user << "<span class='notice'>You add [trans] units of the condiment to \the [target].</span>"
		else
			..()

	feed_sound(var/mob/user)
		playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

	self_feed_message(var/mob/user)
		user << "<span class='notice'>You swallow some of contents of \the [src].</span>"

	on_reagent_change()
		if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall" || icon_state == REAGENT_FLOUR)
			return
		if(reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if(REAGENT_KETCHUP)
					name = "Ketchup"
					desc = "You feel more American already."
					icon_state = "ketchup"
					center_of_mass = "x=16;y=6"
				if(REAGENT_CAPSAICIN)
					name = "Hotsauce"
					desc = "You can almost TASTE the stomach ulcers now!"
					icon_state = "hotsauce"
					center_of_mass = "x=16;y=6"
				if(REAGENT_ENZYME)
					name = "Universal Enzyme"
					desc = "Used in cooking various dishes."
					icon_state = "enzyme"
					center_of_mass = "x=16;y=6"
				if(REAGENT_SOYSAUCE)
					name = "Soy Sauce"
					desc = "A dark, salty, savoury flavoring."
					icon_state = "soysauce"
					center_of_mass = "x=16;y=6"
				if(REAGENT_FROSTOIL)
					name = "Coldsauce"
					desc = "Leaves the tongue numb in its passage."
					icon_state = "coldsauce"
					center_of_mass = "x=16;y=6"
				if(REAGENT_SALT)
					name = "Salt Shaker"
					desc = "Salt. From space oceans, presumably."
					icon_state = "saltshaker"
					center_of_mass = "x=16;y=10"
				if(REAGENT_PEPPER)
					name = "Pepper Mill"
					desc = "Often used to flavor food or make people sneeze."
					icon_state = "peppermillsmall"
					center_of_mass = "x=16;y=10"
				if(REAGENT_CORNOIL)
					name = "Corn Oil"
					desc = "A delicious oil used in cooking. Made from corn."
					icon_state = "oliveoil"
					center_of_mass = "x=16;y=6"
				if(REAGENT_SUGAR)
					name = "Sugar"
					desc = "Tastey space sugar!"
					center_of_mass = "x=16;y=6"
				else
					name = "Misc Condiment Bottle"
					if (reagents.reagent_list.len==1)
						desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
					else
						desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
					icon_state = "mixedcondiments"
					center_of_mass = "x=16;y=6"
		else
			icon_state = "emptycondiment"
			name = "Condiment Bottle"
			desc = "An empty condiment bottle."
			center_of_mass = "x=16;y=6"
			return

/obj/item/reagent_containers/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/reagent_containers/food/condiment/enzyme/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ENZYME, 50)

/obj/item/reagent_containers/food/condiment/sugar/Initialize(mapload)
	. =..()
	reagents.add_reagent(REAGENT_SUGAR, 50)

/obj/item/reagent_containers/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "Salt Shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = "1;20" //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_containers/food/condiment/saltshaker/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_SALT, 20)

/obj/item/reagent_containers/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = "1;20" //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_containers/food/condiment/peppermill/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_PEPPER, 20)

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"
	randpixel = 10

/obj/item/reagent_containers/food/condiment/flour/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_FLOUR, 30)

/obj/item/reagent_containers/food/condiment/soysauce
	name = "Soy-Sauce"
	desc = "A dark, salty, savoury flavoring."
	icon_state = "soysauce"
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_containers/food/condiment/soysauce/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_SOYSAUCE, 20)
