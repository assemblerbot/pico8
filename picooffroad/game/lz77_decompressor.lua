function lz77_decomp(x0,y0,w,h,src,vset)
	local i,d=1,{}
	while i<=#src do
		local c=ord(src,i)
		if c<48 then
			add(d,c-32)
		else
			local ofs,run=w,c-46
			if c>=94 then
				run-=29
			end
			if run>=103 then
				run-=101
			else
				i+=1
				ofs=ord(src,i)-31
				if ofs>=63 then
					ofs-=29
				end
			end
			local pos=#d-ofs
			for j=1,run do
				add(d,d[pos+j])
			end
		end
		i+=1
	end
	for i=0,w*h-1 do
		vset(i%w+x0,i\w+y0,d[i+1])
	end
end
