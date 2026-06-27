Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="§Þnh Quèc Thanh Sa Tr­êng Sam", 		tbProp={0,159}, nQuality=1},
	{szName="§Þnh Quèc ¤ Sa Ph¸t Qu¸n", 			tbProp={0,160}, nQuality=1},
	{szName="§Þnh Quèc XÝch Quyªn NhuyÔn Ngoa", 	tbProp={0,161}, nQuality=1},
	{szName="§Þnh Quèc Tö §»ng Hé UyÓn", 			tbProp={0,162}, nQuality=1},
	{szName="§Þnh Quèc Ng©n Tµm Yªu §¸i", 			tbProp={0,163}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "§Þnh Quèc")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim §Þnh Quèc<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end