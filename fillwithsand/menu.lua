function draw_menu_level()
    cls(0)
    -- border
    rectfill(0,0,127,1,1)
    rectfill(0,0,1,111,1)
    rectfill(126,0,127,111,1)
    rectfill(0,110,127,111,1)
    -- level
    lvlmenu()
end

function init_menu()
    draw_menu_level()
    run_simulation()
end
function update_menu()
    if(btnp(0))level-=1
    if(btnp(1))level+=1
    if(level<1)level=#levels
    if(level>#levels)level=1
    
    if btnp(4) then
        stop_simulation()
        state=2
    end
end
function draw_menu()
    rectfill(0,112,127,127,0)
    print("\x8b level:"..level.." \x91",3,120,0xe)
    print("\x8e start",94,120,3)
end
