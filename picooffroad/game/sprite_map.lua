sprite_map_w=64
sprite_map_h=32
sprite_map_x=0
sprite_map_y=0
second_sprite_map_x=64
second_sprite_map_y=0

function sprite_map_init(tx,ty)
	sprite_map_x=tx
	sprite_map_y=ty
	for y=0,sprite_map_h-1 do
		for x=0,sprite_map_w-1 do
			local sprite=mget(tx+x,ty+y)
			if sprite>=64 and fget(sprite,1) then
				mset(tx+x,ty+y,sprite-64)
				mset(second_sprite_map_x+x,second_sprite_map_y+y,sprite)
			else
				mset(second_sprite_map_x+x,second_sprite_map_y+y,0)
			end
		end
	end
end

function sprite_map_draw(ofs_x,ofs_y)
	map(sprite_map_x,sprite_map_y,ofs_x,ofs_y,64,32)
end

function second_sprite_map_draw(ofs_x,ofs_y)
	map(second_sprite_map_x,second_sprite_map_y,ofs_x,ofs_y,64,32)
end
