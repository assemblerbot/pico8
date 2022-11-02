grid={}
cursor={32,32}
material_index=6
cursor_size=2
blink=0
menu_mode=false
run_timer=0
total_run_timer=30
fill_pattern={0b1001001101101100.100,0b0011011011001001.100,0b0110110010010011.100,0b1100100100110110.100}
pattern_index=1
pattern_timer=0
edited_level=0

min_edit_x=1
max_edit_x=62
min_edit_y=1
max_edit_y=42
avoid={}

input_delay_frames=5
input_timer=input_delay_frames

function contains (tab, val)
    for index, value in ipairs(tab) do
        if(value == val)return true
    end
end

function init_editor()
    if level!=edited_level then
        new_level()
        edited_level=level
        local l=levels[level]
        min_edit_x=flr(l.minx/2)
        min_edit_y=flr(l.miny/2)
        max_edit_x=flr(l.maxx/2)
        max_edit_y=flr(l.maxy/2)
        if l.avoid~=nil then
            avoid=l.avoid
        else
            avoid={}
        end

        while contains(avoid,materials[material_index]) do
            material_index=material_index%#materials+1
        end
    end
end
function update_editor()
    if btnp(4) then
        menu_mode=not menu_mode
    end
    if menu_mode then
        update_editor_menu()
    else
        update_editor_paint()
    end
end
function update_editor_menu()
    if btnp(0) then
        repeat
            material_index=(material_index+#materials-2)%#materials+1
        until not contains(avoid,materials[material_index])
    end
    if btnp(1) then
        repeat
            material_index=material_index%#materials+1
        until not contains(avoid,materials[material_index])
    end

    if btnp(2) then
        cursor_size=cursor_size%4+1
    end
    if btnp(3) then
        cursor_size=(cursor_size+4-2)%4+1
    end
    if btn(5) then
        run_timer+=1
        if run_timer>=total_run_timer then
            --RUN SIMULATION
            menu_mode=false
            run_timer=0
            state=3
            draw_level(false)
            return
        end
    else
        run_timer=0
    end
end
function update_editor_paint()
    if btn(0) and input_timer<=0 or btnp(0) then
        cursor[1]-=1
    end
    if btn(1) and input_timer<=0 or btnp(1) then
        cursor[1]+=1
    end
    if btn(2) and input_timer<=0 or btnp(2) then
        cursor[2]-=1
    end
    if btn(3) and input_timer<=0 or btnp(3) then
        cursor[2]+=1
    end

    if btn(0) or btn(1) or btn(2) or btn(3) then
        input_timer-=1
    else
        input_timer=input_delay_frames
    end

    if cursor[1]<min_edit_x then
        cursor[1]=min_edit_x
    end
    if cursor[1]>(max_edit_x+1-cursor_size) then
        cursor[1]=max_edit_x+1-cursor_size
    end
    if cursor[2]<min_edit_y then
        cursor[2]=min_edit_y
    end
    if cursor[2]>(max_edit_y+1-cursor_size) then
        cursor[2]=max_edit_y+1-cursor_size
    end

    if btn(5) then
        for y=0,cursor_size-1 do
            for x=0,cursor_size-1 do
                grid[cursor[1]+x+(cursor[2]+y)*64]=materials[material_index]
            end
        end
    end
end
function draw_editor()
    draw_level(true)

    fillp(fill_pattern[pattern_index])
    rect(min_edit_x*2-1,min_edit_y*2-1,max_edit_x*2+2,max_edit_y*2+2,3)
    fillp()
    
    pattern_timer=(pattern_timer+1)%4
    if(pattern_timer==0)pattern_index=pattern_index%#fill_pattern+1

    if menu_mode then
        -- menu
        local y=24
        rectfill(16,y,111,y+57,1)
        rect(16,y,111,y+57,3)

        -- materials
        local x=31
        y+=6
        printo("\x8b",x,y,3,0)
        printo("\x91",x+58,y,3,0)
        for i=1,#materials do
            rectfill(x+1+i*7,y-1,x+7+i*7,y+5,0)
            rectfill(x+2+i*7,y,x+6+i*7,y+4,band(materials[i],0xf))
            if contains(avoid,materials[i]) then
                line(x+1+i*7,y-1,x+7+i*7,y+5,3)
                line(x+1+i*7,y+5,x+7+i*7,y-1,3)
            end
            if materials[material_index]==materials[i] then
                rect(x+1+i*7,y-1,x+7+i*7,y+5,3)
            end
        end
        y+=8
        printo("material:",x,y,3,0)
        print_mname(materials[material_index],x+36,y)

        -- brush
        y+=12
        printo("\x83",x,y,3,0)
        printo("\x94",x+20,y,3,0)
        rectfill(x+14-cursor_size,y+2-cursor_size,x+14+cursor_size-1,y+2+cursor_size-1,0)
        y+=8
        printo("brush:"..cursor_size.."X"..cursor_size,x,y,3,0)

        -- controls
        y+=12
        printo("\x8e close",x,y,6,0)
        printo("\x97 run!",x+39,y,0xc,0)
        if run_timer>0 then
            rectfill(17,y+7,17+(110-17)*run_timer/total_run_timer,y+10,0xc)
            rect(17,y+7,17+(110-17)*run_timer/total_run_timer,y+10,0)
        end
    else
        -- cursor
        local cx=cursor[1]*2-1
        local cy=cursor[2]*2-1
        local dx=cx+1+2*cursor_size
        local dy=cy+1+2*cursor_size
        if blink<8 then
            rect(cx,cy,dx,dy,band(materials[material_index],0xf))
        end
        pset(cx,cy,3)
        pset(cx,dy,3)
        pset(dx,cy,3)
        pset(dx,dy,3)

        -- controls
        print("\x97 paint",1,120,3)
        print("\x8e menu",100,120,3)
    end

    if(levels[level].tip!=nil) print(levels[level].tip,1,113,1)
    print("level:"..level,48,120,0xe)

    blink=(blink+1)%16
end
function draw_level(show_goal)
    cls(0)
    -- grid
    for y=0,55 do
        for x=0,63 do
            local adr=0x6000+x+y*128
            local mat=grid[x+y*64]
            poke(adr,mat)
            poke(adr+64,mat)
        end
    end
    -- border
    rectfill(0,0,127,1,1)
    rectfill(0,0,1,111,1)
    rectfill(126,0,127,111,1)
    rectfill(0,110,127,111,1)
    -- level
    levels[level].d(show_goal)
end
function new_level()
    for y=0,55 do
        for x=0,63 do
            grid[x+y*64]=0
        end
    end
end
