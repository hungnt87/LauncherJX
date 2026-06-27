Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="Thiªn Hoµng Long Long §µi", 			tbProp={0,168}, nQuality=1},
	{szName="Thiªn Hoµng Long B¹ch Long Tøc", 		tbProp={0,169}, nQuality=1},
	{szName="Thiªn Hoµng Long TrÊn Minh Liªn", 		tbProp={0,170}, nQuality=1},
	{szName="Thiªn Hoµng Long Cöu HiÖn ChØ", 		tbProp={0,171}, nQuality=1},
	{szName="Thiªn Hoµng Long Ngäc Tiªu Diªu", 		tbProp={0,172}, nQuality=1},
	{szName="Thiªn Hoµng Long Hoµng Kim L©n", 		tbProp={0,173}, nQuality=1},
	{szName="Thiªn Hoµng Long Bµn Long C«i", 		tbProp={0,174}, nQuality=1},
	{szName="Thiªn Hoµng Long Long Khèc Thiªn Lý", 	tbProp={0,175}, nQuality=1},
	{szName="Thiªn Hoµng Long Né Long §ång", 		tbProp={0,176}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "Thiªn Hoµng")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim Thiªn Hoµng<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end