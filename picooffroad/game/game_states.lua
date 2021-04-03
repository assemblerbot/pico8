game_states={
	{init=title_init,update=title_update,draw=title_draw},
	{init=game_init,update=game_update,draw=game_draw},
	{init=results_init,update=results_update,draw=results_draw},
	{init=trophy_init,update=trophy_update,draw=trophy_draw}
}

game_state=1
next_state=0
trans=1
trans_dir=-0.066

function game_states_init()
	--set_state(1)
	title_init()
	title_update()
end

function game_states_update()
	if trans>0 then
		trans=max(trans+trans_dir,0)
		if trans>1 then
			trans=1
			trans_dir*=-1
			
			reload(0,0,0x2fff)
			pal()
			game_state=next_state
			game_states[game_state].init()
			game_states[game_state].update()
		end
	else
		game_states[game_state].update()
	end
end

function game_states_draw()
	game_states[game_state].draw()
	if trans>0 then
		set_transparent_pattern(trans)
		rectfill(0,0,127,127,0)
		fillp()
	end
end

function set_state(state)
	next_state=state
	trans_dir=0.066
	trans=0.01
end
