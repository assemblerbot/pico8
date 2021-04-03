transparent_patterns={
	0b1111111111111111.1,
	0b0101111101011111.1,
	0b0101111001011110.1,
	0b0101101001011010.1,
	0b0101100001011000.1,
	0b0101000001010000.1,
	0b0100000001000000.1,
	0b0000000000000000.1
}

function set_transparent_pattern(alpha)
	fillp(transparent_patterns[ceil(clamp(alpha*(#transparent_patterns-1),0,#transparent_patterns-1))+1])
end

function draw_sprite4(sx,sy,sw,sh,dx,dy)
	for ry=0,sh-1 do
		for rx=0,sw-1 do
			local c=sget(rx+sx,ry+sy)
			if c~=0 then
				rectfill(dx+rx*4,dy+ry*4,dx+rx*4+3,dy+ry*4+3,c)
			end
		end
	end
end

function printo(text,x,y,c)
	local d={0,0,-1,1,0,0}
	for j=1,4 do
		print(text, x+d[j+2], y+d[j], 0)
	end
	print(text, x, y, c)
end

function time_str(t)
	return tostr(num_to_str2(t\60)..":"..num_to_str21(t%60))
end

function num_to_str2(n)
	return tostr(n\10)..flr(n%10)
end

function num_to_str21(n)
	local tenths=flr((n%10)*10)
	return tostr(n\10)..tenths\10 .."."..tenths%10
end

function lap_to_str(lap)
	if lap==-1 then
		return ""
	end
	return "l"..(lap+1)
end

function draw_progress(x1,y1,x2,v,c1,c2)
	local y2=y1+3
	line(x1+1,y1,x2-1,y1,0)
	line(x1+1,y2,x2-1,y2,0)
	line(x1,y1+1,x1,y2-1,0)
	line(x2,y1+1,x2,y2-1,0)
	
	x1+=1
	x2-=1
	local x=flr(x2-(x2-x1)*v)
	if x>=x2 then return end
	
	line(x,y1+1,x2,y1+1,c1)
	line(x,y1+2,x2,y1+2,c2)
end
