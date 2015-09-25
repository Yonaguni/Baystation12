/obj/item/weapon/mecha_equipment/mounted_system/drill
	icon_state = "mecha_drill"
	holding_type = /obj/item/weapon/pickaxe/drill
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/weapon/mecha_equipment/mounted_system/drill/diamond
	icon_state = "mecha_diamond_drill"
	holding_type = /obj/item/weapon/pickaxe/diamonddrill

/obj/item/weapon/mecha_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mecha_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/weapon/weldingtool/get_hardpoint_status_value()
	return (get_fuel()/max_fuel)

/obj/item/weapon/weldingtool/get_hardpoint_maptext()
	return "[get_fuel()]/[max_fuel]"

/obj/item/weapon/mecha_equipment/mounted_system/plasmacutter
	holding_type = /obj/item/weapon/pickaxe/plasmacutter
	restricted_software = list(MECH_SOFTWARE_UTILITY)