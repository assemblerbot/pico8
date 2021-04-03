function shadows_init(shading)
	local shadow_color=split(shading)
	for i=0,255 do
		poke(0x4300|i,shadow_color[(i&0xf)+1]|(shadow_color[((i>>4)&0xf)+1]<<4))
	end
end

function draw_shade(x1,y1,x2,y2,x3,y3,x4,y4)
	y1=flr(y1)
	y2=flr(y2)
	y3=flr(y3)
	y4=flr(y4)
	
	shade_edge(x1,y1,x2,y2)
	shade_edge(x2,y2,x3,y3)
	shade_edge(x3,y3,x4,y4)
	shade_edge(x4,y4,x1,y1)
	
	local min_y=clamp(min(y1,min(y2,min(y3,y4))),0,127)
	local max_y=clamp(max(y1,max(y2,max(y3,y4))),0,127)
	
	for y=min_y,max_y do
		local xl=peek(0x4400+y)\2
		local xr=peek(0x4480+y)\2
		local scanline=0x6000+y*64
		for x=xl,xr do
			poke(scanline+x,peek(0x4300|peek(scanline+x)))
		end
	end
end

function shade_edge(x1,y1,x2,y2)
	if y1<y2 then
		local dx=(x2-x1)/(y2-y1)
		while y1<=y2 do
			if y1>=0 and y1<=127 then
				poke(0x4400|y1,clamp(x1,0,127))
			end
			x1+=dx
			y1+=1
		end
	elseif y1>y2 then
		local dx=(x1-x2)/(y1-y2)
		while y2<=y1 do
			if y2>=0 and y2<=127 then
				poke(0x4480|y2,clamp(x2,0,127))
			end
			x2+=dx
			y2+=1
		end
	elseif y1>=0 and y1<=127 then
		x1=clamp(x1,0,127)
		x2=clamp(x2,0,127)
		if x1<x2 then
			poke(0x4400|y1,x1)
			poke(0x4480|y1,x2)
		else
			poke(0x4400|y1,x2)
			poke(0x4480|y1,x1)
		end
	end
end