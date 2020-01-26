pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- yucky yaml
-- by marc duiker

local _upd
local _drw
local _t
local _spd
local p={x=1,y=1,s=1}

function _init()
	_t=0
	_spd=3
	_drw=_draw_game
	_upd=_update_game
end

function _update()
 _t+=1
 anim_tiles()
 _upd()
end

function _draw()
 cls()
 map(0,0,0,0,16,16)
 _drw()
end

function _update_game()
	p.s=anim_item(wh_spr,wh_spd)
	local new_x=p.x
	local new_y=p.y
	local old_x=p.x
	local old_y=p.y
	if btnp(⬅️) then
		new_x-=1
	elseif btnp(➡️) then
		new_x+=1
	elseif btnp(⬆️) then
	 new_y-=1
	elseif btnp(⬇️) then
		new_y+=1
	end
	
	if can_move(new_x,new_y) then
		p.x=new_x
		p.y=new_y
	end
	
	if has_moved(p,old_x,old_y) then
		sfx(1,0,0)
	end
	
end

function has_moved(p,x,y)
	return not (p.x==x and p.y==y)
end

function _draw_game()
	spr(p.s,p.x*8,p.y*8,1,1)
end
-->8
-- map

function anim_tiles()
	
	for ax=0,15 do	
		for ay=0,15 do
			local tile=mget(ax,ay)
			local anim_flag=fget(tile,3)
			if anim_flag then
				local array={}
				if tile>=21 and tile<=23 then
					array=yf_spr
				elseif tile>=24 and tile<=26 then
					array=sk_spr
				end
				if #array>0 then
					local anim_spr=anim_item(array,tile_spd)
					mset(ax,ay,anim_spr)
				end
			end
		end
	end
end

function can_move(x,y)
	local map_tile=mget(x,y)
	local flag_0=fget(map_tile,0)
	if flag_0 then
		return false
	else
		return true
	end
end

function is_collectable(x,y)
	local tile=mget(x,y)
	local collect_flag=fget(tile,1)
	if collect_flag then
		return true
	else
		return false
	end
end

function remove_item(x,y)
	local tile=mget(x,y)
	mset(x,y,0)
end
-->8
-- sprites

wh_spr={1,2,3,4,2}
yf_spr={21,22,23,22}
sk_spr={26,25,24}
wh_spd=3
tile_spd=6
-->8
-- menu

function init_menu()
	menu={
		update=function(self)
			if btnp(❎) then
				_upd=update_player
				_drw=draw_player
			end
		end,
		
		draw=function()
			map(0,16,0,0,16,16)
			print("yucky yaml!",34,24,12)
			print("v0.1",56,48,5)
			print("press ❎/x to play",28,68,9)
			print("created by",44,92,7)
			print("marc duiker",42,100,7)
		end
	}
end

-->8
-- end_game
local mark_anim={12,14}
local anim_speed=8

function update_end_game()
			if btnp(❎) then
				extcmd("reset")
			end
end

function draw_end_game()
			camera()
			map(0,16,0,0,16,16)
			rect(0,14,127,56,6)
			spr(anim_player(mark_anim,anim_speed),0,18,2,3)
			local left_txt=18
			print("yeah! you made it!",left_txt,18,7)
			print("i'm mark russinovich, thank",left_txt,24,7)
			print("you so much for saving this",left_txt,30,7)
			print("datacenter with the help of",left_txt,36,7)
			print("azure functions. they are",left_txt,42,7)
			print("so powerful, right?!",left_txt,48,7)
			
			print("press ❎/x to restart",24,68,9)
			print("created by",44,84,7)
			print("marc duiker ",42,92,7)
			print("i",34,108,7)
			print("♥",42,108,8)
			print("serverless",52,108,7)
		end

-->8
-- texts
local x1=0
local y1=50
local x2=127
local y2=90
local xpadding=3

function show_level_1_start_text()
	draw_text_box()
	print("restore the energy of the data",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+54,7)
	print("center by collecting all items.",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+62, 7)
	print("finish on the green dot.",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+70,7)
end

function show_bumping_text()
	draw_text_box()
	print("hey! please stop humping the",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+54,7)
	print("servers! that's not the way to",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+62,7)
	print("turn them on...",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+70,7)
end

function show_game_over_text()
	draw_text_box()
	print(" --= game over =--",game_maps[level_id].pix_x+x1+xpadding+24,game_maps[level_id].pix_y+54,7)
	print("watch out for those bugs!",game_maps[level_id].pix_x+x1+xpadding+14,game_maps[level_id].pix_y+68,7)
end

function show_avocado_text()
	draw_text_box()
	print("wow, you really like avocados!",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+62,7)
end

function show_level_start_text()
	draw_text_box()
	print("--= level "..game_maps[level_id].level.." =--",game_maps[level_id].pix_x+x1+xpadding+30,game_maps[level_id].pix_y+62,7)
end

function show_level_end_text()
	draw_text_box()
	print("you've finished level "..game_maps[level_id].level.." in "..player.moves,game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+54,7)
	print("moves!",game_maps[level_id].pix_x+x1+xpadding,game_maps[level_id].pix_y+62,7)
end

function draw_text_box()
	rectfill(game_maps[level_id].pix_x+x1,game_maps[level_id].pix_y+y1,game_maps[level_id].pix_x+x2,game_maps[level_id].pix_y+y2,0)
	rect(game_maps[level_id].pix_x+x1,game_maps[level_id].pix_y+y1,game_maps[level_id].pix_x+x2,game_maps[level_id].pix_y+y2,7)
	print("press 🅾️/c to continue",game_maps[level_id].pix_x+x1+20,game_maps[level_id].pix_y+81,6) 
end
-->8
-- levels

local level_1={
	id=1,
	camera_x=16*8*0,
	camera_y=0,
	player_x=6,
	player_y=5,
	map_x=0,
	map_y=0,
	bug1_x=13,
	bug1_y=4,
	bug1_dir=0,
	bug2_x=2,
	bug2_y=7,
	bug2_dir=3,
	bug3_x=10,
	bug3_y=12,
	bug3_dir=1
}

local level_2={
	id=2,
	camera_x=16*8*1,
	camera_y=0,
	player_x=24,
	player_y=6,
	map_x=16,
	map_y=0,
	bug1_x=27,
	bug1_y=5,
	bug1_dir=0,
	bug2_x=23,
	bug2_y=9,
	bug2_dir=2,
	bug3_x=26,
	bug3_y=11,
	bug3_dir=1
}

local level_3={
	id=3,
	camera_x=16*8*2,
	camera_y=0,
	player_x=38,
	player_y=2,
	map_x=32,
	map_y=0,
	bug1_x=35,
	bug1_y=5,
	bug1_dir=0,
	bug2_x=45,
	bug2_y=7,
	bug2_dir=2,
	bug3_x=39,
	bug3_y=9,
	bug3_dir=1
}

local level_4={
	id=4,
	camera_x=16*8*3,
	camera_y=0,
	player_x=59,
	player_y=13,
	map_x=48,
	map_y=0,
	bug1_x=57,
	bug1_y=5,
	bug1_dir=3,
	bug2_x=52,
	bug2_y=7,
	bug2_dir=3,
	bug3_x=62,
	bug3_y=10,
	bug3_dir=2
}

local level_5={
	id=5,
	camera_x=16*8*4,
	camera_y=0,
	player_x=65,
	player_y=3,
	map_x=64,
	map_y=0,
	bug1_x=75,
	bug1_y=3,
	bug1_dir=0,
	bug2_x=71,
	bug2_y=10,
	bug2_dir=1,
	bug3_x=71,
	bug3_y=12,
	bug3_dir=0
}

local level_6={
	id=6,
	camera_x=16*8*5,
	camera_y=0,
	player_x=81,
	player_y=2,
	map_x=80,
	map_y=0,
	bug1_x=87,
	bug1_y=2,
	bug1_dir=0,
	bug2_x=90,
	bug2_y=08,
	bug2_dir=0,
	bug3_x=86,
	bug3_y=14,
	bug3_dir=1
}

local level_7={
	id=7,
	camera_x=16*8*6,
	camera_y=0,
	player_x=97,
	player_y=2,
	map_x=96,
	map_y=0,
	bug1_x=108,
	bug1_y=8,
	bug1_dir=2,
	bug2_x=109,
	bug2_y=08,
	bug2_dir=0,
	bug3_x=110,
	bug3_y=08,
	bug3_dir=2
}

function init_levels()
	levels={
		level_1,
		level_2,
		level_3,
		level_4,
		level_5,
		level_6,
		level_7
		}
end
-->8
-- shared

function anim_item(array,speed)
	local i=flr(_t/speed%#array)+1
	return array[i]
end


__gfx__
00000000000000000000000000000c0c000000000000000015555556155555541616161615555557000000001188881188873331111111111113311111111111
0700007000000c0c00000c0c000000c000000c0c0777cd006666666544444445414141417777777500000000189999818887333111c71111113bb31118818871
00700700000000c0000000c000000cc0000000c00cccccd06d555d654a999a4511111116765556750000000089aaaa98888733311ccc7111113bb31188888887
00077000ccccccc0ccccccc0ccccccc0ccccccc0cc70ccc065d5d56549a9a9454111114175656575000000009abbbba977777771c7cccc7113bbbb3188888887
00077000cc17ccc0cc17ccc0cc17ccc0cc17ccc0cc07ccc06556556549949945111411167557557500000000abccccbaccc79991cc7c7cc713b44b3188888887
00700700cc11ccc0cc11ccc0cc11ccd0cc11ccc0ccccccc065d5d56549a9a945411111417565657500000000bc2222cbccc79991ccccc7cc13b44b3118888871
07000070077cccd008ccccd0088ccc00088cccd0000000c06d555d654a999a45111111167655567500000000c211112cccc799911cccccc113bbbb3111888711
000000000077cd000777cd000777cd000777cd0000000c0c66666661444444414141414177777771000000002111111211111111111111111133331111187111
11111111000000000000000000000000000000001117771111177711111777111111111111111111111111110000000000000000000000000000000000000000
1111111100000000000000000000000000000000117c7c71117c7c71117c7c716661111166611111666111110000000000000000000000000000000000000000
11111111049a000003ba000008ef0000000000001177777111777771117777711666611116666111166661110000000000000000000000000000000000000000
11111111000000000000000000000000000000001171717111717171117171711166661111666611116666110000000000000000000000000000000000000000
11111111000000000000000000000000000000001171717111717171117171711166661111666611116666110000000000000000000000000000000000000000
1111111100000000000000000000000000000000117171711171717111717171166666611666666c166666610000000000000000000000000000000000000000
1111111100000000000000000000000000000000171717111711711711171717111111c111111111111111110000000000000000000000000000000000000000
1111111100000000000000000000000000000000111111111111111111111111cc11c1111cc11c1111cc11c10000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111177111117117111111111111111111111111111555555416161616155555581616161600000000
11711111111171111157775111111111111111111117711111711711111771111171171111111111111111114444444541414141888888858181818100000000
17671111111777111117771111111111111771111171171117111171171111711117711111711711111111114a999a45111111168feeef851111111600000000
111111111157775111117111111771111171171117111171111771111171171117111171111771111171171149a9a945411111418efefe858111118100000000
111111111111111111111111117117111711117111177111117117111117711111711711171111711117711149949945111411168ee8ee851118111600000000
111117111116161111166111171111711117711111711711111111111111111111177111117117111711117149a9a945411111418efefe858111118100000000
11117671111616111116161111177111117117111111111111111111111111111111111111177111117117114a999a45111111168feeef851111111600000000
11111111111166111116661111711711111111111111111111111111111111111111111111111111111771114444444141414141888888818181818100000000
11111111111151111115111111111111111111111111111111111111111111111111111111111111111111111555555316161616000000000000000000000000
11111111111771111117711111111711111171111117111111711111117111111117111111117111111117113333333531313131000000000000000000000000
11111111117771111117771111117117111711711171171117117111711711111711711111711711111711713abbba3511111116000000000000000000000000
11111111111771111117711111171171117117111711711171171111171171111171171111171171111171173babab3531111131000000000000000000000000
11111111111151111115111111171171117117111711711171171111171171111171171111171171111171173bb3bb3511131116000000000000000000000000
11111111111611111116611111117117111711711171171117117111711711111711711111711711111711713babab3531111131000000000000000000000000
11111111111611111116611111111711111171111117111111711111117111111117111111117111111117113abbba3511111116000000000000000000000000
11111111111661111116161111111111111111111111111111111111111111111111111111111111111111113333333131313131000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000000777777777777000000000000000000005555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000700000000007222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550000000000701111111107222222222333333333305555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550000000000700000000007222222222333333333305555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444777777777777666666666777777777705555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111111111111777777771111111111111111777777771111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550444444444455555555556666666666777777777705555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550444444444455555555556666666666777777777705555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111777777771111111111111111777777771111111111111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111777777771111111111111111777777771111111111111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555011111111777777771111111111111111777777771111111111111111111111110555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550111111117777777711111111111111117777777711111111111111111111111105555550000000000000000000000000000000000000000005555555
55555550111111117777777711111111111111117777777711111111111111111111111105555555555555555555555555555555555555555555555555555555
55555550111111117777777711111111111111117777777711111111111111111111111105555555555555555555555555555555555555555555555555555555
55555550111111117777777711111111111111117777777711111111111111111111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550000000555556667655555555555555555555555555555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550000000555555666555555555555555555555555555555555
5555555011111111111111117777777711111111111111117777777711111111111111110555555000000055555556dddddddddddddddddddddddd5555555555
555555501111111111111111777777771111111111111111777777771111111111111111055555500010005555555655555555555555555555555d5555555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550000000555555576666666d6666666d666666655555555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550000000555555555555555555555555555555555555555555
55555550111111111111111177777777111111111111111177777777111111111111111105555550000000555555555555555555555555555555555555555555
55555550111111111111111177777777111111111111111177777777111111111111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111111111111777777771111111111111111777777771111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111111111111777777771111111111111111777777771111111105555556665666555556667655555555555555555555555555555555
55555550111111111111111111111111777777771111111111111111777777771111111105555556555556555555666555555555555555555555555555555555
5555555011111111111111111111111177777777111111111111111177777777111111110555555555555555555556dddddddddddddddddddddddd5555555555
555555501111111111111111111111117777777711111111111111117777777711111111055555565555565555555655555555555555555555555d5555555555
55555550111111111111111111111111777777771111111111111111777777771111111105555556665666555555576666666d6666666d666666655555555555
55555550111111111111111111111111777777771111111111111111777777771111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111111111111777777771111111111111111777777771111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111111111111111111111111111111111111111111111111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111111111111111111111111111111111111111111111111111105555555555555555555555555555555555555555555555555555555
55555550111111111111111111111111111111111111111111111111111111111111111105555550005550005550005550005550005550005550005550005555
555555501111111111111111111111111111111111111111111111111111111111111111055555011d05011d05011d05011d05011d05011d05011d05011d0555
55555550111111111111111111111111111111111111111111111111111111111111111105555501110501110501110501110501110501110501110501110555
55555550111111111111111111111111111111111111111111111111111111111111111105555501110501110501110501110501110501110501110501110555
55555550111111111111111111111111111111111111111111111111111111111111111105555550005550005550005550005550005550005550005550005555
55555550111111111111111111111111111111111111111111111111111111111111111105555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555551111111155555555555555555555555555555555555555555555555555
55555555555555555555555557555555ddd5555d5d5d5d5555d5d55555555d555555551117117156666666666666555557777755555555555555555555555555
55555555555555555555555577755555ddd555555555555555d5d5d5555555d55555551171171156ddd6ddd6ddd6555577ddd775566666555666665556666655
55555555555555555555555777775555ddd5555d55555d5555d5d5d55555555d5555551711711156d6d6d66666d6555577d7d77566dd666566ddd66566ddd665
55555555555555555555557777755555ddd555555555555555ddddd555ddddddd555551711711156d6d6ddd6ddd6555577d7d775666d66656666d665666dd665
555555555555555555555757775555ddddddd55d55555d55d5ddddd55d5ddddd5555551171171156d6d666d6d666555577ddd775666d666566d666656666d665
555555555555555555555755755555d55555d555555555555dddddd55d55ddd55555551117117156ddd6ddd6ddd655557777777566ddd66566ddd66566ddd665
555555555555555555555777555555ddddddd55d5d5d5d55555ddd555d555d555555551111111156666666666666555577777775666666656666666566666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555566666665ddddddd5ddddddd5ddddddd5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000c0c000000001555555d15555554161616160000000000000000000000001188881188873331111111111113311111111111
0700007000000c0c00000c0c000000c000000c0c666666654444444541414141000000000000000000000000189999818887333111c71111113bb31118818871
00700700000000c0000000c000000cc0000000c06d555d654a999a451111111600000000000000000000000089aaaa98888733311ccc7111113bb31188888887
00077000ccccccc0ccccccc0ccccccc0ccccccc065d5d56549a9a945411111410000000000000000000000009abbbba977777771c7cccc7113bbbb3188888887
00077000cc17ccc0cc17ccc0cc17ccc0cc17ccc0655655654994994511141116000000000000000000000000abccccbaccc79991cc7c7cc713b44b3188888887
00700700cc11ccc0cc11ccc0cc11ccd0cc11ccc065d5d56549a9a94541111141000000000000000000000000bc2222cbccc79991ccccc7cc13b44b3118888871
07000070077cccd008ccccd0088ccc0008ccccd06d555d654a999a4511111116000000000000000000000000c211112cccc799911cccccc113bbbb3111888711
000000000077cd000777cd000777cd000777cd006666666144444441414141410000000000000000000000002111111211111111111111111133331111187111
111111111555555d0000000000000000000000001111111161111111000000000000000000000000000000000000000000000000000000000000000000000000
11111111666666650000000000000000000000001117771116611111000000000000000000000000000000000000000000000000000000000000000000000000
111111116d555d65000000000000000000000000117c7c7116661111000000000000000000000000000000000000000000000000000000000000000000000000
1111111165d5d5650000000000000000000000001777777116666111000000000000000000000000000000000000000000000000000000000000000000000000
11111111655655650000000000000000000000001717171116666111000000000000000000000000000000000000000000000000000000000000000000000000
1111111165d5d565000000000000000000000000171717111666661c000000000000000000000000000000000000000000000000000000000000000000000000
111111116d555d650000000000000000000000007171711111111111000000000000000000000000000000000000000000000000000000000000000000000000
111111116666666100000000000000000000000011111111ccc11cc1000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11711111111171111117771111177111171111710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17671111111777111117771111711711117117110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111777111111711117111171111771110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111177111171111710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111711111616111116611111711711117117110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11117671111616111116161117111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111166111116661111111107777771777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111107111117117000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111771111117711111171107111717717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111117771111117771111711707117117771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111771111117711117117107171117777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111117117107171117711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111611111116611111711707117111171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111611111116611111171107111711717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111661111116161111111107111111117000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000007777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000000000102040204020202020200030303011818181818180000000000000505000000000000000002040204000001010000000000000000020400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0606060606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0610101010101010101010101010100611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000
0610102010101010101010102010100611101010101010101010101010101011111010101010101010101010101010111110101010101010101010101010101111101111110711111111071111110411111010101010102610101010101004111110101010101010101010101010051100000000000000000000000000000000
0610101010061010101006101010100611041111111011101011101111110811111010101011101111101010101010111110040810101011111110051010101111101010101010101010102610101011111011101010111011111110111111101110111111111111111111111111101100000000000000000000000000000000
061020101006083c102e06101020100611101107101011101011101007111011111010041111101111101010081010111110101011101111111110111010101111111111111111111111101111111111111011111010111011061010101105111110110610101010101010101011101100000000000000000000000000000000
0610101010061010100606101010100611101110101011101011102610111011111010261111100711111010101010111110101011101111112610111010101111111010101010111111071010101011111011071107111011111010101110111110101010101111111107101010101100000000000000000000000000000000
0610101010101010101010101010100611101110100911101011051010111011111010071110101011111110101010111110101110101111091010101110101111101106101110111110111006111011111011101011111011101010101110111110101010111010101010101010101100000000000000000000000000000000
0610101510101010101010101810100611101111111111101011111111111011111010111110101010101111102610111110101126101111111111101110101111101011111010111110101111101011111011101010111011111110101110111110101011101011111111110710101100000000000000000000000000000000
0610101010100606060610101010100611101010101010101006101010101011111010111110101010101011110910111107110910101010141611101011071111101010101010101010101010101011110810101010101010102610101010111110101011041116141010102626261100000000000000000000000000000000
0610101010100710102d10101010100611101111111111261011111111111011111010111010062604101011111110111110101105101010111110101110101111101111111111111111111111111111111011111010111006111411101111111110081111111111111109101010101100000000000000000000000000000000
0610101010103b10101010101010100611101110100611101011101010111011111011111010101010101011161110111110101110101011111110101110261111101010101010261010101010100511111110101011101110111611101110101110101010111010101010101010101100000000000000000000000000000000
0610101010101010101010101010100611101110101011101011261610111011111011111010101010101014101110111110101011101011111010111010101111111111111111111111111110111411111110101011101110111111101111101110101010101111111111071010101100000000000000000000000000000000
0606060606060606060606060606060611101107101011101011101010111011111011071010101111111111111110111110101011101011111010111010101111081010101010261010101010111011111110101011101110111110101110101110111010101010101010100611101100000000000000000000000000000000
0000000000000000000000000000000011101111111011101011141111111011111011101011111111111111111110111110101006101011101010101010101111111110111111111111111111111011110511111010111010110711101111111110111111111111111111111111101100000000000000000000000000000000
0021213121323222000000000000000011101010101010101010101010100911110610101010101010100510101010111110101010101007101010101010101111051010101010101010101009111611111010101010261010101010101009111110101010101010101010101010051100000000000000000000000000000000
0000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000
3400340034003400340034003400340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3400340034003400340034003400340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000210402304026040220401f0401b000170001600015000140001460015600186001b6001f60021600276000d4000e40000000000000000000000000000000000000000000000000000000000000000000
000400002105023050270502d0503605021050230502505029050340502305026050290502f0503705025050270502a0502d050310503505039050280001e0001900020000190002000020000220001b80000000
00040000330502b05027050210501f050340502d050280502405023050350502f0502705024050210501d0501a05017050020001b0001f0001e0001e0001e0001900020000190002000020000220001b80000000
00040000100600c060080600406000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002a740297002a74027700357402d500367402c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001e05025000290502b000250501e0001d0501d0001f0502200025050280003305033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001c350000001934000000163300000012330000000e320000000b320000000631000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000201032000600103202c60000000103200000019600103200230014700176001032013320153200000012320000001232000000000001132000000000001032000000000000030013320103200e32000000
0110001021000290003200021000290003200020000200002000020000200002000020000200002000030000300030c2030d2030f203122031420317203192031c2031e2032020324203272032a2032e20331203
001000201c7311c7301c7301c7301c7301c7301c7301c7301c7301c7301c7301c730217312173021730217301e7311e7301e7301e7301e7301e7301e7301e7301c7311c7301c7301c7301a7311a7301a7301a730
__music__
03 48080a44
03 484a4344
03 414a4744

