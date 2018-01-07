/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if(ticker.mode && ticker.mode.check_antagonists_topic(href, href_list))
		check_antagonists()
		return

	if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			log_admin("[key_name(usr)] attempted to edit the admin permissions without sufficient rights.")
			return

		var/adm_ckey

		var/task = href_list["editrights"]
		if(task == "add")
			var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
			if(!new_ckey)	return
			if(new_ckey in admin_datums)
				usr << "<font color='red'>Error: Topic 'editrights': [new_ckey] is already an admin</font>"
				return
			adm_ckey = new_ckey
			task = "rank"
		else if(task != "show")
			adm_ckey = ckey(href_list["ckey"])
			if(!adm_ckey)
				usr << "<font color='red'>Error: Topic 'editrights': No valid ckey</font>"
				return

		var/datum/admins/D = admin_datums[adm_ckey]

		if(task == "remove")
			if(alert("Are you sure you want to remove [adm_ckey]?","Message","Yes","Cancel") == "Yes")
				if(!D)	return
				admin_datums -= adm_ckey
				D.disassociate()

				message_admins("[key_name_admin(usr)] removed [adm_ckey] from the admins list")
				log_admin("[key_name(usr)] removed [adm_ckey] from the admins list")
				log_admin_rank_modification(adm_ckey, "Removed")

		else if(task == "rank")
			var/new_rank
			if(admin_ranks.len)
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (admin_ranks|"*New Rank*")
			else
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

			var/rights = 0
			if(D)
				rights = D.rights
			switch(new_rank)
				if(null,"") return
				if("*New Rank*")
					new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text
					if(!config.sql_enabled)
						new_rank = ckeyEx(new_rank)
					if(!new_rank)
						usr << "<font color='red'>Error: Topic 'editrights': Invalid rank</font>"
						return
					if(!config.sql_enabled)
						if(admin_ranks.len)
							if(new_rank in admin_ranks)
								rights = admin_ranks[new_rank]		//we typed a rank which already exists, use its rights
							else
								admin_ranks[new_rank] = 0			//add the new rank to admin_ranks
				else
					if(!config.sql_enabled)
						new_rank = ckeyEx(new_rank)
						rights = admin_ranks[new_rank]				//we input an existing rank, use its rights

			if(D)
				D.disassociate()								//remove adminverbs and unlink from client
				D.rank = new_rank								//update the rank
				D.rights = rights								//update the rights based on admin_ranks (default: 0)
			else
				D = new /datum/admins(new_rank, rights, adm_ckey)

			var/client/C = directory[adm_ckey]						//find the client with the specified ckey (if they are logged in)
			D.associate(C)											//link up with the client and add verbs

			C << "[key_name_admin(usr)] has set your admin rank to: [new_rank]."
			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin("[key_name(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin_rank_modification(adm_ckey, new_rank)

		else if(task == "permissions")
			if(!D)	return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_MAXPERMISSION, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
			if(!new_permission)	return
			D.rights ^= permissionlist[new_permission]

			var/client/C = directory[adm_ckey]
			C << "[key_name_admin(usr)] has toggled your permission: [new_permission]."
			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin("[key_name(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin_permission_modification(adm_ckey, permissionlist[new_permission])

		edit_admin_permissions()

	else if(href_list["call_shuttle"])

		if(!check_rights(R_ADMIN))	return

		if (!ticker || !evacuation_controller)
			return

		if( ticker.mode.name == "blob" )
			alert("You can't call the shuttle during blob!")
			return

		switch(href_list["call_shuttle"])
			if("1")
				if (evacuation_controller.call_evacuation(usr, TRUE))
					log_admin("[key_name(usr)] called an evacuation.")
					message_admins("\blue [key_name_admin(usr)] called an evacuation.", 1)
			if("2")
				if (evacuation_controller.cancel_evacuation())
					log_admin("[key_name(usr)] cancelled an evacuation.")
					message_admins("\blue [key_name_admin(usr)] cancelled an evacuation.", 1)

		href_list["secretsadmin"] = "check_antagonist"

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))	return

		ticker.delay_end = !ticker.delay_end
		log_admin("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins("\blue [key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].", 1)
		href_list["secretsadmin"] = "check_antagonist"

	else if(href_list["simplemake"])

		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/delmob = 0
		switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
			if("Cancel")	return
			if("Yes")		delmob = 1

		log_admin("[key_name(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")
		message_admins("\blue [key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]", 1)

		switch(href_list["simplemake"])
			if("observer")			M.change_mob_type( /mob/observer/ghost , null, null, delmob )
			if("larva")				M.change_mob_type( /mob/living/carbon/alien/larva , null, null, delmob )
			if("nymph")				M.change_mob_type( /mob/living/carbon/alien/diona , null, null, delmob )
			if("human")				M.change_mob_type( /mob/living/carbon/human , null, null, delmob, href_list["species"])
			if("slime")				M.change_mob_type( /mob/living/carbon/slime , null, null, delmob )
			if("monkey")			M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
			if("robot")				M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")				M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
			if("corgi")				M.change_mob_type( /mob/living/simple_animal/dog/corgi , null, null, delmob )
			if("crab")				M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("parrot")			M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
			if("constructarmoured")	M.change_mob_type( /mob/living/simple_animal/construct/armoured , null, null, delmob )
			if("constructbuilder")	M.change_mob_type( /mob/living/simple_animal/construct/builder , null, null, delmob )
			if("constructwraith")	M.change_mob_type( /mob/living/simple_animal/construct/wraith , null, null, delmob )
			if("shade")				M.change_mob_type( /mob/living/simple_animal/shade , null, null, delmob )


	else if(href_list["boot2"])
		var/mob/M = locate(href_list["boot2"])
		if (ismob(M))
			if(!check_if_greater_rights_than(M.client))
				return
			var/reason = sanitize(input("Please enter reason"))
			if(!reason)
				M << "\red You have been kicked from the server"
			else
				M << "\red You have been kicked from the server: [reason]"
			log_admin("[key_name(usr)] booted [key_name(M)].")
			message_admins("\blue [key_name_admin(usr)] booted [key_name_admin(M)].", 1)
			//M.client = null
			qdel(M.client)

	else if(href_list["mute"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["mute"])
		if(!ismob(M))	return
		if(!M.client)	return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type))	mute_type = text2num(mute_type)
		if(!isnum(mute_type))	return

		cmd_admin_mute(M, mute_type)

	else if(href_list["c_mode"])
		if(!check_rights(R_ADMIN))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		var/dat = {"<B>What mode do you wish to play?</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"<A href='?src=\ref[src];c_mode2=secret'>Secret</A><br>"}
		dat += {"<A href='?src=\ref[src];c_mode2=random'>Random</A><br>"}
		dat += {"Now: [master_mode]"}
		usr << browse(dat, "window=c_mode")

	else if(href_list["f_secret"])
		if(!check_rights(R_ADMIN))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"<A href='?src=\ref[src];f_secret2=secret'>Random (default)</A><br>"}
		dat += {"Now: [secret_force_mode]"}
		usr << browse(dat, "window=f_secret")

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		log_admin("[key_name(usr)] attempting to monkeyize [key_name(H)]")
		message_admins("\blue [key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)]", 1)
		H.monkeyize()

	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		log_admin("[key_name(usr)] attempting to corgize [key_name(H)]")
		message_admins("\blue [key_name_admin(usr)] attempting to corgize [key_name_admin(H)]", 1)
		H.corgize()

	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))	return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			usr << "this can only be used on instances of type /mob"

		var/speech = input("What will [key_name(M)] say?.", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)	return
		M.say(speech)
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
		message_admins("\blue [key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]")

	else if(href_list["sendtoprison"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Send to admin prison for the round?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["sendtoprison"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(istype(M, /mob/living/silicon/ai))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		var/turf/prison_cell = pick(prisonwarp)
		if(!prison_cell)	return

		var/obj/structure/closet/secure_closet/brig/locker = new /obj/structure/closet/secure_closet/brig(prison_cell)
		locker.opened = 0
		locker.locked = 1

		//strip their stuff and stick it in the crate
		for(var/obj/item/I in M)
			M.drop_from_inventory(I, locker)
		M.update_icons()

		//so they black out before warping
		M.Paralyse(5)
		sleep(5)
		if(!M)	return

		M.loc = prison_cell
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/jumpsuit/orange(prisoner), slot_w_uniform)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), slot_shoes)

		M << "\red You have been sent to the prison station!"
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the prison station.", 1)

	else if(href_list["tdome1"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome1"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(istype(M, /mob/living/silicon/ai))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		for(var/obj/item/I in M)
			M.drop_from_inventory(I)

		M.Paralyse(5)
		sleep(5)
		M.loc = pick(tdome1)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 1)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 1)", 1)

	else if(href_list["tdome2"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome2"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(istype(M, /mob/living/silicon/ai))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		for(var/obj/item/I in M)
			M.drop_from_inventory(I)

		M.Paralyse(5)
		sleep(5)
		M.loc = pick(tdome2)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 2)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 2)", 1)

	else if(href_list["tdomeadmin"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeadmin"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(istype(M, /mob/living/silicon/ai))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		M.Paralyse(5)
		sleep(5)
		M.loc = pick(tdomeadmin)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Admin.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Admin.)", 1)

	else if(href_list["tdomeobserve"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeobserve"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(istype(M, /mob/living/silicon/ai))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		for(var/obj/item/I in M)
			M.drop_from_inventory(I)

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/observer = M
			observer.equip_to_slot_or_del(new /obj/item/clothing/under/jumpsuit/black(observer), slot_w_uniform)
			observer.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(observer), slot_shoes)
		M.Paralyse(5)
		sleep(5)
		M.loc = pick(tdomeobserve)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Observer.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Observer.)", 1)

	else if(href_list["revive"])
		if(!check_rights(R_REJUVINATE))	return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			usr << "This can only be used on instances of type /mob/living"
			return

		if(config.allow_admin_rev)
			L.revive()
			message_admins("\red Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!", 1)
			log_admin("[key_name(usr)] healed / Rrvived [key_name(L)]")
		else
			usr << "Admin Rejuvinates have been disabled"

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		message_admins("\red Admin [key_name_admin(usr)] AIized [key_name_admin(H)]!", 1)
		log_admin("[key_name(usr)] AIized [key_name(H)]")
		H.AIize()

	else if(href_list["makeslime"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeslime"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		usr.client.cmd_admin_slimeize(H)

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		usr.client.cmd_admin_robotize(H)

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["makeanimal"])
		if(istype(M, /mob/new_player))
			usr << "This cannot be used on instances of type /mob/new_player"
			return

		usr.client.cmd_admin_animalize(M)

	else if(href_list["togmutate"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["togmutate"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return
		var/block=text2num(href_list["block"])
		//testing("togmutate([href_list["block"]] -> [block])")
		usr.client.cmd_admin_toggle_block(H,block)
		show_player_panel(H)
		//H.regenerate_icons()

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["adminplayerobservejump"])
		if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))	return

		var/mob/M = locate(href_list["adminplayerobservejump"])

		var/client/C = usr.client
		if(!isghost(usr))	C.admin_ghost()
		sleep(2)
		C.jumptomob(M)

	else if(href_list["adminplayerobservefollow"])
		if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))
			return

		var/mob/M = locate(href_list["adminplayerobservefollow"])

		var/client/C = usr.client
		if(!isobserver(usr))	C.admin_ghost()
		var/mob/observer/ghost/G = C.mob
		sleep(2)
		G.ManualFollow(M)

	else if(href_list["check_antagonist"])
		check_antagonists()

	else if(href_list["adminplayerobservecoodjump"])
		if(!check_rights(R_ADMIN))	return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isghost(usr))	C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["adminchecklaws"])
		output_ai_laws()

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = get_turf(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
			else
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

		//Job + antagonist
		if(M.mind)
			special_role_description = "Role: <b>[M.mind.assigned_role]</b>; Antagonist: <font color='red'><b>[M.mind.special_role]</b></font>; Has been rev: [(M.mind.has_been_rev)?"Yes":"No"]"
		else
			special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>; Has been rev: <i>Mind datum missing</i>;"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if (0) status = "Alive"
				if (1) status = "<font color='orange'><b>Unconscious</b></font>"
				if (2) status = "<font color='red'><b>Dead</b></font>"
			health_description = "Status = [status]"
			health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getBrainLoss()]"
		else
			health_description = "This mob type has no health to speak of."

		//Gener
		switch(M.gender)
			if(MALE,FEMALE)	gender_description = "[M.gender]"
			else			gender_description = "<font color='red'><b>[M.gender]</b></font>"

		src.owner << "<b>Info about [M.name]:</b> "
		src.owner << "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]"
		src.owner << "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;"
		src.owner << "Location = [location_description];"
		src.owner << "[special_role_description]"
		src.owner << "(<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>) (<A HREF='?src=\ref[src];adminplayeropts=\ref[M]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[M]'>VV</A>) (<A HREF='?src=\ref[src];subtlemessage=\ref[M]'>SM</A>) ([admin_jump_link(M, src)]) (<A HREF='?src=\ref[src];secretsadmin=check_antagonist'>CA</A>)"

	else if(href_list["adminspawncookie"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		H.equip_to_slot_or_del( new /obj/item/reagent_containers/food/snacks/cookie(H), slot_l_hand )
		if(!(istype(H.l_hand,/obj/item/reagent_containers/food/snacks/cookie)))
			H.equip_to_slot_or_del( new /obj/item/reagent_containers/food/snacks/cookie(H), slot_r_hand )
			if(!(istype(H.r_hand,/obj/item/reagent_containers/food/snacks/cookie)))
				log_admin("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				message_admins("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				return
			else
				H.update_inv_r_hand()//To ensure the icon appears in the HUD
		else
			H.update_inv_l_hand()
		log_admin("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		message_admins("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		feedback_inc("admin_cookies_spawned",1)
		H << "\blue Your prayers have been answered!! You received the <b>best cookie</b>!"

	else if(href_list["BlueSpaceArtillery"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/living/M = locate(href_list["BlueSpaceArtillery"])
		if(!isliving(M))
			usr << "This can only be used on instances of type /mob/living"
			return

		if(alert(src.owner, "Are you sure you wish to hit [key_name(M)] with Blue Space Artillery?",  "Confirm Firing?" , "Yes" , "No") != "Yes")
			return

		if(BSACooldown)
			src.owner << "Standby!  Reload cycle in progress!  Gunnary crews ready in five seconds!"
			return

		BSACooldown = 1
		spawn(50)
			BSACooldown = 0

		M << "You've been hit by inter-ship artillery!"
		log_admin("[key_name(M)] has been hit by Bluespace Artillery fired by [src.owner]")
		message_admins("[key_name(M)] has been hit by Bluespace Artillery fired by [src.owner]")

		var/obj/effect/stop/S
		S = new /obj/effect/stop
		S.victim = M
		S.loc = M.loc
		spawn(20)
			qdel(S)

		var/turf/simulated/floor/T = get_turf(M)
		if(istype(T))
			if(prob(80))	T.break_tile_to_plating()
			else			T.break_tile()

		if(M.health == 1)
			M.gib()
		else
			M.adjustBruteLoss( min( 99 , (M.health - 1) )    )
			M.Stun(20)
			M.Weaken(20)
			M.stuttering = 20

	else if(href_list["CentcommReply"])
		var/mob/living/L = locate(href_list["CentcommReply"])
		if(!istype(L))
			usr << "This can only be used on instances of type /mob/living/"
			return

		if(L.can_centcom_reply())
			var/input = sanitize(input(src.owner, "Please enter a message to reply to [key_name(L)] via their headset.","Outgoing message from Centcomm", ""))
			if(!input)		return

			src.owner << "You sent [input] to [L] via a secure channel."
			log_admin("[src.owner] replied to [key_name(L)]'s Centcomm message with the message [input].")
			message_admins("[src.owner] replied to [key_name(L)]'s Centcom message with: \"[input]\"")
			if(!isAI(L))
				L << "<span class='info'>You hear something crackle in your headset for a moment before a voice speaks.</span>"
			L << "<span class='info'>Please stand by for a message from Central Command.</span>"
			L << "<span class='info'>Message as follows.</span>"
			L << "<span class='notice'>[input]</span>"
			L << "<span class='info'>Message ends.</span>"
		else
			src.owner << "The person you are trying to contact does not have functional radio equipment."


	else if(href_list["SyndicateReply"])
		var/mob/living/carbon/human/H = locate(href_list["SyndicateReply"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return
		if(!istype(H.l_ear, /obj/item/radio/headset) && !istype(H.r_ear, /obj/item/radio/headset))
			usr << "The person you are trying to contact is not wearing a headset"
			return

		var/input = sanitize(input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from a shadowy figure...", ""))
		if(!input)	return

		src.owner << "You sent [input] to [H] via a secure channel."
		log_admin("[src.owner] replied to [key_name(H)]'s illegal message with the message [input].")
		H << "You hear something crackle in your headset for a moment before a voice speaks.  \"Please stand by for a message from your benefactor.  Message as follows, agent. <b>\"[input]\"</b>  Message ends.\""

	else if(href_list["AdminFaxView"])
		var/obj/item/fax = locate(href_list["AdminFaxView"])
		if (istype(fax, /obj/item/paper))
			var/obj/item/paper/P = fax
			P.show_content(usr,1)
		else if (istype(fax, /obj/item/photo))
			var/obj/item/photo/H = fax
			H.show(usr)
		else if (istype(fax, /obj/item/paper_bundle))
			//having multiple people turning pages on a paper_bundle can cause issues
			//open a browse window listing the contents instead
			var/data = ""
			var/obj/item/paper_bundle/B = fax

			for (var/page = 1, page <= B.pages.len, page++)
				var/obj/pageobj = B.pages[page]
				data += "<A href='?src=\ref[src];AdminFaxViewPage=[page];paper_bundle=\ref[B]'>Page [page] - [pageobj.name]</A><BR>"

			usr << browse(data, "window=[B.name]")
		else
			usr << "\red The faxed item is not viewable. This is probably a bug, and should be reported on the tracker: [fax.type]"

	else if (href_list["AdminFaxViewPage"])
		var/page = text2num(href_list["AdminFaxViewPage"])
		var/obj/item/paper_bundle/bundle = locate(href_list["paper_bundle"])

		if (!bundle) return

		if (istype(bundle.pages[page], /obj/item/paper))
			var/obj/item/paper/P = bundle.pages[page]
			P.show_content(src.owner, 1)
		else if (istype(bundle.pages[page], /obj/item/photo))
			var/obj/item/photo/H = bundle.pages[page]
			H.show(src.owner)
		return

	else if(href_list["FaxReply"])
		var/mob/sender = locate(href_list["FaxReply"])
		var/obj/machinery/photocopier/faxmachine/fax = locate(href_list["originfax"])
		var/replyorigin = href_list["replyorigin"]


		var/obj/item/paper/admin/P = new /obj/item/paper/admin( null ) //hopefully the null loc won't cause trouble for us
		faxreply = P

		P.admindatum = src
		P.origin = replyorigin
		P.destination = fax
		P.sender = sender

		P.adminbrowse()

	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")	return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		if(!ticker || !ticker.mode)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob."
			return
		show_traitor_panel(M)

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))	return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))	return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))	return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))	return
		return create_mob(usr)

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))	return

		if(!config.allow_admin_spawning)
			usr << "Spawning of items is not allowed."
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()
		var/removed_paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				removed_paths += dirty_path
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				removed_paths += dirty_path
				continue
			else if(ispath(path, /obj/item/melee/energy/blade))//Not an item one should be able to spawn./N
				if(!check_rights(R_FUN,0))
					removed_paths += dirty_path
					continue
			else if(ispath(path, /obj/effect/bhole))
				if(!check_rights(R_FUN,0))
					removed_paths += dirty_path
					continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5)")
			return
		else if(length(removed_paths))
			alert("Removed:\n" + jointext(removed_paths, "\n"))

		var/list/offset = splittext(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])
		var/where = href_list["object_where"]
		if (!( where in list("onfloor","inhand","inmarked") ))
			where = "onfloor"

		if( where == "inhand" )
			usr << "Support for inhand not available yet. Will spawn on floor."
			where = "onfloor"

		if ( where == "inhand" )	//Can only give when human or monkey
			if ( !( ishuman(usr) || issmall(usr) ) )
				usr << "Can only spawn in hand when you're a human or a monkey."
				where = "onfloor"
			else if ( usr.get_active_hand() )
				usr << "Your active hand is full. Spawning on floor."
				where = "onfloor"

		if ( where == "inmarked" )
			var/marked_datum = marked_datum()
			if ( !marked_datum )
				usr << "You don't have any object marked. Abandoning spawn."
				return
			else
				if ( !istype(marked_datum,/atom) )
					usr << "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn."
					return

		var/atom/target //Where the object will be spawned
		switch ( where )
			if ( "onfloor" )
				switch (href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if ( "inmarked" )
				target = marked_datum()

		if(target)
			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N)
							if(obj_name)
								N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.set_dir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(istype(O,/mob))
									var/mob/M = O
									M.real_name = obj_name

		log_and_message_admins("created [number] [english_list(paths)]")
		return

	else if(href_list["admin_secrets_panel"])
		var/datum/admin_secret_category/AC = locate(href_list["admin_secrets_panel"]) in admin_secrets.categories
		src.Secrets(AC)

	else if(href_list["admin_secrets"])
		var/datum/admin_secret_item/item = locate(href_list["admin_secrets"]) in admin_secrets.items
		item.execute(usr)

	else if(href_list["ac_view_wanted"])            //Admin newscaster Topic() stuff be here
		src.admincaster_screen = 18                 //The ac_ prefix before the hrefs stands for AdminCaster.
		src.access_news_network()

	else if(href_list["ac_set_channel_name"])
		src.admincaster_feed_channel.channel_name = sanitizeSafe(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""))
		src.access_news_network()

	else if(href_list["ac_set_channel_lock"])
		src.admincaster_feed_channel.locked = !src.admincaster_feed_channel.locked
		src.access_news_network()

	else if(href_list["ac_submit_new_channel"])
		var/check = 0
		for(var/datum/feed_channel/FC in news_network.network_channels)
			if(FC.channel_name == src.admincaster_feed_channel.channel_name)
				check = 1
				break
		if(src.admincaster_feed_channel.channel_name == "" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]" || check )
			src.admincaster_screen=7
		else
			var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.CreateFeedChannel(admincaster_feed_channel.channel_name, admincaster_signature, admincaster_feed_channel.locked, 1)
				feedback_inc("newscaster_channels",1)                  //Adding channel to the global network
				log_admin("[key_name_admin(usr)] created command feed channel: [src.admincaster_feed_channel.channel_name]!")
				src.admincaster_screen=5
		src.access_news_network()

	else if(href_list["ac_set_channel_receiving"])
		var/list/available_channels = list()
		for(var/datum/feed_channel/F in news_network.network_channels)
			available_channels += F.channel_name
		src.admincaster_feed_channel.channel_name = sanitizeSafe(input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels )
		src.access_news_network()

	else if(href_list["ac_set_new_message"])
		src.admincaster_feed_message.body = sanitize(input(usr, "Write your Feed story", "Network Channel Handler", ""))
		src.access_news_network()

	else if(href_list["ac_submit_new_message"])
		if(src.admincaster_feed_message.body =="" || src.admincaster_feed_message.body =="\[REDACTED\]" || src.admincaster_feed_channel.channel_name == "" )
			src.admincaster_screen = 6
		else
			feedback_inc("newscaster_stories",1)
			news_network.SubmitArticle(src.admincaster_feed_message.body, src.admincaster_signature, src.admincaster_feed_channel.channel_name, null, 1)
			src.admincaster_screen=4

		log_admin("[key_name_admin(usr)] submitted a feed story to channel: [src.admincaster_feed_channel.channel_name]!")
		src.access_news_network()

	else if(href_list["ac_create_channel"])
		src.admincaster_screen=2
		src.access_news_network()

	else if(href_list["ac_create_feed_story"])
		src.admincaster_screen=3
		src.access_news_network()

	else if(href_list["ac_menu_censor_story"])
		src.admincaster_screen=10
		src.access_news_network()

	else if(href_list["ac_menu_censor_channel"])
		src.admincaster_screen=11
		src.access_news_network()

	else if(href_list["ac_menu_wanted"])
		var/already_wanted = 0
		if(news_network.wanted_issue)
			already_wanted = 1

		if(already_wanted)
			src.admincaster_feed_message.author = news_network.wanted_issue.author
			src.admincaster_feed_message.body = news_network.wanted_issue.body
		src.admincaster_screen = 14
		src.access_news_network()

	else if(href_list["ac_set_wanted_name"])
		src.admincaster_feed_message.author = sanitize(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""))
		src.access_news_network()

	else if(href_list["ac_set_wanted_desc"])
		src.admincaster_feed_message.body = sanitize(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
		src.access_news_network()

	else if(href_list["ac_submit_wanted"])
		var/input_param = text2num(href_list["ac_submit_wanted"])
		if(src.admincaster_feed_message.author == "" || src.admincaster_feed_message.body == "")
			src.admincaster_screen = 16
		else
			var/choice = alert("Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
					var/datum/feed_message/WANTED = new /datum/feed_message
					WANTED.author = src.admincaster_feed_message.author               //Wanted name
					WANTED.body = src.admincaster_feed_message.body                   //Wanted desc
					WANTED.backup_author = src.admincaster_signature                  //Submitted by
					WANTED.is_admin_message = 1
					news_network.wanted_issue = WANTED
					for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
						NEWSCASTER.newsAlert()
						NEWSCASTER.update_icon()
					src.admincaster_screen = 15
				else
					news_network.wanted_issue.author = src.admincaster_feed_message.author
					news_network.wanted_issue.body = src.admincaster_feed_message.body
					news_network.wanted_issue.backup_author = src.admincaster_feed_message.backup_author
					src.admincaster_screen = 19
				log_admin("[key_name_admin(usr)] issued a Priority Wanted Notification for [src.admincaster_feed_message.author]!")
		src.access_news_network()

	else if(href_list["ac_cancel_wanted"])
		var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
		if(choice=="Confirm")
			news_network.wanted_issue = null
			for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
				NEWSCASTER.update_icon()
			src.admincaster_screen=17
		src.access_news_network()

	else if(href_list["ac_censor_channel_author"])
		var/datum/feed_channel/FC = locate(href_list["ac_censor_channel_author"])
		if(FC.author != "<B>\[REDACTED\]</B>")
			FC.backup_author = FC.author
			FC.author = "<B>\[REDACTED\]</B>"
		else
			FC.author = FC.backup_author
		src.access_news_network()

	else if(href_list["ac_censor_channel_story_author"])
		var/datum/feed_message/MSG = locate(href_list["ac_censor_channel_story_author"])
		if(MSG.author != "<B>\[REDACTED\]</B>")
			MSG.backup_author = MSG.author
			MSG.author = "<B>\[REDACTED\]</B>"
		else
			MSG.author = MSG.backup_author
		src.access_news_network()

	else if(href_list["ac_censor_channel_story_body"])
		var/datum/feed_message/MSG = locate(href_list["ac_censor_channel_story_body"])
		if(MSG.body != "<B>\[REDACTED\]</B>")
			MSG.backup_body = MSG.body
			MSG.body = "<B>\[REDACTED\]</B>"
		else
			MSG.body = MSG.backup_body
		src.access_news_network()

	else if(href_list["ac_pick_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["ac_pick_d_notice"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen=13
		src.access_news_network()

	else if(href_list["ac_toggle_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["ac_toggle_d_notice"])
		FC.censored = !FC.censored
		src.access_news_network()

	else if(href_list["ac_view"])
		src.admincaster_screen=1
		src.access_news_network()

	else if(href_list["ac_setScreen"]) //Brings us to the main menu and resets all fields~
		src.admincaster_screen = text2num(href_list["ac_setScreen"])
		if (src.admincaster_screen == 0)
			if(src.admincaster_feed_channel)
				src.admincaster_feed_channel = new /datum/feed_channel
			if(src.admincaster_feed_message)
				src.admincaster_feed_message = new /datum/feed_message
		src.access_news_network()

	else if(href_list["ac_show_channel"])
		var/datum/feed_channel/FC = locate(href_list["ac_show_channel"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen = 9
		src.access_news_network()

	else if(href_list["ac_pick_censor_channel"])
		var/datum/feed_channel/FC = locate(href_list["ac_pick_censor_channel"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen = 12
		src.access_news_network()

	else if(href_list["ac_refresh"])
		src.access_news_network()

	else if(href_list["ac_set_signature"])
		src.admincaster_signature = sanitize(input(usr, "Provide your desired signature", "Network Identity Handler", ""))
		src.access_news_network()

	else if(href_list["vsc"])
		if(check_rights(R_ADMIN|R_SERVER))
			if(href_list["vsc"] == "airflow")
				vsc.ChangeSettingsDialog(usr,vsc.settings)
			if(href_list["vsc"] == "phoron")
				vsc.ChangeSettingsDialog(usr,vsc.plc.settings)
			if(href_list["vsc"] == "default")
				vsc.SetDefault(usr)

	else if(href_list["toglang"])
		if(check_rights(R_SPAWN))
			var/mob/M = locate(href_list["toglang"])
			if(!istype(M))
				usr << "[M] is illegal type, must be /mob!"
				return
			var/lang2toggle = href_list["lang"]
			var/datum/language/L = all_languages[lang2toggle]

			if(L in M.languages)
				if(!M.remove_language(lang2toggle))
					usr << "Failed to remove language '[lang2toggle]' from \the [M]!"
			else
				if(!M.add_language(lang2toggle))
					usr << "Failed to add language '[lang2toggle]' from \the [M]!"

			show_player_panel(M)

	// player info stuff

	if(href_list["add_player_info"])
		var/key = href_list["add_player_info"]
		var/add = sanitize(input("Add Player Info") as null|text)
		if(!add) return

		notes_add(key,add,usr)
		show_player_info(key)

	if(href_list["remove_player_info"])
		var/key = href_list["remove_player_info"]
		var/index = text2num(href_list["remove_index"])

		notes_del(key, index)
		show_player_info(key)

	if(href_list["notes"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes"])
			if("show")
				show_player_info(ckey)
			if("list")
				PlayerNotesPage(text2num(href_list["index"]))
		return

mob/living/proc/can_centcom_reply()
	return 0

mob/living/carbon/human/can_centcom_reply()
	return istype(l_ear, /obj/item/radio/headset) || istype(r_ear, /obj/item/radio/headset)

mob/living/silicon/ai/can_centcom_reply()
	return common_radio != null && !check_unable(2)

/atom/proc/extra_admin_link()
	return

/mob/extra_admin_link(var/source)
	if(client && eyeobj)
		return "|<A HREF='?[source];adminplayerobservejump=\ref[eyeobj]'>EYE</A>"

/mob/observer/ghost/extra_admin_link(var/source)
	if(mind && (mind.current && !isghost(mind.current)))
		return "|<A HREF='?[source];adminplayerobservejump=\ref[mind.current]'>BDY</A>"

/proc/admin_jump_link(var/atom/target, var/source)
	if(!target) return
	// The way admin jump links handle their src is weirdly inconsistent...
	if(istype(source, /datum/admins))
		source = "src=\ref[source]"
	else
		source = "_src_=holder"

	. = "<A HREF='?[source];adminplayerobservejump=\ref[target]'>JMP</A>"
	. += target.extra_admin_link(source)
