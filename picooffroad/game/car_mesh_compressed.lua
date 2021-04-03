car_min,car_vscale=-2.1209,0.0215
car_verticesc=[[^}○^●xe☉xp◆○g◆xe∧x^く○^▥x:∧x/◆○7◆x:☉xk🐱x^}xp◆xkうx^くx4うx/◆x4🐱xンqへ◝…も(vも$●ほンq웃◝…⬇️(v⬇️$✽☉w★⬇️znふzn웃w★もやq⬇️や★もや★⬇️やqもや?ひ⌂_ぬ⌂_🅾️や?⌂◝q⬇️◝qもる}웃ン}웃ン}へる}へ ✽🅾️ x🅾️ xね ✽ねwq⬇️wqも♪?⌂♪?ひ(★⬇️(★も ✽➡️ |➡️ |と ✽と ★🅾️ ★ね^}ら^●んp◆らe☉んg◆ん^くらe∧ん^▥ん/◆ら:∧ん7◆ん:☉んk🐱ん^}んp◆んkうん^くん4うん/◆ん4🐱んコ}らコ●んフ◆らチ☉んト◆んコくらチ∧んコ▥んれ◆らウ∧んア◆んウ☉んヌ🐱んコ}んフ◆んヌうんコくんっうんれ◆んっ🐱んコ}○コ●xチ☉xフ◆○ト◆xチ∧xコく○コ▥xウ∧xれ◆○ア◆xウ☉xヌ🐱xコ}xフ◆xヌうxコくxっうxれ◆xっ🐱xゆeへゆ^へゆe☉ゆ^☉りiにわdにりi◆わd◆チv☉シ{◆チvにチvへシ{にチv◆テ★もテ★⬇️^★⬇️^★もスrへスrにエsへエrにシq◆シq☉ウr☉イq◆]]
car_trianglesc=[[o6p+dra+8fe+4`f+:m6+>p=+bqc+=rb+>qo+a`@+a@d+@8e+o:6+dqr+84f+:lm+>op+brq+=pr+>cq+ ,- #,  #/. &/# &10 )1& )32  3) !," ,$" $/% /'% '1( 1*( *3+ 3!+ =c> `rp @qd hji wux {♥} }♥웃 }⌂█ █⌂⬅️ █😐⬇️ ⬇️😐♪ ⬇️🅾️{ {🅾️☉ ~☉| ○♥~ ○⌂웃 🐱⌂▒ 🐱😐⬅️ ✽😐░ ✽🅾️♪ |🅾️● ◆い➡️ ➡️いえ ➡️お⬆️ ⬆️おか ⬆️き❎ ❎きく ❎け◆ ◆けう ★う… ⧗い★ ⧗おえ ∧おˇ ∧きか ▥き▤ あく▥ …けあ こにぬ すにこ すのね たのす たひは てひた てへふ こへて さにし にせし せのそ のちそ ちひつ つふと ふなと へさな #., &0/ )21  -3 !-, ,.$ $./ /0' '01 12* *23 3-! =bc `ar @oq hgj wvu {☉♥ }웃⌂ █⬅️😐 ⬇️♪🅾️ ~♥☉ ○웃♥ ○▒⌂ 🐱⬅️⌂ 🐱░😐 ✽♪😐 ✽●🅾️ |☉🅾️ ◆うい ➡️えお ⬆️かき ❎くけ ★いう ⧗えい ⧗ˇお ∧かお ∧▤き ▥くき あけく …うけ すねに たはの てふひ こぬへ さぬに にねせ せねの のはち ちはひ つひふ ふへな へぬさ 7mn';l:'ゆウむ'ゆまも'もゃゅ'ゅるり'ウろよ'76m';kl'ゆイウ'ゆむま'もまゃ'ゅゃる'ウイろ'をe9#っ6t#e59#^p?#んo<#`g@#わ`^#o_<#8i4#8gh#;:s#67t#7zt#;yk#vlk#xzn#wlv#uzx#4j`#5fわ#@を_#s:ん#?pっ#6っp#ん:o#ef5#^`p#`jg#わf`#o@_#8hi#8@g#7nz#;sy#yuk#uvk#mwn#wxn#wml#uyz#4ij#@eを#$'*&🐱▒○&∧ˇ⧗&せちと&ゆめや&もアめ&むエみ&ゆオイ&まょゃ&ゅれア&イらろ&!"$&$%'&'(*&*+!&!$*&○~|&|●○&●✽○&✽░○&░🐱○&⧗★▥&★…▥&…あ▥&▥▤⧗&▤∧⧗&さしせ&せそち&ちつと&となさ&させと&ゆもめ&もゅア&むウエ&ゆやオ&まほょ&ゅりれ&イオら&]]

function car_mesh_init()
	car_vertices={}
	for i=1,#car_verticesc,3 do
		add(car_vertices,{x=car_min+car_vscale*decode_v(car_verticesc,i),y=car_min+car_vscale*decode_v(car_verticesc,i+1),z=car_min+car_vscale*decode_v(car_verticesc,i+2)})
	end
	
	car_triangles={}
	for i=1,#car_trianglesc do
		add(car_triangles,decode_v(car_trianglesc,i)+1)
	end
end

function decode_v(arr,i)
	local v=ord(arr,i)-32
	if v>=62 then
		v-=29
	end
	return v
end