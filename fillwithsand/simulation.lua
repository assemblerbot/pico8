-- grid size: 64x56
--step=0

function init_simulation()
    local adr = 0x1000

    -- fill
    local w = 0
    for y=1,55 do
        for x=1,62 do
            poke2(adr+w,bor(x,shl(y,7))) -- shl 7 because it must be every second row
            w+=2
        end
    end

    -- deterministic shuffle
    srand(17)
    for i=0,62*55-1 do
        local target = adr+flr(rnd(62*55))*2
        local tmp = peek2(adr+i*2)
        poke2(adr+i*2,peek2(target))
        poke2(target,tmp)
    end
end

function update_simulation()
    local dir4={[0]=1,128,-1,-128}
    local stp=step
    local r=flr(rnd(0xffff))

    local val,dir,tgt
    for i=0,62*55-1 do
        local adr=0x6000+peek2(0x1000+i*2)
        local mat=peek(adr)

        if band(mat,0xf)>3 then -- except wall
            --water
            if band(mat,0xee)==0x44 then
                val=peek(adr+128)
                if val==0 then --down
                    poke(adr,0)
                    poke(adr+64,0)
                    poke(adr+128,mat)
                    poke(adr+192,mat)
                else
                    dir=band(mat,1)
                    if dir==0 then --left down
                        val=peek(adr+127)
                        if val==0 then
                            poke(adr,0)
                            poke(adr+64,0)
                            poke(adr+127,mat)
                            poke(adr+191,mat)
                        else
                            val=peek(adr-1)
                            if val==0 then --left
                                poke(adr,0)
                                poke(adr+64,0)
                                poke(adr-1,mat)
                                poke(adr+63,mat)
                            else
                                poke(adr,0x55) --change from left to right water
                            end
                        end
                    else
                        val=peek(adr+129)
                        if val==0 then --right down
                            poke(adr,0)
                            poke(adr+64,0)
                            poke(adr+129,mat)
                            poke(adr+193,mat)
                        else
                            val=peek(adr+1)
                            if val==0 then --right
                                poke(adr,0)
                                poke(adr+64,0)
                                poke(adr+1,mat)
                                poke(adr+65,mat)
                            else
                                poke(adr,0x44) --change from right to left water
                            end
                        end
                    end
                end
            --plant
            elseif mat==0x66 then
                tgt=adr+dir4[band(i+stp+r,3)]
                val=peek(tgt)
                if band(val,0xee)==0x44 then --it's water -> grow
                    poke(tgt,mat)
                    poke(tgt+64,mat)
                end
            --sand
            elseif mat==0x77 then
                val=peek(adr+128)
                if val==0 or band(val,0xee)==0x44 then --down
                    poke(adr,val)
                    poke(adr+64,val)
                    poke(adr+128,mat)
                    poke(adr+192,mat)
                else
                    dir=band(i+stp+r,1)
                    if dir==0 then --left down
                        val=peek(adr+127)
                        if val==0 or band(val,0xee)==0x44 then
                            poke(adr,val)
                            poke(adr+64,val)
                            poke(adr+127,mat)
                            poke(adr+191,mat)
                        end
                    else
                        val=peek(adr+129)
                        if val==0 or band(val,0xee)==0x44 then --right down
                            poke(adr,val)
                            poke(adr+64,val)
                            poke(adr+129,mat)
                            poke(adr+193,mat)
                        end
                    end
                end
            --slow burn
            elseif mat>=0x88 and mat<=0xbb then
                if stp==0 then --slow
                    tgt=adr+dir4[band(i+mat,3)]
                    val=peek(tgt)
                    if val==0x22 then --spread to wood
                        poke(tgt,0x88)
                        poke(tgt+64,0x88)
                    elseif val==0x66 then --spread to plant
                        poke(tgt,0xcc)
                        poke(tgt+64,0xcc)
                    end

                    if mat==0xbb then
                        mat=0
                    else
                        mat+=0x11
                    end
                    poke(adr,mat)
                    poke(adr+64,mat)
                end
            --fast burn
            elseif mat>=0xcc and mat<=0xff then
                tgt=adr+dir4[band(i+mat,3)]
                val=peek(tgt)
                if val==0x22 then --spread to wood
                    poke(tgt,0x88)
                    poke(tgt+64,0x88)
                elseif val==0x66 then --spread to plant
                    poke(tgt,0xcc)
                    poke(tgt+64,0xcc)
                end

                if mat==0xff then
                    mat=0
                else
                    mat+=0x11
                end
                poke(adr,mat)
                poke(adr+64,mat)
            end
        end
    end

    step=band(step+1,0xf)
end
