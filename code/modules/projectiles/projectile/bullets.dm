/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"
	embed = 1
	sharp = 1

	on_hit(var/atom/target, var/blocked = 0)
		if (..(target, blocked))
			var/mob/living/L = target
			shake_camera(L, 3, 2)

/obj/item/projectile/bullet/weakbullet // "rubber" bullets
	damage = 10
	agony = 60
/*	stun = 5
	weaken = 5*/
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/weakbullet/beanbag		//because beanbags are not bullets
	name = "beanbag"

/obj/item/projectile/bullet/weakbullet/rubber
	name = "bullet"

/obj/item/projectile/bullet/midbullet
	damage = 20
/*	stun = 5
	weaken = 5 */

/obj/item/projectile/bullet/midbullet2
	damage = 25

/obj/item/projectile/bullet/incendiary
	icon_state= "fireball"

/obj/item/projectile/bullet/incendiary/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(1)
		M.IgniteMob()
	else if(istype(target, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/M = target
		M.adjust_fire_stacks(1)
		M.IgniteMob()
/obj/item/projectile/bullet/incendiary/shell
	name = "incendiary shell"
	damage_type = BURN
	damage = 20
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY


/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX


/obj/item/projectile/bullet/burstbullet//I think this one needs something for the on hit
	name = "exploding bullet"
	damage = 20
	embed = 0
	edge = 1


/obj/item/projectile/bullet/stunshot
	name = "stunshot"
	damage = 5
	stun = 10
	weaken = 10
	stutter = 10
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a762
	damage = 25

/obj/item/projectile/bullet/chameleon
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope

/obj/item/projectile/bullet/weakbullet/flash
	name = "flash round"
	damage = 5
	agony = 0
/obj/item/projectile/bullet/weakbullet/flash/on_hit(var/atom/target, var/blocked = 0)
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.eyecheck() > 0)
			if(!H.blinded)
				flick("e_flash", H:flash)
				H << "\red The flash round blinds you!"
				sleep (10)
				flick("e_flash", H:flash)
				sleep (10)
				flick("e_flash", H:flash)
				H << "\red nooooooo"

	for(var/mob/living/carbon/human/M in oviewers(2, target))
		if(!M.eyecheck() > 0)
			if(!M.blinded)
				flick("flash", M:flash)
				M << "\red The flash round blinds you!"
/*				sleep (5)
				flick("e_flash", M:flash)
				sleep (8)
				flick("e_flash", M:flash)
				sleep (10)
				flick("e_flash", M:flash)
				sleep (15)
				flick("e_flash", M:flash)
				sleep (20)
				flick("e_flash", M:flash)
				M << "\red nooooooo!"*/
