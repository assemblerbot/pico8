hpi=1.57075
pi=3.1415
pi2=6.283

cos1 = cos function cos(angle) return cos1(angle/(pi2)) end
sin1 = sin function sin(angle) return -sin1(angle/(pi2)) end
atan21 = atan2 function atan2(x,y) return atan21(x,-y)*pi2 end

function isometry(x,y,z)
	return x+511-z/2, z/2-y
end

function clamp(a,min_value,max_value)
	return min(max(a,min_value), max_value)
end

function rotate(x,y,angle)
	local c=cos(angle)
	local s=sin(angle)
	return x*c-y*s,x*s+y*c
end

function rotatesincos(x,y,s,c)
	return x*c-y*s,x*s+y*c
end

function cross(x1,y1,z1,x2,y2,z2)
	return y1*z2-z1*y2, z1*x2-x1*z2, x1*y2-y1*x2
end

function dot(x1,y1,z1,x2,y2,z2)
	return x1*x2+y1*y2+z1*z2
end

function normalize(x,y,z)
	local d=1/sqrt(x*x+y*y+z*z)
	return x*d,y*d,z*d
end

function normalize2d(x,y)
	local d=1/sqrt(x*x+y*y)
	return x*d,y*d
end

function lerp(a,b,t)
	return a+(b-a)*t
end