simulation_running=false
step=0
state=1
level=1

materials={0,0x11,0x22,0x44,0x66,0x77,0xcc}
mnames={[0]="void",[0x11]="wall",[0x22]="wood",[0x44]="water",[0x66]="plant",[0x77]="sand",[0xcc]="fire"}

function printo(str,x,y,col,ocol)
    if(col==ocol)ocol=3
    for oy=-1,1 do
        for ox=-1,1 do
            print(str,x+ox,y+oy,ocol)
        end
    end
    print(str,x,y,col)
end

function print_mname(material,x,y)
    printo(mnames[material],x,y,band(material,0xf),0)
end

function run_simulation()
    simulation_running=true
    step=0
    srand(17)
end
function stop_simulation()
    simulation_running=false
end