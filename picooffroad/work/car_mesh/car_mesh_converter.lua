function convert()
	local minx,miny,minz,maxx,maxy,maxz=999,999,999,-999,-999,-999
	for i=0,#car_vertices\3-1 do
		local idx=1+i*3

		minx=min(car_vertices[idx],minx)
		miny=min(car_vertices[idx+1],miny)
		minz=min(car_vertices[idx+2],minz)

		maxx=max(car_vertices[idx],maxx)
		maxy=max(car_vertices[idx+1],maxy)
		maxz=max(car_vertices[idx+2],maxz)
	end

	local sizex=maxx-minx
	local sizey=maxy-miny
	local sizez=maxz-minz
	
	local mn=min(min(minx,miny),minz)
	local size=max(max(sizex,sizey),sizez)
	
	--printh("car_minx,car_miny,car_minz,car_sizex,car_sizey,car_sizez="..minx..","..miny..","..minz..","..sizex..","..sizey..","..sizez,"dump.txt")
	printh("car_min,car_vscale="..mn..","..size/194,"dump.txt")
	
	local out="car_verticesc=[["
	for i=0,#car_vertices\3-1 do
		local idx=1+i*3

		--out=out..value_to_char(flr((car_vertices[idx  ]-minx)/sizex*194))
		--out=out..value_to_char(flr((car_vertices[idx+1]-miny)/sizey*194))
		--out=out..value_to_char(flr((car_vertices[idx+2]-minz)/sizez*194))
		out=out..value_to_char(flr((car_vertices[idx  ]-mn)/size*194))
		out=out..value_to_char(flr((car_vertices[idx+1]-mn)/size*194))
		out=out..value_to_char(flr((car_vertices[idx+2]-mn)/size*194))
	end
	out=out.."]]"
	printh(out,"dump.txt")
	
	local out="car_trianglesc=[["
	for i=1,#car_triangles do
		out=out..value_to_char(flr(car_triangles[i]))
	end
	out=out.."]]"
	printh(out,"dump.txt")
	
	print("DONE")
end

function value_to_char(value) -- 0..1
	if value<0 or value>194 then
		stop("value out of range! "..value)
	end
	
	if value<33 then
		return chr(value+32)
	else
		return chr(value+94-33)
	end
end
