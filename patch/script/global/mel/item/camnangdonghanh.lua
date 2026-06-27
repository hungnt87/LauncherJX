Include("\\script\\gm_tool\\dispose_item.lua")
Include("\\script\\global\\mel\\configserver.lua")

----------------------------------------------------------------------------------------------------
--										 CÈm Nang §ång Hµnh										  --
----------------------------------------------------------------------------------------------------
function main(nItemIndex)
    dofile("script/global/mel/item/camnangdonghanh.lua")
    local nTTK = GetTask(81)
    local nVLMT = GetTask(80)
    local nDiemTK = GetTask(747)
	local nPhucDuyen = GetTask(151)
    local nVinhDu = GetTask(2501)
    local nMayMan = GetLucky(0)
	
    local nLen = 17
    local szThongTin = format("Th«ng tin:\n")
    szThongTin = szThongTin..format("<pic=135> <color=green>%-"..nLen.."s<color>: <color=orange>%d<color>/<color=green>%d<color>\n", "TÈy Tñy Kinh", nTTK, GioiHanTTK)
    szThongTin = szThongTin..format("<pic=135> <color=green>%-"..nLen.."s<color>: <color=orange>%d<color>/<color=green>%d<color>\n", "Vâ L©m MËt TÞch", nVLMT, GioiHanVLMT)
    szThongTin = szThongTin..format("<pic=135> <color=green>%-"..nLen.."s<color>: <color=orange>%d<color>\n", "§iÓm Tèng Kim", nDiemTK)
	szThongTin = szThongTin..format("<pic=135> <color=green>%-"..nLen.."s<color>: <color=orange>%d<color>\n", "§iÓm Phóc Duyªn", nPhucDuyen)
    szThongTin = szThongTin..format("<pic=135> <color=green>%-"..nLen.."s<color>: <color=orange>%d<color>\n", "§iÓm Vinh Dù", nVinhDu)
    szThongTin = szThongTin..format("<pic=135> <color=green>%-"..nLen.."s<color>: <color=orange>%d", "ChØ sè May M¾n", nMayMan)

    local tbSay = {szThongTin}
		tinsert(tbSay, "NhËn tr¹ng th¸i Phi ChiÕn §Êu/phichiendau")
		tinsert(tbSay, "Gi¶i kÑt nh©n vËt/KetAcc")
		tinsert(tbSay, "Söa lçi ThÇn Hµnh Phï/FixTHP")
		tinsert(tbSay, "Hñy vËt phÈm/DisposeItem")
		tinsert(tbSay, "KÕt thóc ®èi tho¹i./no")
    CreateTaskSay(tbSay)
    return 1
end

----------------------------------------------------------------------------------------------------
--										   Phi ChiÕn §Êu								  		  --
----------------------------------------------------------------------------------------------------
function phichiendau()
	SetFightState(0)
end

----------------------------------------------------------------------------------------------------
--										 Gi¶i KÑt Nh©n VËt								  		  --
----------------------------------------------------------------------------------------------------
function KetAcc()
	Say("B¹n cã ch¾c ch¾n r»ng b¹n ®ang bÞ kÑt acc kh«ng?", 2, "§óng vËy!/GiaiKetNhanVat", "Ta nhÇm./no")
end

function GiaiKetNhanVat()
	local nW, nX, nY = GetWorldPos()
	for i=235,248 do
		if (nW == i) then
		Msg2Player("Map nµy kh«ng thÓ sö dông tÝnh n¨ng nµy!")
		return 1
		end
	end
	if (nW == 53) then
		SetPos(1626,3179)
	else
		NewWorld(53, 1626, 3179)
	end
	SetFightState(0)
	Msg2Player("Gi¶i kÑt nh©n vËt thµnh c«ng!")
end

function FixTHP()
	DisabledUseTownP(0)
end

function GetDesc(nItemIndex)
	local szDesc = "<color=water>Thiªn la ®Þa vâng còng kh«ng thÓ ng¨n c¶n!<color>\n"
	szDesc = szDesc.."<color=water>V¹n tr­îng th©m s¬n còng ch¼ng thÓ c¸ch lßng!<color>\n"
	return szDesc
end