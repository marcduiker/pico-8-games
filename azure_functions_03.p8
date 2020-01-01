pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- azure functions, the game
-- by marc duiker

local player
local menu
local game_map
local end_game
local states={
	menu=0,
	game=1,
	end_game=2
}
local game={
 state=states.menu
}


function _init()
	music(0,1)
	init_menu()
	init_player()
	init_map()
	init_end_game()
end

function _update()
 if game.state==states.menu then
 	menu:update()
 elseif game.state==states.game then
 	game_map:update()
 	player:update()
 elseif game.state==states.end_game then
 	end_game:update()
 end
end

function _draw()
 cls()
 if game.state==states.menu then
		menu:draw()
	elseif game.state==states.game then
 	game_map:draw()
	 player:draw()
 elseif game.state==states.end_game then
 	end_game:draw()
 end
end
-->8
-- map

local map_tiles={
	avocado=7,
	floor=16,
	server_off=17,
	server_red=18,
	server_green=33,
	end_tile=24,
	open_door=36,
}

local map_tile_types={
	wall=0,
	collectable=1,
	anim_state_1=2,
 anim_state_2=3,
 end_tile=4
}

function init_map()
	game_map={
		x=0,
		y=0,
		target_energy=100,
		total_servers=77,
		timer=0,
		anim_time=30,
		update=function(self)
			if self.timer<0 then
				animate_tiles()
				self.timer=self.anim_time
			end
			self.timer-=1
		end,
		
		draw=function(self)
			map(0,0,0,0,16,16)
		end
	}
end

function animate_tiles()
	for x=game_map.x,game_map.x+15 do
		for y=game_map.y,game_map.y+15 do
			if is_anim_state_1(x,y) then
				swap_tiles(x,y)
			elseif is_anim_state_2(x,y) then
			 unswap_tiles(x,y)
			end
		end
	end  
end

function update_servers(energy)
	local green_server_count=0
	local servers_to_make_green=ceil(game_map.total_servers/game_map.target_energy*energy)
	for y=game_map.y,game_map.y+15 do
		for x=game_map.x,game_map.x+15 do
			-- first count current green
			if mget(x,y)==map_tiles.server_green then
				green_server_count+=1
			end
			-- then update non-green servers
			if (green_server_count<servers_to_make_green) then
				if(is_to_be_made_green(x,y)) then
					mset(x,y,map_tiles.server_green)
					green_server_count+=1
				end
			end
			
		end
	end
end

function is_wall(x,y)
	local tile=mget(x,y)
	return fget(tile,map_tile_types.wall)
end

function is_collectable(x,y)
	local tile=mget(x,y)
	return fget(tile,map_tile_types.collectable)
end

function is_anim_state_1(x,y)
	local tile=mget(x,y)
	return fget(tile,map_tile_types.anim_state_1)
end

function is_anim_state_2(x,y)
	local tile=mget(x,y)
	return fget(tile,map_tile_types.anim_state_2)
end

function is_end_tile(x,y)
	local tile=mget(x,y)
	return fget(tile,map_tile_types.end_tile)
end

function is_avocado(x,y)
	return mget(x,y)==map_tiles.avocado
end

function is_to_be_made_green(x,y)
	return is_anim_state_1(x,y) or is_anim_state_2(x,y)
end

function swap_tiles(x,y)
	local tile=mget(x,y)
	mset(x,y,tile+1)
end

function unswap_tiles(x,y)
	local tile=mget(x,y)
	mset(x,y,tile-1)
end

function remove_item(x,y)
	mset(x,y,map_tiles.floor)
end

function can_move(x,y)
	return not is_wall(x,y)
end

function open_door()
	mset(8,6,map_tiles.open_door)
	mset(8,8,map_tiles.end_tile)
	sfx(sounds.door_open,1,0)
end
-->8
-- player
local sprites={
	normal=1,
	special=2
}

sounds={
	move=0,
	special_on=1,
	special_off=2,
	bump=3,
	pickup=4,
	door_open=5
}

local picked_up={}

function init_player()
	local step = 1
	local score_incr=10
	player = {
 	x=8,
		y=5,
	 normal=true,
	 score=0,
	 moves=0,
	 false_moves=0,
	 avocado_toggle=false,
	 initial_message=true,
	 false_move_toggle=false,
	 dialog_state=true,
	  
		update = function(self)
	 	local new_x=self.x
	 	local new_y=self.y
	 	local old_x=self.x
	 	local old_y=self.y
	 		 	
	 	if (btnp(⬅️) and not self.dialog_state) then 
	 		new_x-=step
	 		self.moves+=1 
	 	end
	 	if (btnp(➡️) and not self.dialog_state) then 
	 		new_x+=step
	 		self.moves+=1 
	 	end
	 	if (btnp(⬆️) and not self.dialog_state) then 
	 		new_y-=step
	 		self.moves+=1 
	 	end
	 	if (btnp(⬇️) and not self.dialog_state) then 
	 		new_y+=step
	 		self.moves+=1 
	 	end
		 
		 if can_move(new_x, new_y) then
		 	self.x=new_x
		 	self.y=new_y
		 	if old_x!=self.x or old_y!=self.y then
		 		self:play_move_sound()
		 		self.false_moves=0
		 	end
		 else
		 	self:play_bump_sound()
		 	self.false_moves+=1
		 	if (self.false_moves > 10) then
					self.false_move_toggle=true
					self.dailog_state=true
				end
		 end
		 
		 if is_collectable(self.x, self.y) then
		 	add(picked_up,mget(self.x, self.y))
		 	remove_item(self.x, self.y)
		 	self:play_pickup_sound()
		 	self.score+=score_incr
		 	update_servers(self.score)
		 	if (self.score==game_map.target_energy) then
		 		open_door()
		 	end
		 	if (is_avocado_fan()) then
			  self.avocado_toggle=true
				 self.dialog_state=true
		 	end
		 end
		 
		 if (is_end_tile(self.x,self.y)) then
		 	game.state=states.end_game
		 end
		 
		 if (btnp(🅾️)) then
		 	if (self.avocado_toggle) then
		 		self.avocado_toggle=false
		 		self.dialog_state=false
		 	end
		 	if (self.initial_message) then
		 		self.initial_message=false
		 		self.dialog_state=false
		 	end
		 	if (self.false_move_toggle) then
		 		self.false_move_toggle=false
		 		self.false_moves=0
		 		self.dialog_state=false
		 	end
		 end
		 
		 if (btnp(❎)) then 
		 	if (not self.normal) then
		 		self.normal = true
		 	else
		 		self.normal = false 
		 	end
		 	self:play_special_sound()
			end
		end,
	 
		draw=function(self)
		 --sprite
		 local spr_id
		 if (self.normal) then
				spr_id=sprites.normal
			else
				spr_id=sprites.special
			end
			spr(spr_id,self.x*8,self.y*8)
			
			if (self.initial_message) then
				show_start_text()
			end
			
			if (self.avocado_toggle) then
				show_avocado_text()
			end
			
			if (self.false_move_toggle) then
				show_bumping_text()
			end
			--score
			print("energy "..self.score.."%",0,0,12)
 		--moves
 		print("moves "..self.moves,90,0,12)
		end,
		
		play_move_sound = function(self)
				sfx(sounds.move,0,0)
		end,
		
		play_bump_sound = function(self)
				sfx(sounds.bump,0,0)
		end,
		
		play_pickup_sound = function(self)
				sfx(sounds.pickup,0,0)
		end,
		
		play_special_sound = function(self)
			local sfx_id
			if (self.normal) then
				sfx_id = sounds.special_off
			else
				sfx_id = sounds.special_on
			end
				sfx(sfx_id,0,0)
		end,
	}
end

function is_avocado_fan()
	if (#picked_up>=3) then
	 local item1=picked_up[#picked_up]
  local item2=picked_up[#picked_up-1]
	 local item3=picked_up[#picked_up-2]	 
	 return (item1 == item2) and (item2 == item3) and (item1==7)
	else
	 return false
	end
end
-->8
-- menu

function init_menu()
	menu={
		update=function(self)
			if btnp(❎) then
				game.state=states.game
			end
		end,
		
		draw=function(self)
			map(16,0,0,0,16,16)
			print("azure functions",34,24,12)
			print("the game",48,36,10)
			print("v0.3",56,48,5)
			print("press ❎ to play",32,64,9)
			print("created by",44,92,7)
			print("marc duiker",42,100,7)
		end
	}
end

-->8
-- end_game

function init_end_game()
	end_game={
		update=function(self)
			if btnp(❎) then
				game.state=states.menu
				extcmd("reset")
			end
		end,
		
		draw=function(self)
			map(16,0,0,0,16,16)
			print("congratulations!",34,24,12)
			print("you've saved the data center!",10,36,10)
			print("you used "..player.moves.." moves",32,60,7)
			print("press ❎ to restart",28,96,9)
		end
	}
end

-->8
-- texts
local x1=0
local y1=50
local x2=127
local y2=90
local xpadding=3

function show_start_text()
	draw_text_box()
	print("restore the energy of the data",x1+xpadding,54,7)
	print("center by collecting all items.",x1+xpadding,62, 7)
	print("finish on the green dot.",x1+xpadding,70,7)
end

function show_bumping_text()
	draw_text_box()
	print("hey! please stop humping the",x1+xpadding,54,7)
	print("servers! that's not the way to",x1+xpadding,62,7)
	print("turn them on...",x1+xpadding,70,7)
end

function show_avocado_text()
	draw_text_box()
	print("wow, you really like avocados!",x1+xpadding,62,7)
end

function draw_text_box()
	rectfill(x1,y1,x2,y2,0)
	rect(x1,y1,x2,y2,7)
	print("press 🅾️ to continue",x1+24,81,6) 
end


__gfx__
000000000009a000a00a700a00000000666666666688886666666666666336666666666668868876000000000000000000000000000000000000000000000000
070000700019a1000a1a71a000000000888733366899998666c76666663bb3666116611688888887000000000000000000000000000000000000000000000000
007007000109a010010a7010000000008887333689aaaa986ccc7666663bb3666166661688888887000000000000000000000000000000000000000000000000
0007700010009a011000a70100000000888733369abbbba9c7cccc7663bbbb36616cc61688888887000000000000000000000000000000000000000000000000
00077000c0009a0cc000a70c0000000077777776abccccbacc7c7cc763b44b361666666188888887000000000000000000000000000000000000000000000000
007007000c09a0c00c0a70c000000000ccc79996bc2222cbccccc7cc63b44b36616cc61668888876000000000000000000000000000000000000000000000000
0700007000c90c000aca0ca000000000ccc79996c266662c6cccccc663bbbb366166661666888766000000000000000000000000000000000000000000000000
0000000000090000a00a000a00000000ccc799962666666266666666663333666116611666687666000000000000000000000000000000000000000000000000
66666666255555552555555500000000888888880000000063333336633333366333333600000000000000000000000000000000000000000000000000000000
6666666625112125251181250000000085555558000000003333333333333333333bb33300000000000000000000000000000000000000000000000000000000
6666666625555555255555550000000085cccc5800000000333333333333333333bbbb3300000000000000000000000000000000000000000000000000000000
6666666625112125251181250000000085cccc580000000033333333333333333bbbbbb300000000000000000000000000000000000000000000000000000000
66666666255555552555555500000000855555580000000033333333333333333bbbbbb300000000000000000000000000000000000000000000000000000000
666666662511212525118125000000008555565800000000333333333333333333bbbb3300000000000000000000000000000000000000000000000000000000
6666666625555555255555550000000085555558000000003333333333333333333bb33300000000000000000000000000000000000000000000000000000000
66666666256666252566662500000000855555580000000063333336633333366333333600000000000000000000000000000000000000000000000000000000
00000000255555550000000000000000333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000025b311250000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000255555550000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000253b11250000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000255555550000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000025b311250000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000255555550000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000256666250000000000000000366666630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
ccc0cc00ccc0ccc00cc0c0c00000ccc0ccc0c0c000000000000000000000000000000000000000000000000000ccc00cc0c0c0ccc00cc00000ccc0ccc0000000
c000c0c0c000c0c0c000c0c00000c000c0c000c000000000000000000000000000000000000000000000000000ccc0c0c0c0c0c000c000000000c000c0000000
cc00c0c0cc00cc00c000ccc00000ccc0c0c00c0000000000000000000000000000000000000000000000000000c0c0c0c0c0c0cc00ccc000000cc000c0000000
c000c0c0c000c0c0c0c000c0000000c0c0c0c00000000000000000000000000000000000000000000000000000c0c0c0c0ccc0c00000c0000000c000c0000000
ccc0c0c0ccc0c0c0ccc0ccc00000ccc0ccc0c0c000000000000000000000000000000000000000000000000000c0c0cc000c00ccc0cc000000ccc000c0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666625555555255555558888888825555555255555556666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666625b1112525b111258555555825118125251181256666666666666666666666666666666625118125
255555556666666666666666666666666666666666666666255555552555555585cccc5825555555255555556666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666625b1112525b1112585cccc5825118125251181256666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666625555555255555558555555825555555255555556666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666625b1112525b111258555565825118125251181256666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666625555555255555558555555825555555255555556666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666625666625256666258555555825666625256666256666666666666666666666666666666625666625
2555555566666666666666666669a666666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25b1112566666666666666666619a166666666666666666625b11125666666666666666666666666251181256666666666666666666666666666666625118125
2555555566666666666666666169a616666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25b11125666666666666666616669a61666666666666666625b11125666666666666666666666666251181256666666666666666666666666666666625118125
255555556666666666666666c6669a6c666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25b1112566666666666666666c69a6c6666666666666666625b11125666666666666666666666666251181256666666666666666666666666666666625118125
25555555666666666666666666c96c66666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25666625666666666666666666696666666666666666666625666625666666666666666666666666256666256666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666625555555666666666333333666666666255555556666666668868876666666666666666625555555
25b11125666666666666666666666666666666666666666625b11125666666663333333366666666251181256666666688888887666666666666666625118125
25555555666666666666666666666666666666666666666625555555666666663333333366666666255555556666666688888887666666666666666625555555
25b11125666666666666666666666666666666666666666625b11125666666663333333366666666251181256666666688888887666666666666666625118125
25555555666666666666666666666666666666666666666625555555666666663333333366666666255555556666666688888887666666666666666625555555
25b11125666666666666666666666666666666666666666625b11125666666663333333366666666251181256666666668888876666666666666666625118125
25555555666666666666666666666666666666666666666625555555666666663333333366666666255555556666666666888766666666666666666625555555
25666625666666666666666666666666666666666666666625666625666666666333333666666666256666256666666666687666666666666666666625666625
25555555666666666666666666666666666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25b1112566c766666666666666666666666666666666666625b11125666666666666666666666666251181256666666666666666666666666666666625118125
255555556ccc76666666666666666666666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25b11125c7cccc766666666666666666666666666666666625b11125666666666666666666666666251181256666666666666666666666666666666625118125
25555555cc7c7cc76666666666666666666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25b11125ccccc7cc6666666666666666666666666666666625b11125666666666666666666666666251181256666666666666666666666666666666625118125
255555556cccccc66666666666666666666666666666666625555555666666666666666666666666255555556666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666625666625666666666666666666666666256666256666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666625555555255555552555555525555555255555556666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666625b1112525b1112525b1112525118125251181256666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666625555555255555552555555525555555255555556666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666625b1112525b1112525b1112525118125251181256666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666625555555255555552555555525555555255555556666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666625b1112525b1112525b1112525118125251181256666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666625555555255555552555555525555555255555556666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666625666625256666252566662525666625256666256666666666666666666666666666666625666625
25555555666666666666666666666666666666666688886666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666899998666666666666666666666666666666666666666666666666666666666666666666666666625118125
255555556666666666666666666666666666666689aaaa9866666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666669abbbba966666666666666666666666666666666666666666666666666666666666666666666666625118125
2555555566666666666666666666666666666666abccccba66666666666666666666666666666666666666666666666666666666666666666666666625555555
25b1112566666666666666666666666666666666bc2222cb66666666666666666666666666666666666666666666666666666666666666666666666625118125
2555555566666666666666666666666666666666c266662c66666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666662666666266666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666688873336666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666688873336666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666688873336666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666677777776666666666666666625555555
25b111256666666666666666666666666666666666666666666666666666666666666666666666666666666666666666ccc79996666666666666666625118125
255555556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666ccc79996666666666666666625555555
256666256666666666666666666666666666666666666666666666666666666666666666666666666666666666666666ccc79996666666666666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666666666666666633666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b111256666666666666666663bb366666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
255555556666666666666666663bb366666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666663bbbb36666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666663b44b36666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b11125666666666666666663b44b36666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625118125
25555555666666666666666663bbbb36666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666333366666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525b1112525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625

__gff__
0001000002020202020200000000000000050900010010141800000000000000000100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000001000100010001000100010001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101010101010101010051100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101010101008100710101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101006101010101010101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110041010101010101010101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101111141111101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101110101011101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101110161011100910101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1106101010101110101011101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101111111111101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010051010101010101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101010101010100710101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110101010101010101010101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110100710101010101010101010101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111101000100010001000100010001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000131300001313130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000210402304026040220401f0401b000170001600015000140001460015600186001b6001f60021600276000d4000e40000000000000000000000000000000000000000000000000000000000000000000
000400002105023050270502d0503605021050230502505029050340502305026050290502f0503705025050270502a0502d050310503505039050280001e0001900020000190002000020000220001b80000000
00040000330502b05027050210501f050340502d050280502405023050350502f0502705024050210501d0501a05017050020001b0001f0001e0001e0001e0001900020000190002000020000220001b80000000
00040000100600c060080600406000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002a740297002a74027700357402d500367402c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001e05025000290502b000250501e0001d0501d0001f0502200025050280003305033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000201032000600103202c60000000103200000019600103200230014700176001032013320153200000012320000001232000000000001132000000000001032000000000000030013320103200e32000000
0110001021000290003200021000290003200020000200002000020000200002000020000200002000030000300030c2030d2030f203122031420317203192031c2031e2032020324203272032a2032e20331203
001000201c7311c7301c7301c7301c7301c7301c7301c7301c7301c7301c7301c730217312173021730217301e7311e7301e7301e7301e7301e7301e7301e7301c7311c7301c7301c7301a7311a7301a7301a730
__music__
03 48080a44
03 484a4344
03 414a4744
