Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="Hång ¶nh ThÈm Viªn UyÓn", 	tbProp={0,204}, nQuality=1},
	{szName="Hång ¶nh KiÕm Bµi", 		tbProp={0,205}, nQuality=1},
	{szName="Hång ¶nh Môc Tóc", 		tbProp={0,206}, nQuality=1},
	{szName="Hång ¶nh Tô Chiªu", 		tbProp={0,207}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "Hång ¶nh")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim Hång ¶nh<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end