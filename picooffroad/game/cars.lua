car_max_speed_forward=4
car_nitro_speed_increase=2
car_max_speed_reverse=-1
car_turn_speed=0.1
car_inertia=0.95
car_gravity=-0.2
car_half_width=4
car_half_length=8
car_terrain_slip=0.85
car_dirt_slip=0.96
car_scale=5
car_colors_default={
	{8,2, "red hurricane"},
	{11,3,"green devil"},
	{12,1,"blue lightning"},
	{10,9,"yellow thunder"},
	{6,13,"silver blaze"}
}

default_throttle=1
difficulty_levels={
	{n="easy",t=0.8},
	{n="medium",t=0.9},
	{n="hard",t=1},
	{n="extreme",t=1.1},
}

player_color=1
waypoint_order=1
cars_count=4
laps_count=4
start_time=0
difficulty=1

function cars_init()
	particles={}
	frame=0

	local start_ofs=1
	if waypoint_order<0 then
		start_ofs=9
	end

	car_sorting=split("1,2,3,4")

	car_colors={}
	add(car_colors,car_colors_default[player_color])
	for i=2,4 do
		if i==player_color then
			add(car_colors,car_colors_default[1])
		else
			add(car_colors,car_colors_default[i])
		end
	end

	cars={}
	for i=1,cars_count do
		local cx=start_positions[start_ofs+  (i-1)*2]
		local cz=start_positions[start_ofs+1+(i-1)*2]
		local t,cy=sample_tile_map(cx,cz)
		add(cars,{x=cx,y=cy,z=cz,yaw=hpi+hpi*waypoint_order,speed=0,speed_y=0,throttle=0,nitro=0,breaking=0,in_air=false,slip=0,slip_x=0,slip_z=0,colour=i,last_waypoint=0,next_waypoint=0,next_x=0,next_z=0,nitro_remains=100,nitro_max=100,lap=-1,is_ai=i>1})
		car_simulate(cars[#cars])
	end
	
	start_time=time()+3.5
end

function cars_update()
	if time()<start_time then return end

	frame+=1
	particles_update()

	car_player(cars[1])
	car_simulate(cars[1])
	
	for i=2,cars_count do
		car_ai(cars[i])
		car_simulate(cars[i])
	end
end

function car_input(car,left,right,throttle,rev,nitro)
	if car.in_air then
		car.throttle=0
		return
	end

	if left then
		car.yaw+=car_turn_speed
		if car.yaw>=pi2 then
			car.yaw-=pi2
		end
	end
	
	if right then
		car.yaw-=car_turn_speed
		if car.yaw<0 then
			car.yaw+=pi2
		end
	end

	if nitro and car.nitro_remains>0 then
		car.nitro=car_nitro_speed_increase
		car.nitro_remains-=1
	else
		car.nitro=0
	end
	
	if throttle then
		car.throttle=default_throttle
	elseif rev then
		car.throttle=-default_throttle
	else
		car.throttle=0
	end
end

function car_next_waypoint(car)
	if car.last_waypoint==car.next_waypoint then
		local nw=(car.next_waypoint + #waypoints + waypoint_order)%#waypoints
		local wps=waypoints[nw+1]
		local index=flr(rnd(#wps\2))*2+1
		car.next_waypoint=nw
		car.next_x=wps[index]
		car.next_z=wps[index+1]
	end
end

function car_player(car)
	car_input(cars[1],btn(0),btn(1),btn(2) or btn(5),btn(3),btn(4))
	car_update_lap(car,car.last_waypoint,car.next_waypoint)
	car_next_waypoint(car)
end

function car_ai(car)
	car_update_lap(car,car.last_waypoint,car.next_waypoint)
	car_next_waypoint(car)

	local dir_x=car.next_x-car.x
	local dir_z=car.next_z-car.z
	local dst_yaw = atan2(-dir_x,dir_z)
	car.dst_yaw=dst_yaw
	
	car.dst_distance=dir_x*dir_x+dir_z*dir_z

	local delta_yaw=dst_yaw-car.yaw
	if delta_yaw> pi then delta_yaw-=pi2 end
	if delta_yaw<-pi then delta_yaw+=pi2 end
	
	car_input(car,delta_yaw>0.1,delta_yaw<-0.1,abs(delta_yaw)<0.5,false,car.dst_distance>6400)

	local next_wps=waypoints[car.next_waypoint+1]
	local index=flr(rnd(#next_wps\2))*2+1
	local ndir_x=next_wps[index]-car.x
	local ndir_z=next_wps[index+1]-car.z
	
	if (ndir_x*ndir_x+ndir_z*ndir_z)<car.dst_distance then
		car.next_x=next_wps[index]
		car.next_z=next_wps[index+1]
	end
end

function car_update_lap(car,last_waypoint,next_waypoint)
	if next_waypoint==0 and last_waypoint==next_waypoint then
		car.lap+=1
		if car.lap>=laps_count then
			sfx(56)
			set_finish_time()
			set_state(3)
		end
	end
end

function set_finish_time()
	if cars[1].finish_time==nil then
		for i=1,cars_count do
			local car=cars[i]
			local ft=t()-start_time
			if car.lap>=laps_count then
				car.finish_time=ft
			else
				local dir_x=car.next_x-car.x
				local dir_z=car.next_z-car.z
				local t_dist=sqrt(dir_x*dir_x+dir_z*dir_z)*0.1
				car.finish_time=ft+t_dist+(laps_count-car.lap-1)*#waypoints*5
				while car.next_waypoint~=0 do
					car.next_waypoint=(car.next_waypoint + #waypoints + waypoint_order)%#waypoints
					car.finish_time+=5
				end
			end
		end
	end
end

function car_simulate(car)
	local was_air=car.in_air
	local prc=0
	local prs=146

	local inertia = car_inertia
	if car.in_air then inertia = 1 end
	local max_speed = car_max_speed_forward
	if car.is_ai then max_speed *= difficulty_levels[difficulty].t end
	car.speed = clamp(car.speed*inertia + car.throttle + car.nitro, car_max_speed_reverse, max_speed + car.nitro)

	local speed=car.speed
	if not car.in_air then
		speed*=(1-abs(car.pitch)*0.4)
		
		if height_is_water(car.y) then
			speed = min(speed,2)
			prs=150
			prc=2
		end
	end
	
	local dir_x=-cos(car.yaw)
	local dir_z= sin(car.yaw)
	local right_x=-dir_z
	local right_z= dir_x

	local move_x = lerp(dir_x,car.slip_x,car.slip)
	local move_z = lerp(dir_z,car.slip_z,car.slip)
	move_x,move_z = normalize2d(move_x,move_z)

	car.slip_x = move_x
	car.slip_z = move_z

	local new_x = car.x + move_x * speed
	local new_z = car.z + move_z * speed

	local fwd_x=dir_x*car_half_length
	local fwd_z=dir_z*car_half_length

	local f_x=new_x+fwd_x
	local f_z=new_z+fwd_z
	local b_x=new_x-fwd_x
	local b_z=new_z-fwd_z

	if speed>=0 then
		local f_t,f_h=sample_tile_map(f_x,f_z)
		if tile_is_obstacle(f_t) then
			local sol_x,sol_z=sample_collision_solution(f_x,f_z)
						
			if sol_x~=0 or sol_z~=0 then
				local tf_x=flr(f_x/8)
				local tf_z=flr(f_z/8)
				while tf_x==flr(f_x/8) and tf_z==flr(f_z/8) do
					f_x+=sol_x
					f_z+=sol_z
				end
			else
				car.screen_x,car.screen_y=isometry(car.x,car.y,car.z)
				car.in_air=false
				return
			end
			
			dir_x,dir_z=normalize2d(f_x-b_x,f_z-b_z)
			
			right_x=-dir_z
			right_z= dir_x
			
			fwd_x=dir_x*car_half_length
			fwd_z=dir_z*car_half_length
			
			car.yaw = atan2(-dir_x,dir_z)
			
			new_x = f_x-fwd_x
			new_z = f_z-fwd_z

			b_x=new_x-fwd_x
			b_z=new_z-fwd_z
			
			if not car.in_air then
				car.speed  = min(car.speed,1.8)
				car.speed_y = max(car.speed_y,0)
			end
		end
	else
		local b_t,b_h=sample_tile_map(b_x,b_z)
		if tile_is_obstacle(b_t) then
			return
		end
	end

	car.x=new_x
	car.z=new_z

	right_x*=car_half_width
	right_z*=car_half_width

	local fr_x=f_x+right_x
	local fr_z=f_z+right_z
	local fl_x=f_x-right_x
	local fl_z=f_z-right_z
	local br_x=b_x+right_x
	local br_z=b_z+right_z
	local bl_x=b_x-right_x
	local bl_z=b_z-right_z

	local fr_t,fr_y,fr_w = sample_tile_map(fr_x,fr_z)
	local fl_t,fl_y,fl_w = sample_tile_map(fl_x,fl_z)
	local br_t,br_y,br_w = sample_tile_map(br_x,br_z)
	local bl_t,bl_y,bl_w = sample_tile_map(bl_x,bl_z)
	
	local f_y = (fr_y+fl_y)*0.5
	local b_y = (br_y+bl_y)*0.5
	local r_y = (fr_y+br_y)*0.5
	local l_y = (fl_y+bl_y)*0.5

	car.sfr_x,car.sfr_y=isometry(fr_x,fr_y,fr_z)
	car.sfl_x,car.sfl_y=isometry(fl_x,fl_y,fl_z)
	car.sbr_x,car.sbr_y=isometry(br_x,br_y,br_z)
	car.sbl_x,car.sbl_y=isometry(bl_x,bl_y,bl_z)

	car.speed_y = clamp(car.speed_y+car_gravity,-4,4)
	local phys_y=car.y+car.speed_y
	local new_tile_type = fr_t
	local new_y = (f_y+b_y)*0.5
	
	if phys_y>new_y then
		car.in_air=true
		car.y=phys_y
		car.roll*=0.95
		car.pitch=max(car.pitch-0.03,-0.4)
		car.slip=0
	else
		if tile_is_dirt(new_tile_type) then
			car.slip=car_dirt_slip
		else
			car.slip=car_terrain_slip
		end
		
		car.in_air=false
		car.speed_y=new_y-car.y
		car.y=new_y
		car.tile_type=new_tile_type
	
		car.pitch=clamp((f_y-b_y)/car_half_length*0.5,-0.5,0.5)
		car.roll=clamp((l_y-r_y)/car_half_width*0.5,-0.5,0.5)
	end

	car.screen_x,car.screen_y=isometry(car.x,car.y,car.z)

	if was_air and not car.in_air then
		prc+=4
	end
	
	if not car.in_air and abs(car.speed)>0.8 and (car.slip>0.9 or car.speed>car_max_speed_forward) then
		prc+=1
	end
	
	for i=1,prc do
		add(particles,{s=prs,x=flr(car.screen_x-11+rnd(10)),y=flr(car.screen_y-11+rnd(10))})
	end
	
	if fr_w~=-1 then car.last_waypoint=fr_w end
	if fl_w~=-1 then car.last_waypoint=fl_w end
	if br_w~=-1 then car.last_waypoint=br_w end
	if bl_w~=-1 then car.last_waypoint=bl_w end
end

function particles_update()
	if frame%4==0 then
		for i=1,#particles do
			local p=particles[i]
			if p==nil then break end
			if p.s==149 or p.s==153 then
				deli(particles,i)
			else
				p.s+=1
			end
		end
	end
end

function cars_draw(ofs_x,ofs_y)
	for i=1,cars_count do
		local car=cars[i]
		local x=car.screen_x-ofs_x
		local y=car.screen_y-ofs_y
		if x>-8 and x<136 and y>-8 and y<136 then
			draw_shade(
				car.sfr_x-ofs_x,car.sfr_y-ofs_y,
				car.sfl_x-ofs_x,car.sfl_y-ofs_y,
				car.sbl_x-ofs_x,car.sbl_y-ofs_y,
				car.sbr_x-ofs_x,car.sbr_y-ofs_y
			)
		end
	end

	palt()
	for i=1,#particles do
		local p=particles[i]
		spr(p.s,p.x-ofs_x,p.y-ofs_y)
	end

	for i=1,cars_count-1 do
		if cars[car_sorting[i]].screen_y > cars[car_sorting[i+1]].screen_y then
			car_sorting[i],car_sorting[i+1]=car_sorting[i+1],car_sorting[i]
		end
	end

	for i=1,cars_count do
		local car=cars[car_sorting[i]]
		local colors=car_colors[car.colour]
		pal(11,colors[1])
		pal(3,colors[2])
		
		local x=car.screen_x-ofs_x
		local y=car.screen_y-ofs_y
		if x>-8 and x<136 and y>-8 and y<136 then
			car_draw(x,y,car.yaw,car.pitch,car.roll,car_scale)
		end
	end
	
	pal(11,11)
	pal(3,3)
end
