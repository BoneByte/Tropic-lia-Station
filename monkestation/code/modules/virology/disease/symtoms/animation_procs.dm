#define COLOR_MARTIX_BASE list( 1.00, 0.00, 0.00, 0.00,\
								0.00, 1.00, 0.00, 0.00,\
								0.00, 0.00, 1.00, 0.00,\
								0.00, 0.00, 0.00, 1.00,\
								0.00, 0.00, 0.00, 0.00)

#define COLOR_MATRIX_GRAYSCALE list(0.33,0.33,0.33,0.00,\
									0.33,0.33,0.33,0.00,\
									0.33,0.33,0.33,0.00,\
									0.00,0.00,0.00,1.00,\
									0.00,0.00,0.00,0.00)

/atom/proc/fade_matrix(time = 1 SECONDS, matrix = COLOR_MATRIX_GRAYSCALE)
	color = COLOR_MARTIX_BASE
	animate(src, color=matrix, time=time, easing=SINE_EASING)

/atom/proc/fade_from_matrix(time = 1 SECONDS, matrix = COLOR_MATRIX_GRAYSCALE)
	color = matrix
	animate(src, color=COLOR_MARTIX_BASE, time=time, easing=SINE_EASING)

//generalized version of lavadrakes Lavaswoop
/atom/proc/fading_leap_up()
	var/matrix/M = matrix()
	var/loop_count = 15
	while(loop_count > 0)
		loop_count--
		animate(src, transform = M, pixel_z = src.pixel_z + 12, alpha = src.alpha - 17, time = 1, loop = 1, easing = LINEAR_EASING)
		M.Scale(1.2,1.2)
		sleep(0.1 SECONDS)
	alpha = 0

//inverse of above
/atom/proc/fading_leap_down()
	var/matrix/M = matrix()
	var/loop_count = 12
	M.Scale(15,15)
	while(loop_count > 0)
		loop_count--
		animate(src, transform = M, pixel_z = src.pixel_z - 12, alpha = src.alpha + 17, time = 1, loop = 1, easing = LINEAR_EASING)
		M.Scale(0.8,0.8)
		sleep(0.1 SECONDS)
	animate(src, transform = M, pixel_z = 0, alpha = 255, time = 1, loop = 1, easing = LINEAR_EASING)
	M.Scale(1,1)


///😰😰😰😰😰😰
/atom/proc/bananeer(dir=null, total_time = 0.5 SECONDS, height = 16, stun_duration = 1 SECONDS, flip_count = 1)
	animate(src) // cleanse animations as funny as a ton of stacked flips would be it would be an eye sore
	var/matrix/M = transform
	var/turn = 90
	if(isnull(dir))
		if(dir == EAST)
			turn = 90
		else if(dir == WEST)
			turn = -90
		else
			if(prob(50))
				turn = -90


	var/flip_anim_step_time = total_time / (1 + 4 * flip_count)
	animate(src, transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time, flags = ANIMATION_PARALLEL)
	for(var/i in 1 to flip_count)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
	var/matrix/M2 = transform
	animate(transform = matrix(M, 1.2, 0.7, MATRIX_SCALE | MATRIX_MODIFY), time = total_time * 0.125)
	animate(transform = M2, time = total_time * 0.125)

	animate(src, pixel_y=height, time= total_time * 0.5, flags=ANIMATION_PARALLEL)
	animate(pixel_y=-4, time= total_time * 0.5)

	if(isliving(src))
		var/mob/living/living = src
		living.Knockdown(stun_duration)
		animate(src, pixel_x = 0, pixel_y = 0, transform = src.transform.Turn(-turn), time = 3, easing = LINEAR_EASING, flags=ANIMATION_PARALLEL)
	else
		spawn(stun_duration + total_time)
			animate(src, pixel_x = 0, pixel_y = 0, transform = src.transform.Turn(-turn), time = 3, easing = LINEAR_EASING, flags=ANIMATION_PARALLEL)

#undef COLOR_MARTIX_BASE
#undef COLOR_MATRIX_GRAYSCALE
