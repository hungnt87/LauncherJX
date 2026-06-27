Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="Kim Quang TrÝch Tinh Hoµn", 			tbProp={0,194}, nQuality=1},
	{szName="Kim Quang §­êng Nghª Gi¸p", 			tbProp={0,195}, nQuality=1},
	{szName="Kim Quang Lôc PhØ Thóy Hé Th©n Phï", 	tbProp={0,196}, nQuality=1},
	{szName="Kim Quang B¾c Kinh Chi Méng", 			tbProp={0,197}, nQuality=1},
	{szName="Kim Quang B¹ch Kim Yªu §¸i", 			tbProp={0,198}, nQuality=1},
	{szName="Kim Quang Thiªn Tµm Hé UyÓn", 			tbProp={0,199}, nQuality=1},
	{szName="Kim Quang Ngò S¾c Ngäc Béi", 			tbProp={0,200}, nQuality=1},
	{szName="KKim Quang Thiªn Tµm Ngoa", 			tbProp={0,201}, nQuality=1},
	{szName="Kim Quang Nh· §iÓn Chi Hån", 			tbProp={0,202}, nQuality=1},
	{szName="Kim Quang B«n L«i Toµn Long Th­¬ng", 	tbProp={0,203}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "Kim Quang")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim Kim Quang<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end