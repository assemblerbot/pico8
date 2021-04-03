presorted_count=16

function car_rendering_init()
	transformed_vertices={}
	projected_vertices={}
	sorted_triangles={}

	for i=0,presorted_count-1 do
		local yaw=(i+0.5)*pi2/presorted_count
		car_transform(car_vertices, transformed_vertices, yaw,0,0,1)

		local triangles=cull_triangles(transformed_vertices,car_triangles,-0.5,0.5,1)
		sort_triangles(transformed_vertices,triangles)
		add(sorted_triangles,triangles)
	end
end

function car_draw(pos_x,pos_y,yaw,pitch,roll,scale)
	car_transform(car_vertices, transformed_vertices, yaw,pitch,roll,scale)
	project_vertices(transformed_vertices,projected_vertices,pos_x,pos_y)

	local yaw_index=flr((yaw+0.3*abs(pitch)+abs(roll)*0.2)/pi2*presorted_count)%presorted_count+1
	draw_triangles(projected_vertices,sorted_triangles[yaw_index])
end

function transformation(vec,yaw_sin,yaw_cos,pitch_sin,pitch_cos,roll_sin,roll_cos,scale)
	local x,y,z=vec.x,vec.y,vec.z
	if roll_sin ~= 0 then
		z,y=rotatesincos(z,y,roll_sin,roll_cos)
	end
	if pitch_sin ~= 0 then
		x,y=rotatesincos(x,y,pitch_sin,pitch_cos)
	end
	x,z=rotatesincos(x,z,yaw_sin,yaw_cos)
	return {x=x*scale,y=y*scale,z=z*scale}
end

function car_transform(vertices_in, vertices_out, yaw, pitch, roll, scale)
	local yaw_sin=sin(yaw)
	local yaw_cos=cos(yaw)
	local pitch_sin=sin(pitch)
	local pitch_cos=cos(pitch)
	local roll_sin=sin(roll)
	local roll_cos=cos(roll)

	for i=1,#vertices_in do
		vertices_out[i]=transformation(vertices_in[i],yaw_sin,yaw_cos,pitch_sin,pitch_cos,roll_sin,roll_cos,scale)
	end
end
