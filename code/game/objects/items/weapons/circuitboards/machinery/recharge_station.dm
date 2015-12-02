#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/recharge_station
	name = T_BOARD("cyborg recharging station")
	build_path = "/obj/machinery/recharge_station"
	board_type = "machine"
	req_components = list(
							"/obj/item/stack/cable_coil" = 5,
							"/obj/item/europa/component/capacitor" = 2,
							"/obj/item/europa/component/manipulator" = 2,
							"/obj/item/weapon/cell" = 1)