trophy_image=[[ ね ◝リ**❎w*1 ミ<ゃ2웃8♪6-n'_{:|ハ<う7スゆ/4!/4'ほ)6!6 み<⬇️4レ8'5♥6"5▥7ル8➡️<s<ク7∧?ソeテ8q;ハへ7ユ6♪hソ3テ5ユ9|も?♪7テ9す9ソま:{や6ャ9ソfテほ<yよ>◆6ノ=♥6テ@v6%=♪9テbソ3テ^⬅️を6ケ5テaソセ9ソfテソ=ソeテス:テbソ3テろ2ノり=テ9 9ソる;⬆️む9ソfテよ7⬇️る6チ7♥7テ5♥6テゃ:ツ9⬅️fソ3テ>る=ヒ>チ7テaソり@❎へ9ソfテや;█ら=ソeテ`タ>ツ2x9テbソ3テb~@マ=テ9 9ソむ=⬅️<ミ;ソfテよ:⬅️;ム8チ7♥7テ5♥6テcタ>♪_ツ^チe⬅️;テ4タ8チ9웃<チf⬅️5ヨ3ラ2z2🐱6セ`ソ6チ8sd♪3y4ス=☉2ツ7ソふe⬅️8テ2ソ3☉6"3/9🅾️8チg⬅️6ヲ4◜2チ6●9ト3⌂6テ5ロc⬅️9🅾️3▒9チ5タ3~1ツ5♪k⌂:ト3▒2░@チ2ソ3#m⬅️;♪4ツ3⬆️み4ス8タk⬅️9ト3チ<☉5タ3…2ヒn⌂7ト3⌂6♪4ツ2ウ5スふq⬅️6ナ3ス2テ8ト6♪2タu웃7ナ5ト2'8タ5チy⬅️7♪2ネ:タ▒ソ=テ6ツ4⬅️○ソ:♪1テ3フ☉ソ7ト3⬅️4ソ2♪⬇️セb♪웃⬅️4テ2ナ8⌂☉⬅️7テ⧗⬅️6ト6♪😐⌂3ト7タ◆⬅️5テˇ⬅️2ト1テˇ⌂◝◝◝◝◝◝◝◝◝◝◝◝◝◝>⬅️ひ∧ツ◝◝は2タッ4タˇツ◝◝7タ⧗ツ◝◝2ソ2!4ツ♪テ1✽8⬅️🅾️テねチねチrス5ソ6ト✽ナ2░^♪ねチねチさチ7シ:セ5ツ○…2🐱f♪ねチねチあチ%v ◝◝ソ/l *テ*k )◝◝◝◝◝◝ネ*)l ツs#◝◝コ#x ◝クね^セ]]

function trophy_init()
	pal()
	pal(3,128,1)
	pal(15,7)
	
	if final_position==2 then
		pal(9,5)
		pal(10,6)
	elseif final_position==3 then
		pal(9,132,1)
		pal(10,4)
		pal(15,137,1)
	end

	lz77_decomp(0,0,80,112,trophy_image,sset)
	music(-1)
	sfx(57)
	
	dots={}
	for i=1,64 do
		add(dots,{x=rnd(128),y=rnd(128)-128})
	end
end

function trophy_update()
	if btnp(5) then
		sfx(51)
		set_state(1)
	end
end

function trophy_draw()
	for y=-1,15 do
		for x=-1,15 do
			local ofs=(time()*16)%8
			rectfill(x*8+ofs,y*8+ofs,x*8+7+ofs,y*8+7+ofs,((x^^y)&1))
		end
	end
	
	spr(0,24,2,10,14)

	print(posn[final_position],58,100,1)

	for i=1,64 do
		local dx=flr(rnd(5))-2
		local dy=flr(rnd(5))-2
		line(dots[i].x-dx,dots[i].y-dy,dots[i].x+dx,dots[i].y+dy,i%16)

		dots[i].y+=1
		if dots[i].y>=128 then
			dots[i].y = 0
		end
	end

	printo("❎ continue",44,120,7)
end
