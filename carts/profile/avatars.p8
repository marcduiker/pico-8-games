pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
local sprites={1,2,3,4,5,6}
local spr_id
local _t
local speed=6

function _init()
	_t=0
end

function _update()
		anim_spr()
		_t+=1
end


function anim_spr()
	local i=flr(_t/speed%#sprites)+1
	spr_id=sprites[i]
end

function _draw()
	cls(6)
	spr(spr_id,8*8,8*8)
end
__gfx__
00000000000444400004444000044440000444400004444044444000444440000004444400044440000000000000000000000000000000000000000000000000
0000000000fcfc0000fcfc0000fcfc0000fcfc0000fcfc0000fcfc0000fcfc0000fcfc0000fcfc00000000000000000000000000000000000000000000000000
00000000004fef00004fef00004fef00004fef00004fef00004fef00004fef000f4fef00004fef00000000000000000000000000000000000000000000000000
00077000004774000047740f00448400094ff490f94ff49f0448880f0448880f0948880000477400000000000000000000000000000000000000000000000000
00077000094444900944449909444490094444900944449044444499444444990944444409444490000000000000000000000000000000000000000000000000
000000000999999009999900099999900f9999f00099990009f9990009f999000099444f09999990000000000000000000000000000000000000000000000000
000000000fd11df00fd11d000fd11df000d11d0000d11d0000d11d000011110000d11d000f3333f0000000000000000000000000000000000000000000000000
00000000001001000010010000100100001001000010010000100100001001000010010000300300000000000000000000000000000000000000000000000000
00000000000444400004444000044440000444400000004000044440000444440000000000044440000000000000000000000000000000000000000000000000
0000000000fcfc0000fcfc0000fcfc0000fcfc000004444000fcfc0000fcfc000000000000fcfc00000000000000000000000000000000000000000000000000
00000000004774000047740f00448400004ff400f0fcfc0f094ff4900f4884000000000000477400000000000000000000000000000000000000000000000000
00000000094444900944449909444490094444909948849909444490094444440000000009444490000000000000000000000000000000000000000000000000
0000000009999990099999000999999009999990004444000f9999f00999999f0000000009999990000000000000000000000000000000000000000000000000
000000000f1111f00f1111000f1111f00f1111f0001111000011110000111100000000000f1111f0000000000000000000000000000000000000000000000000
00000000001001000010010000100100001001000010010000100100001001000000000000100100000000000000000000000000000000000000000000000000
0000000000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d000000000000d00d00000000000000000000000000000000000000000000000000
000000000009a0000000000004400000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000019a1000000044444400000000004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000109a01000000fffff00000000000fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000010009a010000f7cf7cf000000000f7cf7cf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c0009a0c0000f77f77f000000000f77f77f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c09a0c000000ffeff00000000000ffeff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c90c000000074444000000000007444400f00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000900000000047744000000000004777400ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000009944444990000000994444499990000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000099994449999000009999444999990000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000099999999999000009999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000ff9999999ff00000ff99999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000fd11d11df0000000fd11d11d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000111111100000000011111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000110001100000000011000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000440004400000000044000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000