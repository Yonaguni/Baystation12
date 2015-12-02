/obj/item/weapon/gun/energy/taser
	name = "electroshock pistol"
	desc = "This small, rather cheaply produced weapon is a staple non-lethal takedown method. It uses a laser-induced plasma channel to stun and incapacitate unarmoured targets."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	max_shots = 5
	projectile_type = /obj/item/projectile/beam/stun

/obj/item/weapon/gun/energy/taser/mounted
	name = "mounted electroshock gun"
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/taser/mounted/cyborg
	name = "mounted electrolaser"
	max_shots = 6
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)

/obj/item/weapon/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A variant of the electroshock pistol that uses a revolving cylinder of self-contained piezo-electric shells rather than a battery and projector plate."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	projectile_type = /obj/item/projectile/energy/electrode
	max_shots = 8

/obj/item/weapon/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon_state = "crossbow"
	w_class = 2.0
	item_state = "crossbow"
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	slot_flags = SLOT_BELT
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 5
	self_recharge = 1
	charge_meter = 0

/obj/item/weapon/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart

/obj/item/weapon/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = 4
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200000)
	projectile_type = /obj/item/projectile/energy/bolt/large
