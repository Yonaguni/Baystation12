/obj/item/gun_component/stock
	name = "stock"
	component_type = COMPONENT_STOCK
	w_class = 2
	icon = 'icons/obj/gun_components/stock.dmi'

	accuracy_mod = 1
	recoil_mod = -1
	weight_mod = 1

/obj/item/gun_component/stock/smg
	icon_state = "smg"
	weapon_type = GUN_SMG
	has_alt_interaction = 1
	color = COLOR_GUNMETAL
	var/folded = 0

/obj/item/gun_component/stock/rifle
	icon_state = "rifle"
	weapon_type = GUN_RIFLE

/obj/item/gun_component/stock/rifle/am
	icon_state="sniper"

/obj/item/gun_component/stock/cannon
	icon_state = "cannon"
	weapon_type = GUN_CANNON
	weight_mod = 2

/obj/item/gun_component/stock/assault
	icon_state = "assault"
	weapon_type = GUN_ASSAULT

/obj/item/gun_component/stock/shotgun
	icon_state = "shotgun"
	weapon_type = GUN_SHOTGUN

/obj/item/gun_component/stock/shotgun/combat
	icon_state = "shotgun_combat"

/obj/item/gun_component/stock/pistol/laser
	icon_state = "las_pistol"
	projectile_type = GUN_TYPE_LASER
	weight_mod = 0

/obj/item/gun_component/stock/smg/laser
	icon_state = "las_smg"
	projectile_type = GUN_TYPE_LASER
	weight_mod = 0

/obj/item/gun_component/stock/rifle/laser
	icon_state = "las_assault"
	projectile_type = GUN_TYPE_LASER
	accuracy_mod = 2

/obj/item/gun_component/stock/cannon/laser
	icon_state = "las_cannon"
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/stock/assault/laser
	icon_state = "las_assault"
	projectile_type = GUN_TYPE_LASER

/obj/item/gun_component/stock/shotgun/laser
	icon_state = "las_shotgun"
	projectile_type = GUN_TYPE_LASER
