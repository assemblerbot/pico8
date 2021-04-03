function project_vertices(vertices_in, vertices_out, offset_x,offset_y)
	for i=1,#vertices_in do
		vertices_out[i]={x=flr(vertices_in[i].x+0.5*vertices_in[i].z)+offset_x,y=flr(vertices_in[i].y-0.5*vertices_in[i].z)+offset_y}
	end
end

function sort_triangles(vertices,triangles)
	local triangles_count=#triangles/4
	for i=0,triangles_count-2 do
		local z1=(vertices[triangles[1+i*4]].z+vertices[triangles[2+i*4]].z+vertices[triangles[3+i*4]].z)/3
		local best_i=i
		local best_z=z1
		for j=i+1,triangles_count-1 do
			local z2=(vertices[triangles[1+j*4]].z+vertices[triangles[2+j*4]].z+vertices[triangles[3+j*4]].z)/3
			if z2>best_z then
				best_i=j
				best_z=z2
			end
		end
		if best_i~=i then
			for j=0,3 do
				triangles[1+i*4+j],triangles[1+best_i*4+j]=triangles[1+best_i*4+j],triangles[1+i*4+j]
			end
		end
	end
end

function cull_triangles(vertices,triangles,dir_x,dir_y,dir_z)
	local out={}
	local triangles_count=#triangles/4
	for i=0,triangles_count-1 do
		local nx,ny,nz = calc_triangle_normal(vertices,triangles,i)
		if dot(nx,ny,nz,dir_x,dir_y,dir_z) < 0 then
			for j=1,4 do
				add(out,triangles[j+i*4])
			end
		end
	end
	return out
end

function calc_triangle_normal(vertices,triangles,idx)
	local i1=triangles[1+idx*4]
	local i2=triangles[2+idx*4]
	local i3=triangles[3+idx*4]
	return cross(vertices[i3].x-vertices[i1].x,vertices[i3].y-vertices[i1].y,vertices[i3].z-vertices[i1].z,vertices[i2].x-vertices[i1].x,vertices[i2].y-vertices[i1].y,vertices[i2].z-vertices[i1].z)
end

function draw_triangles(vertices2d,triangles)
	local triangles_count=#triangles/4
	for i=0,triangles_count-1 do
		draw_triangle(vertices2d[triangles[1+i*4]],vertices2d[triangles[2+i*4]],vertices2d[triangles[3+i*4]],triangles[4+i*4]-1)
	end
end

function draw_triangle(v1,v2,v3,colour)
	local x1,y1,x2,y2,x3,y3=v1.x,v1.y,v2.x,v2.y,v3.x,v3.y
	if x1==x2 and y1==y2 then
		pset(x1,y1,color)
		return
	end

	if y2<y1 then
		x1,y1,x2,y2=x2,y2,x1,y1
	end
	if y3<y2 then
		x2,y2,x3,y3=x3,y3,x2,y2
	end
	if y2<y1 then
		x1,y1,x2,y2=x2,y2,x1,y1
	end
	
	local y=y1
	local dxl=(x2-x1)/(y2-y1)
	local dxr=(x3-x1)/(y3-y1)
	local xl,xr=x1,x1
	
	while y<y2 do
		rectfill(xl,y,xr,y,colour)
		xl+=dxl
		xr+=dxr
		y+=1
	end
	
	xl=x2
	dxl=(x3-x2)/(y3-y2)
	while y<=y3 do
		rectfill(xl,y,xr,y,colour)
		xl+=dxl
		xr+=dxr
		y+=1
	end
end
