Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="Nhu T×nh C©n Quèc Nghª Th­êng", 	tbProp={0,190}, nQuality=1},
	{szName="Nhu T×nh Thôc N÷ H¹ng Liªn", 		tbProp={0,191}, nQuality=1},
	{szName="Nhu T×nh Phông Nghi Giíi ChØ", 	tbProp={0,192}, nQuality=1},
	{szName="Nhu T×nh TuÖ T©m Ngäc Béi", 		tbProp={0,193}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "Nhu T×nh")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim Nhu T×nh<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end