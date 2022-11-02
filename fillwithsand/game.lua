win=false
complete=0

function count_cells(x1,y1,x2,y2,mat)
    local count=0
    if mat==0x44 then
        for y=y1,y2 do
            for x=x1,x2 do
                if(band(peek(0x6000+x+128*y),0xee)==0x44)count+=1 --water has 2 states
            end
        end
    else
        for y=y1,y2 do
            for x=x1,x2 do
                if(peek(0x6000+x+128*y)==mat)count+=1
            end
        end
    end
    return count
end

function init_game()
    win=false
    complete=0
    run_simulation()
end

function update_game()
    if btnp(4) then
        if win then
            level+=1
            if level>#levels then
                --ALL LEVELS WON
                level=1
            end
        end
        stop_simulation()
        state=2
    end

    local l=levels[level]
    local count=count_cells(l.x1\2,l.y1\2,l.x2\2,l.y2\2,l.m)
    local total_count=(l.x2\2-l.x1\2+1)*(l.y2\2-l.y1\2+1)

    if count==total_count then
        win=true
        stop_simulation()
    end

    complete=flr(100*count/total_count)
    if(count<total_count and complete==100)complete=99
end
function draw_game()
    rectfill(0,112,127,127,0)
    
    if win then
        local y=32
        rectfill(16,y,111,y+31,6)
        rect(16,y,111,y+31,3)
        printo("level complete!",34,y+13,3,0)
        print("\x8e next level",38,120,3)
    else
        print("\x8e edit",100,120,3)
        print("level:"..level,48,120,0xe)
        print(complete.."%",2,120,3)
        end
end