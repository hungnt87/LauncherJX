Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="Vinh Di÷u Chi Y", 		tbProp={0,214}, nQuality=1},
	{szName="Tinh Chu»n Chi Ngoa", 	tbProp={0,215}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh´ng ÆÒ 40 ´ trËng Æ” nhÀn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "Vinh Di÷u")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>MÎ ra nhÀn Æ≠Óc bÈ trang bﬁ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim Vinh Di÷u<color>\n"
    szDesc = szDesc.."<color=water>Ng…u nhi™n thuÈc t›nh<color>"
    return szDesc
end