/obj/machinery/power/cathode
	name = "power system inerface"
	desc = "this device converts current generated by an electromagnetic tether into usable electricity."
	icon = 'icons/obj/power.dmi'
	icon_state = "psi"
	anchored = 1
	density = 1
	directwired = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/panel = 0 // 0 is closed, 1 is open
	var/deployed = 0 // 0 is not deployed, 1 is deployed
	var/health = 10
	var/list/cablelengths

/obj/machinery/power/cathode/New(var/turf/loc, var/process = 1)
	..(loc)
	connect_to_network(process)

/obj/machinery/power/cathode/attackby(obj/item/W, mob/user)
	//Crowbars open and close the maint panel
	if(iscrowbar(W))
		panel = !panel //if we are closed, open, if we are open, close
		if(panel)//if the panel is open after that
			usr << "You open the maintainence panel."
		else
			usr << "You close the maintainence panel."
		return

	if(!panel) return //if the panel is not open, stop

	if(istype(W, /obj/item/weapon/wirecutters)) //If we use wirecutters
		if(cablelengths.len>0) //and we have any cable loaded...
			var/obj/structure/tether/TC = cablelengths[0]
			while(!isnull(TC.child))
				TC = TC.child
			switch(TC.tech)
				if(1) new /obj/structure/tether/metal(src.loc)
				if(2) new /obj/structure/tether/silver(src.loc)
				if(3) new /obj/structure/tether/gold(src.loc)
				else new /obj/structure/tether/metal(src.loc)
			del(TC)


	if(istype(W, /obj/item/stack/tether_cable))
		var/obj/item/stack/tether_cable/TC = W
		if(cablelengths.len < 10)
			var/obj/structure/tether/TS
			switch(TC.tech)
				if(1) TS = new /obj/structure/tether/metal()
				if(2) TS = new /obj/structure/tether/silver()
				if(3) TS = new /obj/structure/tether/gold()
				else TS = new /obj/structure/tether/metal()
			if(cablelengths.len > 0)
				var/obj/structure/tether/TTS = cablelengths[0]
				while(!isnull(TTS.child))
					TTS = TTS.child
				TTS.child = TS
			cablelengths.Add(TS)
			TC.use(1)
			usr << "You add a length of [src] to the reel."
		else
			usr << "You cannot add any more cable to the reel."
			return
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
//		icon = test //ADD BROKEN ICON HERE
	else
//		icon = test //ADD WORKING ICON HERE
//	return
/obj/machinery/power/cathode/process()//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(stat & BROKEN)	return
//	if(!control)	return
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

//EMAG CABLING

/obj/item/stack/tether_cable
	name = "electromagnetic tether cable"
	desc = "Specialized superconductive cable for electromagnetic tethers."
	singular_name = "tether"
	icon_state = "mtether"
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 3.0
	force = 5.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 20
	matter = list("metal" = 2000)
	max_amount = 0
	attack_verb = list("whips", "slaps", "diciplines")
	origin_tech = "materials=1"
	var/tech = 1
/obj/item/stack/tether_cable/metal
	tech = 1
	matter = list("metal" = 2000)
/obj/item/stack/tether_cable/silver
	desc = "Specialized superconductive cable for electromagnetic tethers. It has a silver core"
	tech = 2
	matter = list("silver" = 2000)
	icon_state = "stether"
	origin_tech = "materials=3"
/obj/item/stack/tether_cable/gold
	desc = "Specialized superconductive cable for electromagnetic tethers. It has a gold core"
	tech = 3
	matter = list("gold" = 2000)
	icon_state = "gtether"
	origin_tech = "materials=4"
//TETHER STRUCTURE
/obj/structure/tether
	name = "Tether"
	desc = "A heavy superconductive cable used by eletromagnetic tethers."
	//icon = "tether"
	var/tech = 1
	var/deployed = 0
	var/obj/structure/tether/child = null
/obj/structure/tether/metal
//	icon = "tether"
/obj/structure/tether/silver
//	icon = "stether"
/obj/structure/tether/gold
//	icon = "gtether"
/obj/structure/tether/proc/broken()
//If something breaks the teather, it breaks all child objects of the tether, then spawns cable in on the object, then deletes the object.
	switch(tech)
		if(1) new /obj/item/stack/tether_cable/metal(src.loc)
		if(2) new /obj/item/stack/tether_cable/silver(src.loc)
		if(3) new /obj/item/stack/tether_cable/gold(src.loc)
	if(child)
		child.broken()
	del(src)