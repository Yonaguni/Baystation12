/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/list/code = list()
	var/list/lastattempt = list()
	var/attempts = 10
	var/codelen = 4
	locked = 1

/obj/structure/closet/crate/secure/loot/New()
	..()
	var/list/digits = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")

	for(var/i in 1 to codelen)
		code += pick(digits)
		digits -= code[code.len]

	generate_loot()

/obj/structure/closet/crate/secure/loot/proc/generate_loot()
	var/loot = rand(1, 98)
	switch(loot)
		if(1 to 5) // Common things go, 5%
			new/obj/item/reagent_containers/food/drinks/bottle/rum(src)
			new/obj/item/reagent_containers/food/drinks/bottle/whiskey(src)
			new/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus(src)
			new/obj/item/flame/lighter/zippo(src)
		if(6 to 10)
			new/obj/item/pickaxe/drill(src)
			new/obj/item/taperecorder(src)
			new/obj/item/clothing/suit/space(src)
			new/obj/item/clothing/head/helmet/space(src)
		if(11 to 15)
			new/obj/item/reagent_containers/glass/beaker/bluespace(src)
		if(16 to 20)
			for(var/i = 0, i < 10, i++)
				new/obj/item/ore/diamond(src)
		if(21 to 25)
			for(var/i = 0, i < 3, i++)
				new/obj/machinery/portable_atmospherics/hydroponics(src)
		if(26 to 30)
			for(var/i = 0, i < 3, i++)
				new/obj/item/reagent_containers/glass/beaker/noreact(src)
		if(31 to 35)
			spawn_money(rand(300,800), src)
		if(36 to 40)
			new/obj/item/melee/baton(src)
		if(41 to 45)
			new/obj/item/clothing/under/lower/shorts/red(src)
			new/obj/item/clothing/under/lower/shorts/blue(src)
		if(46 to 50)
			new/obj/item/clothing/under/chameleon(src)
			for(var/i = 0, i < 7, i++)
				new/obj/item/clothing/accessory/horrible(src)
		if(51 to 52) // Uncommon, 2% each
			new/obj/item/melee/classic_baton(src)
		if(53 to 54)
			new/obj/item/latexballon(src)
		if(55 to 56)
			var/newitem = pick(typesof(/obj/item/toy/prize) - /obj/item/toy/prize)
			new newitem(src)
		if(57 to 58)
			new/obj/item/toy/syndicateballoon(src)
		if(59 to 60)
			new/obj/item/rig(src)
		if(61 to 64)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				var/newcoin = pick(/obj/item/material/coin/silver, /obj/item/material/coin/silver, /obj/item/material/coin/silver, /obj/item/material/coin/iron, /obj/item/material/coin/iron, /obj/item/material/coin/iron, /obj/item/material/coin/gold, /obj/item/material/coin/diamond, /obj/item/material/coin/uranium, /obj/item/material/coin/platinum)
				new newcoin(src)
		if(65 to 68)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				var/newitem = pick(typesof(/obj/item/stock_parts) - /obj/item/stock_parts - /obj/item/stock_parts/subspace)
				new newitem(src)
		if(69 to 70)
			new/obj/item/pickaxe/silver(src)
		if(71 to 72)
			new/obj/item/pickaxe/drill(src)
		if(73 to 74)
			new/obj/item/pickaxe/jackhammer(src)
		if(75 to 76)
			new/obj/item/pickaxe/diamond(src)
		if(77 to 78)
			new/obj/item/pickaxe/diamonddrill(src)
		if(79 to 80)
			new/obj/item/pickaxe/gold(src)
		if(81 to 82)
			new/obj/item/pickaxe/plasmacutter(src)
		if(83 to 84)
			new/obj/item/toy/katana(src)
		if(85 to 86)
			new/obj/item/seeds/random(src)
		if(87, 88, 89, 90)
			new/obj/item/organ/internal/heart(src)
		if(91)
			new/obj/item/soulstone(src)
		if(92)
			new/obj/item/material/sword/katana(src)
		if(93, 94) // Why the hell not
			new/obj/item/storage/backpack/clown(src)
			new/obj/item/clothing/under/clown(src)
			new/obj/item/clothing/shoes/clown_shoes(src)
			new/obj/item/radio/headset/pda/clown(src)
			new/obj/item/clothing/mask/gas/clown_hat(src)
			new/obj/item/bikehorn(src)
			//new/obj/item/stamp/clown(src) I'd add it, but only clowns can use it
			new/obj/item/pen/crayon/rainbow(src)
			new/obj/item/toy/waterflower(src)
		if(95, 96)
			new/obj/item/melee/energy/sword(src)
		if(97)
			new/obj/item/storage/belt/champion(src)
			new/obj/item/clothing/mask/luchador(src)
		if(98)
			new/obj/item/clothing/head/bearpelt(src)

/obj/structure/closet/crate/secure/loot/togglelock(var/mob/user)
	if(!locked)
		return

	user << "<span class='notice'>The crate is locked with a Deca-code lock.</span>"
	var/input = input(user, "Enter [codelen] digits.", "Deca-Code Lock", "") as text
	if(!Adjacent(user))
		return

	if(input == null || length(input) != codelen)
		user << "<span class='notice'>You leave the crate alone.</span>"
	else if(check_input(input))
		user << "<span class='notice'>The crate unlocks!</span>"
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		set_locked(0)
	else
		visible_message("<span class='warning'>A red light on \the [src]'s control panel flashes briefly.</span>")
		attempts--
		if (attempts == 0)
			user << "<span class='danger'>The crate's anti-tamper system activates!</span>"
			var/turf/T = get_turf(src.loc)
			explosion(T, 0, 0, 1, 2)
			qdel(src)

/obj/structure/closet/crate/secure/loot/emag_act(var/remaining_charges, var/mob/user)
	if (locked)
		user << "<span class='notice'>The crate unlocks!</span>"
		locked = 0

/obj/structure/closet/crate/secure/loot/proc/check_input(var/input)
	if(length(input) != codelen)
		return 0

	. = 1
	lastattempt.Cut()
	for(var/i in 1 to codelen)
		var/guesschar = copytext(input, i, i+1)
		lastattempt += guesschar
		if(guesschar != code[i])
			. = 0

/obj/structure/closet/crate/secure/loot/attackby(var/obj/item/W, var/mob/user)
	if(locked)
		if (W.ismultitool()) // Greetings Urist McProfessor, how about a nice game of cows and bulls?
			user << "<span class='notice'>DECA-CODE LOCK ANALYSIS:</span>"
			if (attempts == 1)
				user << "<span class='warning'>* Anti-Tamper system will activate on the next failed access attempt.</span>"
			else
				user << "<span class='notice'>* Anti-Tamper system will activate after [src.attempts] failed access attempts.</span>"
			if(lastattempt.len)
				var/bulls = 0
				var/cows = 0

				var/list/code_contents = code.Copy()
				for(var/i in 1 to codelen)
					if(lastattempt[i] == code[i])
						++bulls
					else if(lastattempt[i] in code_contents)
						++cows
					code_contents -= lastattempt[i]
				user << "<span class='notice'>Last code attempt had [bulls] correct digits at correct positions and [cows] correct digits at incorrect positions.</span>"
			return
	..()
