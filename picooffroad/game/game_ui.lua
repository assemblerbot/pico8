prevcountdown=-1
function game_ui_draw()
	local t=time()-start_time

	if t>=0 then
		printo(time_str(t),64-12,2,7)

		for j=0,cars_count-1 do
			local ls=lap_to_str(cars[j+1].lap)
			if j==0 then
				ls=ls.."/"..laps_count
			end
			printo(ls,2,2+j*6,car_colors[cars[j+1].colour][1])
		end
		
		for j=0,cars_count-1 do
			draw_progress(128-32,2+j*3,126,cars[j+1].nitro_remains/cars[j+1].nitro_max,car_colors[cars[j+1].colour][1],car_colors[cars[j+1].colour][2])
		end
	end

	if t<1 then
		t=-t+1
		set_transparent_pattern(t-flr(t))
		local sx=3
		if time()>=start_time then
			sx=9
		end
		local countdown=3-flr(t)
		draw_sprite4(countdown*3,64-6,sx,6, 64-(sx*4)/2,64-24/2)
		fillp()
		
		if countdown>prevcountdown then
			if countdown==3 then
				sfx(55)
			else
				sfx(54)
			end
		end
		prevcountdown=countdown
	end
end

