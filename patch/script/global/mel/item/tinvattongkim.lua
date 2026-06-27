Include("\\script\\battles\\battlehead.lua")

----------------------------------------------------------------------------------------------------
--										  Tİn VËt Tèng Kim								  		  --
----------------------------------------------------------------------------------------------------
function main()
	if GetTask(TASK_ID_DAY_TK) ~= tonumber(GetLocalDate("%m%d")) then
        SetTask(TASK_ID_DAY_TK, tonumber(GetLocalDate("%m%d")))
        SetTask(TASK_ID_COUNT_TK, 0)
		SetTask(TASK_ID_POINT_TK_PER_DAY, 0)
    end
	local nPointTKPerDay = tonumber(GetTask(TASK_ID_POINT_TK_PER_DAY)) or 0
	if nPointTKPerDay >= 10000 then
		Say("B¹n ®· nhËn 10000 ®iÓm Tèng Kim trong ngµy råi, Kh«ng thÓ nhËn thªm ®­îc n÷a!")
		return 1
	end
	SetTask(747, GetTask(747) + 2000)
	SetTask(TASK_ID_POINT_TK_PER_DAY, nPointTKPerDay + 2000)
	Msg2Player("B¹n ®· nhËn ®­îc thªm <color=green>2000<color> ®iÓm tİch lòy Tèng Kim!")
	return 0
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>Mét lÇn sö dông ®­îc <color><color=orange>2000 ®iÓm Tèng Kim<color>\n"
    szDesc = szDesc.."<color=water>Mçi ngµy sö dông nhËn tèi ®a <color><color=orange>10000 ®iÓm Tèng Kim<color>"
    return szDesc
end