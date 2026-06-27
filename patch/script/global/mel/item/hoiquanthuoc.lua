IncludeLib("SETTING")

----------------------------------------------------------------------------------------------------
--										   Thuèc Héi Qu¸n										  --
----------------------------------------------------------------------------------------------------
function main(itemIdx)
	local _,_,detail = GetItemProp(itemIdx)
	if(detail == 4928) then -- Tèc ®é xuÊt chiªu néi & ngo¹i 20%
		AddSkillState(1218,10,1,18*2700,1)
		return 0
	end
	if(detail == 4929) then -- Phßng thñ vËt lı 30%
		AddSkillState(1219,15,1,18*2700,1)
		return 0
	end
	if(detail == 4930) then -- Kh¸ng ®éc 30%
		AddSkillState(1220,15,1,18*2700,1)
		return 0
	end
	if(detail == 4931) then -- Kh¸ng b¨ng 30%
		AddSkillState(1221,15,1,18*2700,1)
		return 0
	end
	if(detail == 4932) then -- Kh¸ng háa 30%
		AddSkillState(1222,15,1,18*2700,1)
		return 0
	end
	if(detail == 4933) then -- Kh¸ng l«i 30%
		AddSkillState(1223,15,1,18*2700,1)
		return 0
	end
	if(detail == 4934) then -- Thêi gian bŞ th­¬ng / Thêi gian phôc håi 40%
		AddSkillState(1224,20,1,18*2700,1)
		return 0
	end
	if(detail == 4935) then -- Thêi gian cho¸ng 40%
		AddSkillState(1225,20,1,18*2700,1)
		return 0
	end
	if(detail == 4936) then -- Thêi gian tróng ®éc
		AddSkillState(1226,20,1,18*2700,1)
		return 0
	end
	if(detail == 4937) then -- Thêi gian lµm chËm
		AddSkillState(1227,20,1,18*2700,1)
		return 0
	end
	if(detail == 4938) then -- S¸t th­¬ng vËt lı - Ngo¹i c«ng 50% - Néi c«ng 100 ®iÓm
		AddSkillState(1228,10,1,18*2700,1)
		return 0
	end
	if(detail == 4939) then -- §éc s¸t  - Ngo¹i c«ng 10 ®iÓm - Néi c«ng 10 ®iÓm
		AddSkillState(1229,10,1,18*2700,1)
		return 0
	end
	if(detail == 4940) then -- B¨ng s¸t - Ngo¹i c«ng 100 ®iÓm - Néi c«ng 100 ®iÓm
		AddSkillState(1230,10,1,18*2700,1)
		return 0
	end
	if(detail == 4941) then -- Háa s¸t - Ngo¹i c«ng 100 ®iÓm - Néi c«ng 100 ®iÓm
		AddSkillState(1231,10,1,18*2700,1)
		return 0
	end
	if(detail == 4942) then -- L«i s¸t - Ngo¹i c«ng 100 ®iÓm - Néi c«ng 100 ®iÓm
		AddSkillState(1232,10,1,18*2700,1)
		return 0
	end
	if(detail == 4943) then -- Sinh lùc 1000 ®iÓm
		AddSkillState(1233,10,1,18*2700,1)
		return 0
	end
	if(detail == 4944) then -- Néi lùc 1000 ®iÓm
		AddSkillState(1234,10,1,18*2700,1)
		return 0
	end
end

function GetDesc(itemIdx)
	local _,_,detail = GetItemProp(itemIdx)
	if(detail == 4928) then
		return "<color=water>Trong 45 phót:\nTèc ®é xuÊt chiªu ngo¹i c«ng t¨ng <color=orange>20%<color>\nTèc ®é xuÊt chiªu néi c«ng t¨ng <color=orange>20%<color><color>"
	end
	if(detail == 4929) then
		return "<color=water>Trong 45 phót:\nPhßng thñ vËt lı t¨ng <color=orange>30%<color><color>"
	end
	if(detail == 4930) then
		return "<color=water>Trong 45 phót:\nKh¸ng ®éc t¨ng <color=orange>30%<color><color>"
	end
	if(detail == 4931) then
		return "<color=water>Trong 45 phót:\nKh¸ng b¨ng t¨ng <color=orange>30%<color><color>"
	end
	if(detail == 4932) then
		return "<color=water>Trong 45 phót:\nKh¸ng háa t¨ng <color=orange>30%<color><color>"
	end
	if(detail == 4933) then
		return "<color=water>Trong 45 phót:\nKh¸ng l«i t¨ng <color=orange>30%<color><color>"
	end
	if(detail == 4934) then
		return "<color=water>Trong 45 phót:\nThêi gian bŞ th­¬ng gi¶m <color=orange>40%<color><color>"
	end
	if(detail == 4935) then
		return "<color=water>Trong 45 phót:\nThêi gian cho¸ng gi¶m <color=orange>40%<color><color>"
	end
	if(detail == 4936) then
		return "<color=water>Trong 45 phót:\nThêi gian tróng ®éc gi¶m <color=orange>40%<color><color>"
	end
	if(detail == 4937) then
		return "<color=water>Trong 45 phót:\nThêi gian lµm chËm gi¶m <color=orange>40%<color><color>"
	end
	if(detail == 4938) then
		return "<color=water>Trong 45 phót:\nS¸t th­¬ng vËt lı hÖ ngo¹i c«ng t¨ng <color=orange>50%<color>\nS¸t th­¬ng vËt lı hÖ néi c«ng t¨ng <color=orange>100 ®iÓm<color><color>"
	end
	if(detail == 4939) then
		return "<color=water>Trong 45 phót:\n§éc s¸t hÖ ngo¹i c«ng t¨ng <color=orange>10 ®iÓm/lÇn<color>\n§éc s¸t hÖ néi c«ng t¨ng <color=orange>10 ®iÓm/lÇn<color><color>"
	end
	if(detail == 4940) then
		return "<color=water>Trong 45 phót:\nB¨ng s¸t hÖ ngo¹i c«ng t¨ng <color=orange>100 ®iÓm<color>\nB¨ng s¸t hÖ néi c«ng t¨ng <color=orange>100 ®iÓm<color><color>"
	end
	if(detail == 4941) then
		return "<color=water>Trong 45 phót:\nHáa s¸t hÖ ngo¹i c«ng t¨ng <color=orange>100 ®iÓm<color>\nHáa s¸t hÖ néi c«ng t¨ng <color=orange>100 ®iÓm<color><color>"
	end
	if(detail == 4942) then
		return "<color=water>Trong 45 phót:\nL«i s¸t ngo¹i c«ng t¨ng <color=orange>100 ®iÓm<color>\nL«i s¸t néi c«ng t¨ng <color=orange>100 ®iÓm<color><color>"
	end
	if(detail == 4943) then
		return "<color=water>Trong 45 phót:\nSinh lùc lín nhÊt t¨ng <color=orange>1000 ®iÓm<color><color>"
	end
	if(detail == 4944) then
		return "<color=water>Trong 45 phót:\nNéi lùc lín nhÊt t¨ng <color=orange>1000 ®iÓm<color><color>"
	end
end