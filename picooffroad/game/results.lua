posn={"1ST","2ND","3RD","4TH"}

function results_init()
	res_sorting={1,2,3,4}
	res_t=t()
	res_d=120
	res_tour=false
	res_frame=0
end

function results_update()
	if btnp(5) and res_d < 4 then
		sfx(51)
		if tour==nil then
			set_state(1)
			return
		end
		if res_tour then
			track=track%#tracks+1
			if track == 1 then
				waypoint_order*=-1
				if waypoint_order==1 then
					if final_position == 4 then
						set_state(1)
					else
						set_state(4)
					end
					return
				end
			end
			set_state(2)
			return
		end
		res_tour=true
		res_d=120
		res_frame=0
		for i=1,cars_count do
			tour[res_sorting[i]]+=cars_count-i+1
		end
	end
end

function results_draw()
	for y=-1,15 do
		for x=-1,15 do
			local ofs=(time()*16)%8
			rectfill(x*8+ofs,y*8+ofs,x*8+7+ofs,y*8+7+ofs,((x^^y)&1))
		end
	end
	
	local base_y=37-res_d
	res_d/=1.2

	rect(2,base_y,126,base_y+54,0)
	rectfill(3,base_y+1,125,base_y+53,5)

	local title="race results"
	if res_tour then
		title="tournament"
	end
	printo(title, 64-(12/2)*4,base_y+3,7)
	line(4,base_y+10,123,base_y+10,7)

	printo("pos",5,base_y+13,7)
	printo("car",22,base_y+13,7)
	if not res_tour then
		printo("time",83,base_y+13,7)
	end
	if tour~=nil then
		printo("pts",113,base_y+13,7)
	end
	
	for i=1,cars_count do
		local y=base_y+23+i*8-8

		local j=res_sorting[i]
		if j==1 then
			rectfill(3,y-2,125,y+6,13)
			final_position=i
		end

		local ni=min(i+1,cars_count)
		local nj=res_sorting[ni]
		if (res_tour and tour[j]<tour[nj]) or (not res_tour and cars[j].finish_time > cars[nj].finish_time) then
			res_sorting[i],res_sorting[ni]=res_sorting[ni],res_sorting[i]
		end
		
		local c=car_colors[j][1]
		printo(posn[i],5,y,c)
		printo(car_colors[j][3],22,y,c)
		if not res_tour then
			printo(time_str(cars[j].finish_time),83,y,c)
		end
		if tour~=nil then
			if res_tour then
				printo(tour[j],117,y,c)
			else
				printo(cars_count-i+1,117,y,c)
			end
		end
	end
	
	printo("❎ continue",44,120,7)
	res_frame+=1
end
