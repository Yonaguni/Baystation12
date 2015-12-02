#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/biogenerator
	name = T_BOARD("biogenerator")
	build_path = "/obj/machinery/biogenerator"
	board_type = "machine"
	req_components = list(
							"/obj/item/europa/component/matter_bin" = 1,
							"/obj/item/europa/component/manipulator" = 1)