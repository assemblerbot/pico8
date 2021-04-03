tiles_w=64
tiles_h=64

function tiles_init(compressed_map,waypoints_count,start_indexes)
	tiles_type={}
	tiles_height={}
	tiles_waypoints={}
	
	waypoints={}
	for i=1,waypoints_count do
		add(waypoints,{})
	end

	dec={}
	local i=1
	while i<=#compressed_map do
		local c=ord(compressed_map,i)
		if c>=189 then
			add(dec,c)
			i+=1
		else
			local ofs=c-93
			c=ord(compressed_map,i+1)
			local l=c-32+3
			if l>=65 then
				l-=29
			end
			
			local start=#dec-ofs;
			for j=1,l do
				add(dec,dec[start+j])
			end
			i+=2
		end
	end
	
	local tile,height
	for i=1,#dec do
		local v,waypoint=dec[i],-1
		if v==189 then 
			tile=11
		elseif v==190 then
			tile=12
		elseif v<=205 then
			tile=11
			local tx,tz=tile_index_to_position(#tiles_type-1)
			waypoint=v-191
			add(waypoints[waypoint+1],tx)
			add(waypoints[waypoint+1],tz)
		elseif v<=230 then
			tile = (v-206)%5 + 1
			height = (v-206)\5*8
		else
			tile = (v-231)%5 + 1 + 5
			height = (v-231)\5*8
		end
		
		add(tiles_waypoints,waypoint)
		add(tiles_type,tile)
		add(tiles_height,height)
	end

	build_collision_solutions()
		
	tile_height_func={
		tile_flat,
		tile_ascend_px,
		tile_ascend_mx,
		tile_ascend_pz,
		tile_ascend_mz,
		tile_flat,
		tile_ascend_px,
		tile_ascend_mx,
		tile_ascend_pz,
		tile_ascend_mz,
		tile_flat,
		tile_flat_rough,
	}
	
	start_positions={}
	for i=1,#start_indexes do
		local x,z=tile_index_to_position(start_indexes[i])
		add(start_positions,x)
		add(start_positions,z)
	end
end

function build_collision_solutions()
	tile_cs={}
	for z=0,tiles_h-1 do
		for x=0,tiles_w-1 do
			local sx,sz=collision_solution(x,z,"11111111112202121120001011210111")
			add(tile_cs,sx)
			add(tile_cs,sz)
		end
	end
	
	local filtered_solution={}
	for z=0,tiles_h-1 do
		for x=0,tiles_w-1 do
			local sx,sz=collision_solution_filter(x,z)
			add(filtered_solution,sx)
			add(filtered_solution,sz)
		end
	end
	
	tile_cs=filtered_solution
end

function collision_solution(x,z,cmbn)
	local t=tiles_type[x+z*tiles_w+1]
	if not tile_is_obstacle(t) then
		return 0,0
	end
	
	local mx=tile_is_obstacle_number(get_tile_type(x-1,z))
	local px=tile_is_obstacle_number(get_tile_type(x+1,z))
	local mz=tile_is_obstacle_number(get_tile_type(x,z-1))
	local pz=tile_is_obstacle_number(get_tile_type(x,z+1))
	
	local index=1+mx+px*2+mz*4+pz*8
	return ord(cmbn,(index-1)*2+1)-49,ord(cmbn,(index-1)*2+2)-49
end

function collision_solution_filter(x,z)
	local t=tiles_type[x+z*tiles_w+1]
	if not tile_is_obstacle(t) then
		return 0,0
	end
	
	local sx,sz=get_collision_solution(x,z)
	if sx~=0 or sz~=0 then
		return sx,sz
	end
	
	local dx,dz
	dx,dz=get_collision_solution(x-1,z)
	sx+=dx sz+=dz
	dx,dz=get_collision_solution(x+1,z)
	sx+=dx sz+=dz
	dx,dz=get_collision_solution(x,z-1)
	sx+=dx sz+=dz
	dx,dz=get_collision_solution(x,z+1)
	sx+=dx sz+=dz
	
	if sx==0 and sz==0 then
		return 0,0
	end
	
	return normalize2d(sx,sz)
end

function get_tile_type(tx,tz)
	return tiles_type[tilec_rot(tx,tiles_w)+tilec_rot(tz,tiles_h)*tiles_w+1]
end

function get_collision_solution(tx,tz)
	local index=(tilec_rot(tx,tiles_w)+tilec_rot(tz,tiles_h)*tiles_w)*2+1
	return tile_cs[index],tile_cs[index+1]
end

function sample_collision_solution(x,z)
	local index=(tilec_rot(flr(x/8),tiles_w)+flr(z/8)*tiles_w)*2+1
	local sx,sz=tile_cs[index],tile_cs[index+1]
	if sx==nil or sz==nil then
		return 0,0
	end
	return sx,sz
end

function sample_tile_map(x,z)
	local tx=tilec_rot(flr(x/8),tiles_w)
	local tz=clamp(flr(z/8),0,tiles_h-1)
	local index=tx+tz*tiles_w+1
	return tiles_type[index],tile_height_func[tiles_type[index]](x%8,z%8)+tiles_height[index],tiles_waypoints[index]
end

function tilec_rot(x,w)
	if x<0  then x+=w end
	if x>=w then x-=w end
	return x
end

function tile_flat(x,z)
	return 0
end
function tile_flat_rough(x,z)
	return ((x>>1)^(z>>1))&1
end
function tile_ascend_px(x,z)
	return x
end
function tile_ascend_mx(x,z)
	return 7-x
end
function tile_ascend_pz(x,z)
	return z
end
function tile_ascend_mz(x,z)
	return 7-z
end

function tile_is_obstacle(t)
	return t>=6 and t<=10
end

function tile_is_obstacle_number(t)
	if tile_is_obstacle(t) then return 1 else return 0 end
end

function tile_is_dirt(t)
	return t==11
end

function height_is_water(y)
	return y<2
end

function tile_index_to_position(index)
	local x=index%tiles_w
	local z=index\tiles_w
	if x>=z\2 then
		x-=tiles_w
	end
	return x*8+4,z*8+4
end




