Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="An Bang B¨ng Tinh Th¹ch H¹ng Liªn", 	tbProp={0,164}, nQuality=1},
	{szName="An Bang Cóc Hoa Th¹ch ChØ Hoµn", 		tbProp={0,165}, nQuality=1},
	{szName="An Bang §iÒn Hoµng Th¹ch Ngäc Béi", 	tbProp={0,166}, nQuality=1},
	{szName="An Bang Kª HuyÕt Th¹ch Giíi ChØ", 		tbProp={0,167}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "An Bang")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim An Bang<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end