map_ofs_x=0
map_ofs_y=0

track=1

car_controls=1

tracks={
	{u=0x2000,d=0x2800,rm=racing_map1,wp=waypoints_racing_map1,st=starts_racing_map1},
	{u=0x1800,d=0x1840,rm=racing_map2,wp=waypoints_racing_map2,st=starts_racing_map2},
	{u=0x2040,d=0x2840,rm=racing_map3,wp=waypoints_racing_map3,st=starts_racing_map3}
}

function game_init()
 --music(-1)
 local t=tracks[track]
 pal(5,132,1)
 pal(15,143,1)
 
 for i=0,1920,128 do
	reload(0x2000+i,t.u+i,64)
	reload(0x2800+i,t.d+i,64)
 end
 
 shadows_init("0,0,2,3,5,1,6,7,8,4,4,11,1,13,14,4")
 tiles_init(t.rm,t.wp,t.st)
 sprite_map_init(0,0)
 car_rendering_init()
 cars_init()
end

function game_update()
 cars_update()

 if car_controls==1 then
  local new_ofs_x=cars[1].screen_x-64
  local new_ofs_y=cars[1].screen_y-64
  map_ofs_x=max(0,min(384,new_ofs_x))
  map_ofs_y=max(0,min(128,new_ofs_y))
 else
  debug_screen_controls()
 end
end

function game_draw()
 palt(0,false)
 sprite_map_draw(-map_ofs_x,-map_ofs_y)
 cars_draw(map_ofs_x,map_ofs_y)
 palt(0,true)
 second_sprite_map_draw(-map_ofs_x,-map_ofs_y)

 if btn(❎) and car_controls==0 then
 	tiles_draw(map_ofs_x,map_ofs_y,not btn(🅾️))
 end

	game_ui_draw()
end
