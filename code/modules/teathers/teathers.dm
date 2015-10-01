/obj/machinery/power/cathode
	name = "power system inerface"
	desc = "this device converts current generated by an electromagnetic teather into usable electricity."
	icon = 'icons/obj/power.dmi'
	icon_state = "psi"
	anchored = 1
	density = 1
	directwired = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/id = 0
	var/health = 10
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH
	var/ndir = SOUTH
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null
	
/obj/machinery/power/cathode/New(var/turf/loc, var/process = 1)
	..(loc)
	connect_to_network(process)

/obj/machinery/power/cathode/attackby(obj/item/weapon/W, mob/user)

	if(iscrowbar(W))
/*
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 50))
			var/obj/item/solar_assembly/S = locate() in src
			if(S)
				S.loc = src.loc
				S.give_glass()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] takes the glass off the solar panel.</span>")
			del(src)
		return
*/
	else if (W)
		src.add_fingerprint(user)
		src.health -= W.force
		src.healthcheck()
	..()

/obj/machinery/power/cathode/blob_act()
	src.health--
	src.healthcheck()
	return


/obj/machinery/power/cathode/proc/healthcheck()
	if (src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/weapon/shard(src.loc)
			new /obj/item/weapon/shard(src.loc)
			del(src)
			return
	return

/obj/machinery/power/cathode/update_icon()
	..()
	if(stat & BROKEN)
		icon = test //ADD BROKEN ICON HERE
	else
		icon = test //ADD WORKING ICON HERE
	return
/obj/machinery/power/cathode/process()//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(stat & BROKEN)	return
	if(!control)	return
/*
	if(adir != ndir)
		adir = (360+adir+dd_range(-10,10,ndir-adir))%360
		update_icon()
		update_solar_exposure()

	if(obscured)	return

	var/sgen = SOLARGENRATE * sunfrac
	add_avail(sgen)
	if(powernet && control)
		if(powernet.nodes[control])
			control.gen += sgen
*/
	//TODO - CHECK ATTACHED DEPLOYED CABLE, PRODUCE POWER BASED ON AMBIENT RADIATION AND CABLE LENGTHS/QUALITY CURRENTLY DEPLOYED


/obj/machinery/power/cathode/proc/broken()
	stat |= BROKEN
	update_icon()
	return


/obj/machinery/power/cathode/meteorhit()
	if(stat & !BROKEN)
		broken()
	else
		del(src)


/obj/machinery/power/cathode/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			if(prob(15))
				new /obj/item/weapon/shard( src.loc )
			return
		if(2.0)
			if (prob(25))
				new /obj/item/weapon/shard( src.loc )
				del(src)
				return
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return


/obj/machinery/power/cathode/blob_act()
	if(prob(75))
		broken()
		src.density = 0
