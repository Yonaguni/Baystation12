/datum/job/head
	title = "Colony Liaison"
	flag = LIAISON
	department_flag = CIVILIAN
	total_positions = 1
	spawn_positions = 1
	supervisors = "Jovian authorities"
	department = "Civil Sector"
	faction = "Station"
	head_position = 1
	req_admin_notify = 1
	minimal_access = list()
	selection_color = "#dddddd"
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
            access_heads, access_construction, access_sec_doors, access_medical, access_medical_equip, access_morgue,
			access_genetics, access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_psychiatrist)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
            access_heads, access_construction, access_sec_doors, access_medical, access_medical_equip, access_morgue,
			access_genetics, access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_psychiatrist)

/datum/job/head/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	..(H) // Same as all the nobodies.
	//TODO: Access cards, documentation, any other specialist gear.

/datum/job/head/marshal
	title = "Marshal"
	flag = MARSHAL
	department_flag = GOVERNMENT
	department = "Government Sector"
	selection_color = "#ccccff"
	idtype = /obj/item/weapon/card/id/europa/dogtags
	headsettype = /obj/item/device/radio/headset/headset_sec
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_forensics_lockers,
			access_morgue, access_maint_tunnels, access_all_personal_lockers, access_research, access_engine,
			access_mining, access_medical, access_construction, access_mailsorting, access_heads, access_hos,
			access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_forensics_lockers,
			access_morgue, access_maint_tunnels, access_all_personal_lockers, access_research, access_engine,
			access_mining, access_medical, access_construction, access_mailsorting, access_heads, access_hos,
			access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)

/datum/job/head/marshal/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/under/europa/petty_officer/marshal(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/grey(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/europa/petty_officer/marshal(H), slot_head)
	return 1

/datum/job/head/coordinator
	flag = CCO
	department_flag = INDUSTRY
	title = "Corporate Contact Officer"
	supervisors = "your corporate overseers"
	selection_color = "#ffeeff"
	department = "Industrial Sector"
	idtype = /obj/item/weapon/card/id/europa/lanyard
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors, access_mining, access_mining_station,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
						access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors, access_mining, access_mining_station,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
						access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm)

/datum/job/head/coordinator/equip(var/mob/living/carbon/human/H)
	if(!H) return 0
	//TODO: keycard, headset, weapon.
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/internalaffairs(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/internalaffairs(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_l_hand)
	return 1
