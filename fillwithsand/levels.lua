
function lvlmenu()
    rectfill(48,86,79,109,4)
end

function lvl1(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    if goal then
        printo("<- fILL\n   WITH\n   SAND!",82,90,0x7,0)
        printo("<- pAINT\n  INSIDE\n  RECTANGLE\n\n  AND run\n(FROM MENU)",82,20,3,0)
    end
end

function lvl1a(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,4)
    if goal then
        printo("<- fILL\n   WITH\n   SAND!",82,90,0x7,0)
        printo("<-sAND IS\n  HEAVIER\n  THAN\n  WATER",82,20,3,0)
    end
end

function lvl2(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    if(goal)printo("<- fILL\n   WITH\n   PLANT!",85,90,0x6,0)

    rectfill(2,32,125,47,1)
    rectfill(48,32,79,45,0)
    rectfill(48,4,79,27,4)
    rectfill(2,28,5,31,6)
    if(goal)printo("<- wATCH\n   AND\n   LEARN",85,8,3,0)
end

function lvl3(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,6)
    if(goal)printo("<- bURN\n   THAT\n   PLANT!",85,90,0xc,0)

    rectfill(2,32,125,47,1)
    rectfill(6,8,49,11,6)
    rectfill(4,8,5,11,0xc)
    rectfill(6,24,49,27,2)
    rectfill(4,24,5,27,0xc)
    if goal then
        printo("pLANT BURNS FAST",48,8,6,0)
        printo("wOOD BURNS SLOWLY\n(USEFUL FOR TIMERS)",48,20,2,0)
    end
end

function lvl4(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,94,79,109,6)
    if(goal)printo("<- bURN\n   THAT\n   PLANT!",85,90,0xc,0)

    rectfill(2,32,125,47,1)
    rectfill(2,10,3,31,2)
    rectfill(2,8,3,9,0xc)
    rectfill(110,2,125,31,6)
    rectfill(48,4,79,27,4)
end

function lvl5(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,94,79,109,6)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)

    rectfill(2,30,125,31,1)
    rectfill(2,2,39,29,4)
    rectfill(40,2,41,27,1)
    rectfill(42,20,43,29,2)
    rectfill(42,18,43,19,0xc)
    rectfill(124,28,125,29,6)
    if(goal)printo("aND THE LAST ONE:\ntHIS IS TIMED VALVE!",45,3,3,0)
end

function lvl6(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,94,79,97,6)
    rectfill(48,104,79,109,6)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

function lvl7(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,90,79,93,6)
    rectfill(48,98,79,101,6)
    rectfill(48,106,79,109,6)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

function lvl8(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,88,79,91,6)
    rectfill(48,94,79,97,6)
    rectfill(48,100,79,103,6)
    rectfill(48,106,79,109,6)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

function lvl9(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,88,79,91,2)
    rectfill(48,94,79,97,2)
    rectfill(48,100,79,103,2)
    rectfill(48,106,79,109,2)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

function lvl10(goal)
    rectfill(2,86,125,109,1)
    rectfill(48,86,79,109,0)
    rectfill(48,88,79,91,2)
    rectfill(48,94,79,97,2)
    rectfill(48,100,79,103,2)
    rectfill(48,106,79,109,2)
    if(goal)printo("<- fILL\n   WITH\n   PLANT!",85,90,0x6,0)
end

function lvl_a(goal)
    rectfill(2,86,125,109,6)
    rectfill(48,86,79,109,0)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

function lvl_b(goal)
    rectfill(48,86,79,109,6)
    rectfill(4,96,7,99,6)
    rectfill(120,96,123,99,6)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

function lvl_c(goal)
    rectfill(2,86,125,109,7)
    rectfill(48,86,79,109,0)
    rectfill(44,86,47,109,2)
    rectfill(80,86,83,109,2)
    rectfill(48,106,79,109,6)
    if(goal)printo("<- fILL\n   WITH\n   WATER!",85,90,0x4,0)
end

levels={
    {d=lvl1,x1=48,y1=86,x2=79,y2=109,m=0x77,minx=48,maxx=79,miny=2,maxy=85,tip="sAND SHOULD FALL INTO THE HOLE."},
    {d=lvl1a,x1=48,y1=86,x2=79,y2=109,m=0x77,minx=48,maxx=79,miny=2,maxy=85},
    {d=lvl2,x1=48,y1=86,x2=79,y2=109,m=0x66,minx=2,maxx=125,miny=48,maxy=85,tip="fILL WITH WATER THEN GROW PLANT."},
    {d=lvl3,x1=48,y1=86,x2=79,y2=109,m=0x00,minx=2,maxx=125,miny=48,maxy=85},
    {d=lvl4,x1=48,y1=86,x2=79,y2=109,m=0x00,minx=2,maxx=125,miny=48,maxy=85,tip="tIP:fIRE CAN BURN UNDER WATER."},
    {d=lvl5,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=32,maxy=85},
    {d=lvl6,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85,tip="dOUBLE TROUBLE! :-)"},
    {d=lvl7,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85,tip="tRIPPLE TROUBLE! :-)"},
    {d=lvl8,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85,tip="really?"},
    {d=lvl9,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85,tip="uSE YOUR OWN PLANT! nOT MINE!"},
    {d=lvl10,x1=48,y1=86,x2=79,y2=109,m=0x66,minx=2,maxx=125,miny=2,maxy=85}, -- very hard

    {d=lvl_a,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85},
    {d=lvl_b,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85},
    {d=lvl_c,x1=48,y1=86,x2=79,y2=109,m=0x44,minx=2,maxx=125,miny=2,maxy=85,tip="tIK TOK TIK TOK"}, -- very hard

    --{d=lvl1a,x1=48,y1=86,x2=79,y2=109,m=0x77,minx=48,maxx=79,miny=2,maxy=85,avoid={0x11,0x44}},
}
