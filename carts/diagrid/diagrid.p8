pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
-- start

function _init()
	init_game()
end

function init_game()
	init_map()
	add_player()
	dirx={-1,1,0,0}
	diry={0,0,-1,1}
	t=0
	start_time=nil
	elapsed_time=nil
	game_over=false
	target=4
	score=0
	btnbuffer=-1
	_upd=update_menu
	_drw=draw_menu
end

function _update()
	t+=1
	_upd()
end

function _draw()
	cls()
	draw_map()
	_drw()
end

-->8
--menu

function draw_menu()
	local title=""
	local instr1=""
	local instr2=""
	local instr3=""
	local instr4=""
	local instr5=""
	local instr6=""
	local start="- press ❎ to start -"
	local credits="made by marc duiker"
	rectfill(0,0,127,127,5)
	rect(2,2,125,125,7)
	spr(get_frame(menu_dino.anim_move,menu_dino.anim_speed),menu_dino.x*8,menu_dino.y*8)
	print(title,hcenter(title),30,11)
	print(instr1,hcenter(instr1),45,7)
	print(instr2)
	print(instr3)
	print("")
	print(instr4)
	print(instr5)
	print(instr6)
	print(start,hcenter(start)-2,95,11)
	print(credits,hcenter(credits),110,9)
end

function update_menu()
	menu_dino={
		x=7,
		y=1,
		anim_speed=10,
		anim_move={6,7}
	}
	
	if btnp(❎) then
		sfx(5)
		_upd=update_game
		_drw=draw_player
	end
end

function update_game_over()
	if btnp(❎) then
		run()
	end
end

function draw_game_over()
	local text1="congratulations!"
	local text2="you finished in "..flr(elapsed_time).." sec"
	local text3="press ❎ to play again"
	local x1=hcenter(text3)-8
	local x2=x1+#text3*4+14
	rectfill(x1,40,x2,84,0)
	rect(x1+2,42,x2-2,82,7)
	print(text1,hcenter(text1),50,7)
	print(text2,hcenter(text2),60,7)
	print(text3,hcenter(text3)-2,70,7)
end

function hcenter(s)
  return 64-#s*2
end
-->8
-- player

function add_player()
	p={}
	p.x=8
	p.dx=0
	p.sx=0
	p.y=7
	p.dy=0
	p.sy=0
	p.t=0
	p.sprite=1
	p.anim_speed=10
	p.anim_still={1}
	p.anim_move={2,3}
	p.isflipped=false
	p.seq=nil
	p.isstill=true
	p.sectionnr=1
	p.section=section1
	p.isgameover=false
	p.respawnx=p.x
	p.respawny=p.y
end

function draw_player()
	if p.isstill then
		spr(get_frame(p.anim_still,p.anim_speed),p.x*8+p.dx,p.y*8+p.dy,1,1,p.isflipped)
	elseif not p.isstill then
		spr(get_frame(p.anim_move,p.anim_speed),p.x*8+p.dx,p.y*8+p.dy,1,1,p.isflipped)
	end
end

function update_game()
	if btnbuffer==-1 then
		btnbuffer=getbtn()
	end
	dobtn(btnbuffer)
	btnbuffer=-1
end

function update_player(_dx,_dy)
	if (_dx<0) then
		p.isflipped=true
	elseif (_dx>0) then
		p.isflipped=false
	end
	
	if (_dx==0 and _dy==0) then
		p.isstill=true
	else
		p.isstill=false
	end
	
	local destx=p.x+_dx
	local desty=p.y+_dy
	if p.isstill==false then 
		if isobstacle(destx,desty) then
			p.sx=_dx*8
			p.sy=_dy*8
			p.dx=0
			p.dy=0
			p.seq=seq_obstacle
			sfx(1)
		elseif iscollectable(destx,desty) then
			p.section.score+=1
			if (p.section.score == 4) then
				sfx(3)
				p.respawnx=p.section.respawnx
				p.respawny=p.section.respawny
				if p.sectionnr < 4 then
					p.sectionnr+=1
					p.section=sections[p.sectionnr]
				else
					p.isgameover=true
				end
				p.section.isdooropen=true
			else
				sfx(2)
			end
			mset(destx,desty,63)
			p.x+=_dx
			p.y+=_dy
			p.sx=-_dx*8
			p.sy=-_dy*8
			p.dx=p.sx
			p.dy=p.sy
		elseif isportal(destx,desty) then
			sfx(4)
			p.x=p.respawnx
			p.y=p.respawny
		else
			-- nothing special
			sfx(0)
			p.x+=_dx
			p.y+=_dy
			p.sx=-_dx*8
			p.sy=-_dy*8
			p.dx=p.sx
			p.dy=p.sy
		end
		p.t=0
		
		if p.isstill then
			p.seq=seq_still
		else
			p.seq=seq_walk
		end
		_upd=update_player_move
	end
	
	check_score()
end

function check_score()
	if score==target then
		game_over=true
		_upd=update_game_over
		_drw=draw_game_over
	end
end

function update_player_move()
	if btnbuffer==-1 then
		btnbuffer=getbtn()
	end
	p.t=min(p.t+0.25,1)
	p.seq()
	if p.t==1 then
		_upd=update_game
	end
end

function getbtn()
	for i=0,5 do
		if btnp(i) then
			return i
		end
	end
	return -1
end

function dobtn(button)
	if button<0 then 
		update_player(0,0)
		return
	end
	if button>=0 and button<4 then
		update_player(dirx[button+1],diry[button+1])
		return
	end
	if button==5 then
		run()
	end
end

function seq_still()
end

function seq_walk()
	p.dx=p.sx*(1-p.t)
	p.dy=p.sy*(1-p.t)
end

function seq_obstacle()
	p.dx=p.sx*(1-p.t)
	p.dy=p.sy*(1-p.t)
end

function isobstacle(_x,_y)
	local tile=mget(_x,_y)
	return fget(tile,0)
end

function iscollectable(_x,_y)
	local tile=mget(_x,_y)
	return fget(tile,1)
end

function isportal(_x,_y)
	local tile=mget(_x,_y)
	return fget(tile,2)
end

-->8
-- map

function init_map()
	section1={
		id=1,
		isdooropen=true,
		doorx=10,
		doory=6,
		opendoorspr=33,
		hasplayed=false,
		respawnx=10,
		respawny=6,
		score=0,
		maxscore=4}
	section2={
		id=2,
		isdooropen=false,
		doorx=5,
		doory=9,
		opendoorspr=32,
		hasplayed=false,
		respawnx=5,
		respawny=9,
		score=0,
		maxscore=4}
	section3={
		id=3,
		isdooropen=false,
		doorx=10,
		doory=9,
		opendoorspr=34,
		hasplayed=false,
		respawnx=10,
		respawny=9,
		score=0,
		maxscore=4}
	section4={
		id=4,
		isdooropen=false,
		doorx=5,
		doory=6,
		opendoorspr=35,
		hasplayed=false,
		respawnx=5,
		respawny=6,
		score=0,
		maxscore=4}
	sections={section1,section2,section3,section4}
end

function draw_map()
	map(0,0)
	--print("score:"..p.section.score, 10, 0, 0)
	--print("nr:"..p.sectionnr, 10, 10, 0)
	--print("id:"..p.section.id, 10, 18, 0)
	--print("spr:"..p.section.opendoorspr, 10, 26, 0)
	if p.section.isdooropen then
		mset(p.section.doorx,p.section.doory,p.section.opendoorspr)
	end
end
-->8
--map


-->8
-- tools

function get_frame(_ani,_speed)
	return _ani[flr(t/_speed)%#_ani+1]
end
   
function rndint(_min, _max)
	return flr(_min+rnd(_max-_min))
end
__gfx__
000000000000444000000000000044400000444000004440000044400000000077777777777777777777777777777777777777777777777777777777aa7aa7aa
000000000004440000004440000444000004440000c7fc700004440000000000777777777777777777777777777777777777177777bbbb77777e277799799799
00700700000cfc00000444000004fc00000cfc0000cc8cc0000cfc000000000077c1117777b3337777a9997777e222777c7717177bbbbbb777eee27777777777
00077000000444000004fc0000004400000484000f04840f000484000000000077c1117777b3337777a9997777e22277c777177173bbbb377eeeee2777777777
000770000094449000004400000994000094449000944490009444900000000077c1117777b3337777a9997777e22277c77c7771733333377eeeee27aaaaaa97
0070070000f999f000009400000f100000f999f0000999000f09990f0000000077c1117777b3337777a9997777e222777c7c7717733333377eeeee27aaaaa999
000000000001010000019f000001010000010100000101000001010000000000c1111111b3333333a9999999e2222222777c77777333333777eee277aaaaa999
0000000000050500005000500005050000050500000505000005050000000000777777767777777677777776777777767777777677333376777e2776aaaaaa96
ccccccccbbbbbbbbaaaaaaaaeeeeeeeeccccccccbbbbbbbbaaaaaaaaeeeeeeee7773377777777777777777770000000000000000000000000000000000000000
1555555c3555555b9555555a2555555e1111111c3333333b9999999a2222222e773bb3777773b777778888770000000000000000000000000000000000000000
1555555c3555555b9555555a2555555e1ccccc1c3bbbbb3b9aaaaa9a2eeeee2e773bb377777b7777789999870000000000000000000000000000000000000000
155c555c355b555b955a555a255e555e1c111c1c3b333b3b9a999a9a2e222e2e73bbbb37777b777789bbbb980000000000000000000000000000000000000000
15ccc55c35bbb55b95aaa55a25eee55e1ccccc1c3bbbbb3b9aaaaa9a2eeeee2e73b44b3777b777779bccccb90000000000000000000000000000000000000000
1ccccc5c3bbbbb5b9aaaaa5a2eeeee5e1111111c3333333b9999999a2222222e73b44b37777b7777bc2222cb0000000000000000000000000000000000000000
155c555c355b555b955a555a255e555e11111c1c3b33333b9a99999a22222e2e73bbbb37777b7777c277772c0000000000000000000000000000000000000000
155c5556355b5556955a5556255e555611111116333333369999999622222226773333767773b776277777760000000000000000000000000000000000000000
ccccccccbbbbbbbbaaaaaaaaeeeeeeee000000000000000000000000000000007777777750755750777777777776777700000000000000000000000000000000
1777777c3777777b9777777a2777777e000000000000000000000000000000007888333750700705777ccc777776777700000000000000000000000000000000
1777777c3777777b9777777a2777777e00000000000000000000000000000000788833377777777777c666877cc7cc7700000000000000000000000000000000
1777777c3777777b9777777a2777777e0000000000000000000000000000000078883337777779997c6777686676766700000000000000000000000000000000
1777777c3777777b9777777a2777777e000000000000000000000000000000007ccc99979777779979677768c76667c700000000000000000000000000000000
1777777c3777777b9777777a2777777e000000000000000000000000000000007ccc999779999979779666876676766700000000000000000000000000000000
1777777c3777777b9777777a2777777e000000000000000000000000000000007ccc999777999777777998777c676c7700000000000000000000000000000000
1777777637777776977777762777777600000000000000000000000000000000777777767777777677777776776c677600000000000000000000000000000000
ccccccccbbbbbbbbaaaaaaaaeeeeeeee000000000000000000000000000000007777777777777777777777777777777700000000000000000000000077777777
1111111c3333333b9999999a2222222e000000000000000000000000000000007cc1cc177bb3bb377aa9aa977ee2ee2700000000000000000000000077777777
1c1c1c1c3b3b3b3b9a9a9a9a2e2e2e2e00000000000000000000000000000000ccccccc1bbbbbbb3aaaaaaa9eeeeeee200000000000000000000000077777777
1c1c1c1c3b3b3b3b9a9a9a9a2e2e2e2e00000000000000000000000000000000ccccccc1bbbbbbb3aaaaaaa9eeeeeee200000000000000000000000077777777
1c1c1c1c3b3b3b3b9a9a9a9a2e2e2e2e00000000000000000000000000000000ccccccc1bbbbbbb3aaaaaaa9eeeeeee200000000000000000000000077777777
1c1c1c1c3b3b3b3b9a9a9a9a2e2e2e2e000000000000000000000000000000007ccccc177bbbbb377aaaaa977eeeee2700000000000000000000000077777777
1c1c1c1c3b3b3b3b9a9a9a9a2e2e2e2e0000000000000000000000000000000077ccc17777bbb37777aaa97777eee27700000000000000000000000077777777
1111111c3333333b9999999a2222222e00000000000000000000000000000000777c1776777b3776777a9776777e277600000000000000000000000077777776
66666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000000000000000006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66077777777777777777706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66070000000000000000706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66077777777777777777706600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000000000000000000006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000020202020202020204040404010101010202020000000000000000000000000002020202000000000101010100000000020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3333333333333333313131313131313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
330f3f3f3f3f0d31330c3f3f3f3f193100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333f333333333f33313f313131313f3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333f33133f333f31333f313f11313f3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333f333f3f1a3f33313f0e3f3f313f3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333f3333333333313331313131313f3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33383f3f3f173f3f3f3f213f3f3f183100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3033303330333f3f3f3f31323132313200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3330333033303f3f3f3f32313231323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30083f3f3f143f3f3f3f163f3f3f2b3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303f3030303030323032323232323f3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303f303f3f0b3f30323f283f3f323f3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303f30103f303f32303f323f12323f3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303f303030303f30323f323232323f3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30093f3f3f3f0a3230293f3f3f3f2a3200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030323232323232323200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
090800001c0141f015150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0800001f0231c025000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0800001c0201f020230202602000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d080000280202b0202f0203202000000320200000032020000003402000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25090000280202b0202f020320202f0502b0502805032000000003000000000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
