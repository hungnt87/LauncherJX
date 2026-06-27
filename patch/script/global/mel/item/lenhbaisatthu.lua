Include("\\script\\missions\\basemission\\lib.lua")

tbMapHopLe={1025}
tbDanhSachBoss={
	{"U Minh S¸t Kh¸ch", 812},
	{"L·nh NguyÖt S¸t Gi¶", 813},
	{"HuyÕt ¶nh S¸t Tinh", 814},
	{"Tö V©n S¸t Ma", 815},
	{"¸m D¹ S¸t Qu©n", 816},
	{"HuyÒn DiÖp S¸t S­", 817},
	{"Hµn B¨ng S¸t T­íng", 818},
	{"V« ¶nh S¸t T«n", 819},
	{"Thiªn C« S¸t ThÇn", 820},
}

function main ()
	if KiemTraDieuKien() == 1 then
		goiBoss()
	else
		Talk(1,"","LÖnh bµi nµy chØ sö dông ®­îc bªn trong HuyÒn C¬ C¸c")
	end
	return 1
end

function KiemTraDieuKien()
	local w,x,y = GetWorldPos()
	for i =1,getn(tbMapHopLe) do
		if w == tbMapHopLe[i] and GetFightState() == 1 then
			return 1
		end
	end
	return 0
end

function goiBoss()
    local W,X,Y = GetWorldPos()
    local nRandomBoss = random(1,getn(tbDanhSachBoss))
    local nRandomSeries = random(0, 4)
    local tbNpc ={
        szName = tbDanhSachBoss[nRandomBoss][1],
        nNpcId = tbDanhSachBoss[nRandomBoss][2],
        nLevel = 95,
        nSeries = nRandomSeries,
        nIsboss = 1,
        szDeathScript = "\\script\\global\\mel\\feature\\satthu_death.lua",
    }
    basemission_CallNpc(tbNpc,W,X*32,Y*32)
    local tbNguHanhName = {"Kim", "Méc", "Thñy", "Háa", "Thæ"}
    Msg2Player("S¸t thñ hÖ " .. tbNguHanhName[nRandomSeries + 1] .. " ®· xuÊt hiÖn!")
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>Gäi ra ngÉu nhiªn 1 trong c¸c Cöu Thiªn S¸t Thñ:<color>\n"
    szDesc = szDesc.."<color=orange>U Minh S¸t Kh¸ch<color>\n"
	szDesc = szDesc.."<color=orange>L·nh NguyÖt S¸t Gi¶<color>\n"
	szDesc = szDesc.."<color=orange>HuyÕt ¶nh S¸t Tinh<color>\n"
	szDesc = szDesc.."<color=orange>Tö V©n S¸t Ma<color>\n"
	szDesc = szDesc.."<color=orange>¸m D¹ S¸t Qu©n<color>\n"
	szDesc = szDesc.."<color=orange>HuyÒn DiÖp S¸t S­<color>\n"
	szDesc = szDesc.."<color=orange>Hµn B¨ng S¸t T­íng<color>\n"
	szDesc = szDesc.."<color=orange>V« ¶nh S¸t T«n<color>\n"
	szDesc = szDesc.."<color=orange>Thiªn C« S¸t ThÇn<color>"
    return szDesc
end