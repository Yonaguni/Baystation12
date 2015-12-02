#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/pacman
	name = T_BOARD("PACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman"
	board_type = "machine"
	req_components = list(
							"/obj/item/europa/component/matter_bin" = 1,
							"/obj/item/europa/component/micro_laser" = 1,
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/europa/component/capacitor" = 1)

/obj/item/weapon/circuitboard/pacman/super
	name = T_BOARD("SUPERPACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman/super"

/obj/item/weapon/circuitboard/pacman/mrs
	name = T_BOARD("MRSPACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman/mrs"
