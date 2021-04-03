tile_color_top   ={ 4, 5,15, 5,15,14,14,14,14,14, 9, 4}
tile_color_bottom={ 4, 4, 4, 4,15, 8, 8, 8, 8, 8, 9, 4}

function tiles_draw(ofs_x,ofs_y,transparent)
	for y=0,127 do
		for x=0,127 do
			if (not transparent) or ((x&1)==1) then
				local pix_x=ofs_x+x
				local pix_y=ofs_y+y
				local map_x=pix_x-511+pix_y
				local map_z=pix_y*2
				
				local t,h,wp=sample_tile_map(map_x,map_z)
				local c=tile_color_bottom[t]
				rectfill(x,y,x,y-h+1,1)
				
				c=tile_color_top[t]
				if t==1 and h==0 then
					c=12 -- water
				end
				
				local sx,sz=sample_collision_solution(map_x,map_z)
				if sx==0 and sz==0 and tile_is_obstacle(t) then
					c=8
				end
				
				if wp~=-1 and ((x^^y)&1==1) then
					c=wp
				end
				
				pset(x,y-h,c)
			end
		end
	end
end

function dump_sprite_map()
	for y=0,sprite_map_h-1 do
		for x=0,sprite_map_w-1 do
			printh(mget(x,y),"map_dump.txt")
		end
	end
end

function debug_screen_controls()
  if btn(⬅️) then map_ofs_x=max(0  ,map_ofs_x-8) end
  if btn(➡️) then map_ofs_x=min(384,map_ofs_x+8) end
  if btn(⬆️) then map_ofs_y=max(0  ,map_ofs_y-8) end
  if btn(⬇️) then map_ofs_y=min(128,map_ofs_y+8) end
end