/obj/item/gun_component/chamber/laser/smg
	icon_state="las_smg"
	name = "multiphase lens"
	weapon_type = GUN_SMG
	charge_cost = 250
	max_shots = 20
	fire_delay = 1
	ammo_indicator_state = "laser_smg_loaded"
	firemodes = list(
		list(mode_name="semiauto",      burst=1, fire_delay=0,    move_delay=null, requires_two_hands= 0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-shot bursts", burst=3, fire_delay=null, move_delay=5,    requires_two_hands= 1, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
		)
