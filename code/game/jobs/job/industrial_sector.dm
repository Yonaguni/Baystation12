/datum/job/industry
	title = "Employee"
	flag = WORKER
	department_flag = INDUSTRY
	department = "Industrial Sector"
	faction = "Station"
	total_positions = 6
	spawn_positions = 4
	supervisors = "the board of investors and colonial law"
	selection_color = "#ffeeff"
	alt_titles = list("Factory Worker", "Miner", "Shipping Clerk", "Fabrication Technician")
	idtype = /obj/item/weapon/card/id/europa/corpcard
	access = list(access_tox, access_genetics, access_morgue,
			      access_tox_storage, access_teleporter, access_sec_doors,
			      access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			      access_RC_announce, access_tcomsat, access_gateway, access_xenoarch, access_maint_tunnels,
			      access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_tox, access_genetics, access_morgue,
			      access_tox_storage, access_teleporter, access_sec_doors,
			      access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			      access_RC_announce, access_tcomsat, access_gateway, access_xenoarch, access_maint_tunnels,
			      access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)

/datum/job/industry/science
	title = "Scientist"
	flag = SCIENTIST
	total_positions = 5
	spawn_positions = 3
	supervisors = "the funding committee and colonial law"
	alt_titles = list("Xenobiologist","Field Technician")
	idtype = /obj/item/weapon/card/id/europa/lanyard

/datum/job/industry/science/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/science(H), slot_wear_suit)
	return 1