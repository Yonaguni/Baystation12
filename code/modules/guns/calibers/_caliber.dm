var/list/caliber_data

/proc/get_caliber_from_path(var/cpath)
	if(!caliber_data)
		caliber_data = list()
	if(ispath(cpath) && !caliber_data[cpath])
		caliber_data[cpath] = new cpath
	return caliber_data[cpath]

/decl/weapon_caliber
	var/name                                      // Fluffy unique identifier, used in descs.
	var/fire_sound =  'sound/weapons/Gunshot.ogg' // Sound played on fire, if any.
	var/fire_cost = 0                             // Charge cost to fire this caliber from an energy weapon.
	var/projectile_type                           // Type of projectile spawned.
	var/projectile_size                           // Relative 'size' of projectile, used for caliber mismatches between chamber and barrel.
	var/magazine_name                             // Name applied to magazines produced for this caliber.
	var/specific_gun_name                         // Modifier prefixed to gun names.
	var/mode_name                                 // Used by caliber-switching guns.

/decl/weapon_caliber/New()
	..()
	if(!mode_name) mode_name = name
