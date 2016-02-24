// here because it's similar to below
// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database
/proc/get_player_age(key)
	establish_database_connection()
	if(!global_db)
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/database/query/query = new("SELECT (julianday('now') - firstseen) AS age FROM player WHERE ckey = '[sql_ckey]'")
	query.Execute(global_db)

	if(query.NextRow())
		var/list/querydata = query.GetRowData()
		return Floor(text2num(querydata["age"]))
	else
		return 0

/client/proc/log_client_to_db()

	if(IsGuestKey(src.key))
		return

	player_age = 0

	establish_database_connection()
	if(!global_db)
		return

	player_age = get_player_age(key)
	var/player_exists

	var/database/query/query_ip = new("SELECT ckey FROM player WHERE ip = '[address]'")
	query_ip.Execute(global_db)
	related_accounts_ip = ""
	while(query_ip.NextRow())
		var/list/querydata = query_ip.GetRowData()
		related_accounts_ip += "[querydata["ckey"]], "
		player_exists = 1
		break

	var/database/query/query_cid = new("SELECT ckey FROM player WHERE computerid = '[computer_id]'")
	query_cid.Execute(global_db)
	related_accounts_cid = ""
	while(query_cid.NextRow())
		var/list/querydata = query_cid.GetRowData()
		related_accounts_cid += "[querydata["ckey"]], "
		player_exists = 1
		break

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ckey =       sql_sanitize_text(ckey(key))
	var/sql_ip =         sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	if(player_exists)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/database/query/query_update = new("UPDATE player SET lastseen = julianday('now'), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE ckey = [sql_ckey]")
		query_update.Execute(global_db)
	else
		//New player!! Need to insert all the stuff
		var/database/query/query_insert = new("INSERT INTO player VALUES ('[sql_ckey]', julianday('now'), julianday('now'), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute(global_db)