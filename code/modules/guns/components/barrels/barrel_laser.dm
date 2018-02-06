/obj/item/gun_component/barrel/laser
	projectile_type = GUN_TYPE_LASER
	name = "projector"
	caliber = CALIBER_LASER
	var/assume_projectile
	weight_mod = 1
	recoil_mod = 0
	accuracy_mod = 1

/obj/item/gun_component/barrel/laser/taser
	caliber = CALIBER_LASER_TASER

/obj/item/gun_component/barrel/laser/get_projectile_type()
	return assume_projectile

/obj/item/gun_component/barrel/laser/New(var/newloc, var/weapontype, var/componenttype, var/use_model)
	..(newloc, weapontype, componenttype, use_model)
	update_from_caliber()

/obj/item/gun_component/barrel/laser/update_from_caliber()
	..()
	assume_projectile = get_laser_type_from_caliber(caliber)
	fire_sound = get_fire_sound_from_caliber(caliber)

/obj/item/gun_component/barrel/laser/rifle
	icon_state="las_rifle"
	weapon_type = GUN_RIFLE
	caliber = CALIBER_LASER_PRECISION
	accepts_accessories = 1
	accuracy_mod = 4

/obj/item/gun_component/barrel/laser/rifle_practice
	icon_state="las_rifle"
	weapon_type = GUN_RIFLE
	caliber = CALIBER_LASER_PRACTICE
	accepts_accessories = 1
	accuracy_mod = 4

/obj/item/gun_component/barrel/laser/cannon
	icon_state="las_cannon"
	weapon_type = GUN_CANNON
	caliber = CALIBER_LASER_HEAVY

/obj/item/gun_component/barrel/laser/assault_practice
	icon_state="las_assault"
	weapon_type = GUN_ASSAULT
	caliber = CALIBER_LASER_PRACTICE
