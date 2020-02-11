pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- f5
-- by marc duiker

local p_spr={1,2,3,2}
local cake_spr={20,21,22}
local _t
local anim_speed=6
local circle_speed=2
local p={x=1,y=1,s=1}
local items={}
local colors={8,9,10,11,12,13,14,15}
local max_item_count=10
local item_count
local _drw
local _upd
local needs_circle_draw

function _init()
	_t=0
	_drw=_draw_game
	_upd=_update_game
	item_count=0
	needs_circle_draw=false
end

function _update()
	_t+=1
	anim_tiles()
	_upd()
end

function _update_game()
	p.s=anim_item(p_spr,anim_speed)
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
	
	if is_collectable(p.x,p.y) then
		item_count+=1
		needs_circle_draw=true
		remove_item(p.x,p.y)
		sfx(4,1,0)
	end
	
	if item_count==10 then
		sfx(3,1,0)
		_drw=_draw_finish
		_upd=_update_finish
	end
	
end

function _update_finish()
	if btnp(❎) then
		extcmd("reset")
	end
end

function anim_item(array,speed)
	local i=flr(_t/speed%#array)+1
	return array[i]
end

function _draw()
	cls()
	map(0,0,0,0,16,16)
	_drw()
end

function _draw_game()
	spr(p.s,p.x*8,p.y*8,1,1)
	if needs_circle_draw then
		draw_circles(p.x,p.y)
	end
end

function _draw_finish()
	print("!! happy birthday !!",24,22,anim_item(colors,anim_speed))
	print("press ❎/x to restart",22,102,7)
end
-->8
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
	item={x=x,y=y,s=tile}
	add(items,item)
	mset(x,y,0)

end

function anim_tiles()
	local new_cake_spr=anim_item(cake_spr,anim_speed)
	for ax=0,15 do	
		for ay=0,15 do
			local tile=mget(ax,ay)
			cake_flag=fget(tile,2)
			if cake_flag then
				mset(ax,ay,new_cake_spr)
			end
		end
	end

end

function has_moved(p,x,y)
	return not (p.x==x and p.y==y)
end
-->8
local circ_sizes={2,4,6,8,10,12}

function draw_circles(x,y)
	local size=anim_item(circ_sizes,circle_speed)
	local clr=anim_item(colors,circle_speed)
	circ(x*8+3,y*8+3,size,clr)
	circ(x*8+3,y*8+3,size/2,clr)
	if size==12 then
		needs_circle_draw=false
	end  
end
__gfx__
0000000000000000000000000000000000088000000cc000000bb00000099000000aa00000088000000000000000000000000000000000000000000000000000
07000070000aaa00000aaa00000aaa000087880000c7cc0000b7bb000097990000a7aa0000878800000000000000000000000000000000000000000000000000
0070070000acfca000acfca000acfca00088880000cccc0000bbbb000099990000aaaa0000888800000000000000000000000000000000000000000000000000
00077000000f8f0f000f8f000f0f8f000088880000cccc0000bbbb000099990000aaaa0000888800000000000000000000000000000000000000000000000000
00077000007777700f77777f0077777000088000000cc000000bb00000099000000aa00000088000000000000000000000000000000000000000000000000000
007007000f077700000777000007770f000070000000700000007000000070000000700000007000000000000000000000000000000000000000000000000000
07000070000ccc00000ccc00000ccc00000070000000700000007000000070000000700000007000000000000000000000000000000000000000000000000000
00000000000c0c00000c0c00000c0c00000700000007000000070000000700000007000000070000000000000000000000000000000000000000000000000000
555555552222222200000000000000000090080000a0090000800a00000000000000000000000000000000000000000000000000000000000000000000000000
5599995522eeee220000000000000000007007000070070000700700000000000000000000000000000000000000000000000000000000000000000000000000
5595555522e222220000000000000000087f97a0097fa7800a7f8790000000000000000000000000000000000000000000000000000000000000000000000000
5599955522eee2220000000000000000f7ff7f7ff7ff7f7ff7ff7f7f000000000000000000000000000000000000000000000000000000000000000000000000
5595555522222e22000000000000000097ff7f7997ff7f7997ff7f79000000000000000000000000000000000000000000000000000000000000000000000000
5595555522222e220000000000000000f999999ff999999ff999999f000000000000000000000000000000000000000000000000000000000000000000000000
5595555522eee22200000000000000009ffffff99ffffff99ffffff9000000000000000000000000000000000000000000000000000000000000000000000000
55555555222222220000000000000000099999900999999009999990000000000000000000000000000000000000000000000000000000000000000000000000
__label__
ccc0cc00ccc0ccc00cc0c0c00000ccc0ccc0c0c000000000000000000000000000000000000000000000000000ccc00cc0c0c0ccc00cc00000c0c0ccc0000000
c000c0c0c000c0c0c000c0c0000000c0c0c000c000000000000000000000000000000000000000000000000000ccc0c0c0c0c0c000c0000000c0c000c0000000
cc00c0c0cc00cc00c000ccc000000cc0c0c00c0000000000000000000000000000000000000000000000000000c0c0c0c0c0c0cc00ccc00000ccc000c0000000
c000c0c0c000c0c0c0c000c0000000c0c0c0c00000000000000000000000000000000000000000000000000000c0c0c0c0ccc0c00000c0000000c000c0000000
ccc0c0c0ccc0c0c0ccc0ccc00000ccc0ccc0c0c000000000000000000000000000000000000000000000000000c0c0cc000c00ccc0cc00000000c000c0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b31125253b1125253b1125253b1125253b1125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
253b1125253b1125253b1125253b1125253b1125253b1125253b1125253b1125253b1125253b1125253b1125253b112525b3112525b3112525b3112525b31125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b3112525b31125253b1125253b1125253b1125253b1125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
253b11256666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666253b1125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25b31125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625b31125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
253b11256666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666253b1125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666662555555525555555255555556666666625555555666666666666666625555555666666662555555525555555255555556116611625555555
253b112566666666253b1125253b1125253b112566666666253b11256666666666666666253b112566666666253b1125253b1125253b112561666616253b1125
2555555566666666255555552555555525555555666666662555555566666666666666662555555566666666255555552555555525555555616cc61625555555
25b311256666666625b3112525b3112525b311256666666625b31125666666666666666625b311256666666625b3112525b3112525b311251666666125b31125
2555555566666666255555552555555525555555666666662555555566666666666666662555555566666666255555552555555525555555616cc61625555555
253b112566666666253b1125253b1125253b112566666666253b11256666666666666666253b112566666666253b1125253b1125253b112561666616253b1125
25555555666666662555555525555555255555556666666625555555666666666666666625555555666666662555555525555555255555556116611625555555
25666625666666662566662525666625256666256666666625666625666666666666666625666625666666662566662525666625256666256666666625666625
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666666666666633666255555556666666625555555
253b112566666666253b1125666666666666666666666666253b11256666666666666666253b11256666666666666666663bb366253b112566666666253b1125
255555556666666625555555666666666666666666666666255555556666666666666666255555556666666666666666663bb366255555556666666625555555
25b311256666666625b3112566666666666666666666666625b31125666666666666666625b31125666666666666666663bbbb3625b311256666666625b31125
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666666666663b44b36255555556666666625555555
253b112566666666253b1125666666666666666666666666253b11256666666666666666253b1125666666666666666663b44b36253b112566666666253b1125
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666666666663bbbb36255555556666666625555555
25666625666666662566662566666666666666666666666625666625666666666666666625666625666666666666666666333366256666256666666625666625
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666356653666666666255555556666666625555555
253b112566666666253b112566666666666666666666666625118125666666666666666625118125666666669355553666666666251181256666666625118125
2555555566666666255555556666666666666666666666662555555566666666666666662555555566666666993aa39966666666255555556666666625555555
25b311256666666625b311256666666666666666666666662511812566666666666666662511812566666666633aa33966666666251181256666666625118125
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666669333333666666666255555556666666625555555
253b112566666666253b112566666666666666666666666625118125666666666666666625118125666666669934439966666666251181256666666625118125
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666393393966666666255555556666666625555555
25666625666666662566662566666666666666666666666625666625666666666666666625666625666666666696696666666666256666256666666625666625
25555555666666662555555566666666666666666666666625555555666666666666666625555555668888666666666666666666255555556666666625555555
25118125666666662511812566666666666666666666666625118125666666666666666625118125689999866666666666666666251181256666666625118125
2555555566666666255555556666666666666666666666662555555566666666666666662555555589aaaa986666666666666666255555556666666625555555
251181256666666625118125666666666666666666666666251181256666666666666666251181259abbbba96666666666666666251181256666666625118125
25555555666666662555555566666666666666666666666625555555666666666666666625555555abccccba6666666666666666255555556666666625555555
25118125666666662511812566666666666666666666666625118125666666666666666625118125bc2222cb6666666666666666251181256666666625118125
25555555666666662555555566666666666666666666666625555555666666666666666625555555c266662c6666666666666666255555556666666625555555
25666625666666662566662566666666666666666666666625666625666666666666666625666625266666626666666666666666256666256666666625666625
25555555666666662555555525555555255555552555555525555555635665366666666625555555255555552555555525555555255555556666666625555555
25118125666666662511812525118125251181252511812525118125935555366666666625118125251181252511812525118125251181256666666625118125
25555555666666662555555525555555255555552555555525555555993aa3996666666625555555255555552555555525555555255555556666666625555555
25118125666666662511812525118125251181252511812525118125633aa3396666666625118125251181252511812525118125251181256666666625118125
25555555666666662555555525555555255555552555555525555555933333366666666625555555255555552555555525555555255555556666666625555555
25118125666666662511812525118125251181252511812525118125993443996666666625118125251181252511812525118125251181256666666625118125
25555555666666662555555525555555255555552555555525555555639339396666666625555555255555552555555525555555255555556666666625555555
25666625666666662566662525666625256666252566662525666625669669666666666625666625256666252566662525666625256666256666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625555555
25118125666666666666666666666666666666666666666666666666666666666666666666c76666666666666666666666666666666666666666666625118125
2555555566666666666666666666666666666666666666666666666666666666666666666ccc7666666666666666666666666666666666666666666625555555
251181256666666666666666666666666666666666666666666666666666666666666666c7cccc76666666666666666666666666666666666666666625118125
255555556666666666666666666666666666666666666666666666666666666666666666cc7c7cc7666666666666666666666666666666666666666625555555
251181256666666666666666666666666666666666666666666666666666666666666666ccccc7cc666666666666666666666666666666666666666625118125
2555555566666666666666666666666666666666666666666666666666666666666666666cccccc6666666666666666666666666666666666666666625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666625666625
25555555666666662555555525555555255555552555555525555555666666666666666625555555255555552555555525555555255555556666666625555555
25118125666666662511812525118125251181252511812525118125666666666666666625118125251181252511812525118125251181256666666625118125
25555555666666662555555525555555255555552555555525555555666666666666666625555555255555552555555525555555255555556666666625555555
25118125666666662511812525118125251181252511812525118125666666666666666625118125251181252511812525118125251181256666666625118125
25555555666666662555555525555555255555552555555525555555666666666666666625555555255555552555555525555555255555556666666625555555
25118125666666662511812525118125251181252511812525118125666666666666666625118125251181252511812525118125251181256666666625118125
25555555666666662555555525555555255555552555555525555555666666666666666625555555255555552555555525555555255555556666666625555555
25666625666666662566662525666625256666252566662525666625666666666666666625666625256666252566662525666625256666256666666625666625
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666666666666666666255555556666666625555555
251181256666666625118125666666666666666666c7666625118125666666666666666625118125666666666666666666666666251181256666666625118125
25555555666666662555555566666666666666666ccc766625555555666666666666666625555555666666666666666666666666255555556666666625555555
2511812566666666251181256666666666666666c7cccc7625118125666666666666666625118125666666666666666666666666251181256666666625118125
2555555566666666255555556666666666666666cc7c7cc725555555666666666666666625555555666666666666666666666666255555556666666625555555
2511812566666666251181256666666666666666ccccc7cc25118125666666666666666625118125666666666666666666666666251181256666666625118125
25555555666666662555555566666666666666666cccccc625555555666666666666666625555555666666666666666666666666255555556666666625555555
25666625666666662566662566666666666666666666666625666625666666666666666625666625666666666666666666666666256666256666666625666625
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666666333333663566536255555556666666625555555
25118125666666662511812566666666666666666666666625118125666666666666666625118125666666663333333393555536251181256666666625118125
255555556666666625555555666666666666666666666666255555556666666666666666255555556666666633333333993aa399255555556666666625555555
251181256666666625118125666666666666666666666666251181256666666666666666251181256666666633333333633aa339251181256666666625118125
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666663333333393333336255555556666666625555555
25118125666666662511812566666666666666666666666625118125666666666666666625118125666666663333333399344399251181256666666625118125
25555555666666662555555566666666666666666666666625555555666666666666666625555555666666663333333363933939255555556666666625555555
25666625666666662566662566666666666666666666666625666625666666666666666625666625666666666333333666966966256666256666666625666625
25555555666666662555555566633666666666666669a66625555555666666666666666625555555666666666666666666666666255555556666666625555555
251181256666666625118125663bb366666666666169a61625118125666666666666666625118125666666666666666666666666251181256666666625118125
255555556666666625555555663bb366666666661669a66125555555666666666666666625555555666666666666666666666666255555556666666625555555
25118125666666662511812563bbbb366666666616669a6125118125666666666666666625118125666666666666666666666666251181256666666625118125
25555555666666662555555563b44b3666666666c6669a6c25555555666666666666666625555555666666666666666666666666255555556666666625555555
25118125666666662511812563b44b3666666666c669a66c25118125666666666666666625118125666666666666666666666666251181256666666625118125
25555555666666662555555563bbbb36666666666c6966c625555555666666666666666625555555666666666666666666666666255555556666666625555555
25666625666666662566662566333366666666666669666625666625666666666666666625666625666666666666666666666666256666256666666625666625
25555555666666662555555525555555255555556666666625555555666666666666666625555555888888882555555525555555255555556666666625555555
25118125666666662511812525118125251181256666666625118125666666666666666625118125855555582511812525118125251181256666666625118125
2555555566666666255555552555555525555555666666662555555566666666666666662555555585cccc582555555525555555255555556666666625555555
2511812566666666251181252511812525118125666666662511812566666666666666662511812585cccc582511812525118125251181256666666625118125
25555555666666662555555525555555255555556666666625555555666666666666666625555555855555582555555525555555255555556666666625555555
25118125666666662511812525118125251181256666666625118125666666666666666625118125855556582511812525118125251181256666666625118125
25555555666666662555555525555555255555556666666625555555666666666666666625555555855555582555555525555555255555556666666625555555
25666625666666662566662525666625256666256666666625666625666666666666666625666625855555582566662525666625256666256666666625666625
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666886887625555555
25118125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666668888888725118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666668888888725555555
25118125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666668888888725118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666668888888725555555
25118125666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666888887625118125
25555555666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666688876625555555
25666625666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666668766625666625
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25118125251181252511812525118125251181252511812525118125251181252511812525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25118125251181252511812525118125251181252511812525118125251181252511812525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25118125251181252511812525118125251181252511812525118125251181252511812525118125251181252511812525118125251181252511812525118125
25555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555255555552555555525555555
25666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625256666252566662525666625

__gff__
0000000002020202020200000000000001010900050505141800000000000000000509000000202020200000000000000001000001002400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1011101110111011101110111011101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000006000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000007001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1004000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100001414141400001414141400001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000001400000000001400000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100001400000500001414140000081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000001414140000000000001400001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100001400000000000000001405001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000001400000000001414140000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000600000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000080000000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100070000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000900001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1110111011101110111011101110111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400001a040230001b000220001f0001b000170001600015000140001460015600186001b6001f60021600276000d4000e40000000000000000000000000000000000000000000000000000000000000000000
000400001801001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000020000190002000020000220001b80000000
00040000330002b00027000210001f000340002d000280002400023000350002f0002700024000210001d0001a00017000020001b0001f0001e0001e0001e0001900020000190002000020000220001b80000000
000400001902011000190201100020030190002003019000270402000027040200003104016000310402700000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003000016020297001b02027700210202d5002e0302c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001e00025000290002b000250001e0001d0001d0001f0002200025000280003300033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001c300000001930000000163000000012300000000e300000000b300000000630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000201030000600103002c60000000103000000019600103000230014700176001030013300153000000012300000001230000000000001130000000000001030000000000000030013300103000e30000000
0010001021000290003200021000290003200020000200002000020000200002000020000200002000030000300030c2030d2030f203122031420317203192031c2031e2032020324203272032a2032e20331203
001000201c7011c7001c7001c7001c7001c7001c7001c7001c7001c7001c7001c700217012170021700217001e7011e7001e7001e7001e7001e7001e7001e7001c7011c7001c7001c7001a7011a7001a7001a700
__music__
03 48080a44
03 484a4344
03 414a4744
