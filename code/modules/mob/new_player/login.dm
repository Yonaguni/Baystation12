/var/obj/effect/lobby_image = new/obj/effect/lobby_image()

/obj/effect/lobby_image
	name = "Europa Station"
	desc = "This shouldn't be read."
	screen_loc = "CENTER-7,CENTER-7"
	plane = HUD_PLANE

/obj/effect/lobby_image/Initialize()
	icon = GLOB.using_map.lobby_icon
	var/known_icon_states = icon_states(icon)
	for(var/lobby_screen in GLOB.using_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			GLOB.using_map.lobby_screens -= lobby_screen

	if(GLOB.using_map.lobby_screens.len)
		icon_state = pick(GLOB.using_map.lobby_screens)
	else
		icon_state = known_icon_states[1]

	. = ..()

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	client.screen += lobby_image
	my_client = client
	set_sight(sight|SEE_TURFS)
	GLOB.player_list |= src

	/*
	 * We need to ensure the new player panel isn't still open if the server has restarted without the client disconnecting!
	 * Otherwise the panel will still be open once the server restarts, and the user may be left with a non-responsive panel.
	 * We have to close the window by manually browsing null on the same windowid, because we may no longer have the reference.
	 * (It's null, but the client is still showing it, and it's unresponsive)
 	 */
	close_browser(src, "window=[NEW_PLAYER_PANEL_ID]")
	//And now the client will magically see the panel disappear.

	if(!SScharacter_setup.initialized)
		SScharacter_setup.newplayers_requiring_init += src
	else
		deferred_login()

// This is called when the charcter setup system has been sufficiently initialized and prefs are available.
// Do not make any calls in mob/Login which may require prefs having been loaded.
// It is safe to assume that any UI or sound related calls will fall into that category.
/mob/new_player/proc/deferred_login()
	if(client)
		if (client.ckey in GLOB.acceptedKeys) //Check if they've already clicked the I ACCEPT info window thing, each round once.
			new_player_panel()
		else
			client.check_server_info()
		handle_privacy_poll()
		client.playtitlemusic()
		maybe_send_staffwarns("connected as new player")

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	var/decl/security_level/SL = security_state.current_security_level
	var/alert_desc = ""
	if(SL.up_description)
		alert_desc = SL.up_description
	to_chat(src, "<span class='notice'>The alert level on the [station_name()] is currently: <font color=[SL.light_color_alarm]><B>[SL.name]</B></font>. [alert_desc]</span>")