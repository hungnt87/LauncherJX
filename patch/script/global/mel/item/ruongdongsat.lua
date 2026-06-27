Include("\\script\\lib\\awardtemplet.lua")

local tbItem = {
	{szName="§éng S¸t B¹ch Kim §iªu Long Giíi", 	tbProp={0,143}, nQuality=1},
	{szName="§éng S¸t B¹ch Ngäc Cµn Kh«n Béi", 		tbProp={0,144}, nQuality=1},
	{szName="§éng S¸t B¹ch Kim Tó Phông Giíi", 		tbProp={0,145}, nQuality=1},
	{szName="§éng S¸t PhØ Thóy Ngäc H¹ng Khuyªn", 	tbProp={0,146}, nQuality=1},
}

function main()
	if (CalcFreeItemCellCount() < 40) then
		Talk(1, "", "Hµnh trang kh«ng ®ñ 40 « trèng ®Ó nhËn.")
	return 1
	end
	tbAwardTemplet:GiveAwardByList(%tbItem, "§éng S¸t")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Më ra nhËn ®­îc bé trang bÞ:<color>\n"
    szDesc = szDesc.."<color=yellow>Hoµng Kim §éng S¸t<color>\n"
    szDesc = szDesc.."<color=water>NgÉu nhiªn thuéc tÝnh<color>"
    return szDesc
end