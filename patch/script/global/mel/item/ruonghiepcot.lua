Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="HiÖp Cèt ThiÕt HuyÕt Sam", 	tbProp={0,186}, nQuality=1},
	{szName="HiÖp Cèt §a T×nh Hoµn", 		tbProp={0,187}, nQuality=1},
	{szName="HiÖp Cèt §an T©m Giíi", 		tbProp={0,188}, nQuality=1},
	{szName="HiÖp Cèt T×nh ý KÕt", 			tbProp={0,189}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "HiÖp Cèt")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim HiÖp Cèt<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end