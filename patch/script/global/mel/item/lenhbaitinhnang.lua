IncludeLib("ITEM")
IncludeLib("FILESYS")
Include("\\script\\lib\\remoteexc.lua")
Include("\\script\\dailogsys\\dailogsay.lua")
Include("\\script\\lib\\string.lua")
Include("\\script\\vng_lib\\files_lib.lua")
Include("\\script\\global\\mel\\configserver.lua")
Include("\\script\\global\\vinh\\simcity\\controllers\\thanhthi.lua")
Include("\\script\\global\\vinh\\simcity\\head.lua")
Include("\\script\\global\\vinh\\simcity\\controllers\\main.lua")
Include("\\script\\global\\vinh\\simcity\\controllers\\keoxe.lua")

----------------------------------------------------------------------------------------------------
--										 LÖnh Bµi TÝnh N¨ng								  		  --
----------------------------------------------------------------------------------------------------
THONGTINSERVER_DIALOG = "Sè l­îng tµi kho¶n online: <color=green>%s<color>\n"
TITLE_DIALOG = "Tªn nh©n vËt: <color=green>%s<color> "
TITLE_DIALOG  = TITLE_DIALOG.."-- TTK: <color=gold>%s<color>/<color=green>%s<color>, VLMT: <color=gold>%s<color>/<color=green>%s<color>\n"
DOCHI_DIALOG = "ThÇn BÝ §å ChÝ: <color=green>%s<color>\n"
DIEMTK_DIALOG = "§iÓm tÝch lòy Tèng Kim: <color=green>%s<color>\n"
DATAU_DIALOG = "NhiÖm vô D· TÈu ®· hoµn thµnh: <color=green>%s<color>\n"
BOSS_SATTHU_DIALOG = "NhiÖm vô Boss S¸t Thñ: <color=gold>%s<color>/<color=green>%s<color>\n"
THONGTINNHANVAT_DIALOG = "ChØ sè May m¾n: <color=green>%s<color>"

function main(nItemIndex)
	dofile("script/global/mel/item/lenhbaitinhnang.lua")
	local strFaction = GetFaction()
	local nW,nX,nY = GetWorldPos();
	local year = tonumber(date( "%y"))
	local mm = tonumber(date( "%m"))
	local day = tonumber(date( "%d"))
	local hour = tonumber(GetLocalDate("%H"))
	local mmin = tonumber(GetLocalDate("%M"))
	local nDate = tonumber(GetLocalDate("%y%m%d"));	
	local nDochi = GetTask(1027)
	local myDateBossST = GetTask(1192);
	local nTTK = GetTask(81);
	local nVLMT = GetTask(80);
	if myDateBossST ~= nDate then
		SetTask(1193, 0);
		SetTask(1192, nDate);
	end
	local nBossST = GetTask(1193)
	local nDiemTK = GetTask(747)
	local szThongTin = format(THONGTINSERVER_DIALOG, GetPlayerCount());
	szThongTin = szThongTin..format(TITLE_DIALOG, GetName(), nTTK, GioiHanTTK, nVLMT, GioiHanVLMT);
	szThongTin = szThongTin..format(DOCHI_DIALOG, nDochi);
	szThongTin = szThongTin..format(BOSS_SATTHU_DIALOG, nBossST,SoLuongBossSatThuTrongNgay);
	szThongTin = szThongTin..format(DIEMTK_DIALOG, nDiemTK);
	szThongTin = szThongTin..format(DATAU_DIALOG, GetTask(1044));
	szThongTin = szThongTin..format(THONGTINNHANVAT_DIALOG, GetLucky(0));
	local tbSay = {szThongTin};

		tinsert(tbSay,"Qu¶n lý ho¹t ®éng/melhoatdong");
		tinsert(tbSay,"SimCity KÐo Xe /melkeoxe");
		tinsert(tbSay,"SimCity ChiÕn Lo¹n/melchienloan");
		tinsert(tbSay,"LÊy ID NPC xung quanh/LietKeNPCXungQuanh");
		tinsert(tbSay,"Ghi täa ®é b·i qu¸i/GhiBaiQuai")
		tinsert(tbSay,"KÕt thóc ®èi tho¹i./no")

		CreateTaskSay(tbSay)
	return 1;
end

----------------------------------------------------------------------------------------------------
--										 Qu¶n lý ho¹t ®éng								  		  --
----------------------------------------------------------------------------------------------------
function melhoatdong()

	tbTitle = "Khëi ®éng hÖ thèng Ho¹t §éng"
	tbSay = {}

	tinsert(tbSay,"Më Boss TiÓu/#StartMissions(1)")
	tinsert(tbSay,"Më Boss §¹i/#StartMissions(2)")
	tinsert(tbSay,"Më V­ît ¶i/#StartMissions(3)")
	tinsert(tbSay,"Më Phong L¨ng §é/#StartMissions(4)")
	tinsert(tbSay,"Më Tèng Kim [Cao CÊp]/#StartMissions(5)")
	tinsert(tbSay,"Më Phong Háa Liªn Thµnh/#StartMissions(6)")
	tinsert(tbSay,"Më Boss TuyÖt §Ønh Vò §Õ/#StartMissions(7)")
	tinsert(tbSay,"Cancel/OnCancel")

	Say(tbTitle, getn(tbSay), tbSay)
end

function StartMissions(MsID)
	if (MsID == 1) then
		RemoteExc("\\script\\startmissions.lua", "Call_SmallBoss")
	elseif (MsID == 2) then
		RemoteExc("\\script\\startmissions.lua", "Call_BigBoss")
	elseif (MsID == 3) then
		RemoteExc("\\script\\startmissions.lua", "VuotAi")
	elseif (MsID == 4) then
		RemoteExc("\\script\\startmissions.lua", "PhongLangDo")
	elseif (MsID == 5) then
		RemoteExc("\\script\\startmissions.lua", "StartTongKim_3")
	elseif (MsID == 6) then
		RemoteExc("\\script\\startmissions.lua", "PhongHoaLienThanh")
	elseif (MsID == 7) then
		RemoteExc("\\script\\startmissions.lua", "TuyetDinhVuDe")
	end
end

----------------------------------------------------------------------------------------------------
--										 §iÒu khiÓn SimCity								  		  --
----------------------------------------------------------------------------------------------------
function melkeoxe()
	return SimCityKeoXe:mainMenu()
end

function melchienloan()
	SimCityThanhThi:mainMenu()
	return 1
end

----------------------------------------------------------------------------------------------------
--										LÊy ID NPC xung quanh								  	  --
----------------------------------------------------------------------------------------------------
function LietKeNPCXungQuanh()
    local tbNpcList = GetAroundNpcList(60)
    if not tbNpcList or type(tbNpcList) ~= "table" or getn(tbNpcList) == 0 then
        print("Kh«ng t×m thÊy NPC nµo trong ph¹m vi")
        return 0
    end
    local total = getn(tbNpcList)
    print("T×m thÊy " .. total .. " NPC trong ph¹m vi:")
    for i = 1, total do
        local nNpcIdx = tbNpcList[i]
        local npcId = GetNpcSettingIdx(nNpcIdx)
        if npcId then
            print("NPC " .. i .. ": ID=" .. tostring(npcId))
        else
            print("NPC " .. i .. ": ID kh«ng hîp lÖ (nil)")
        end
    end
    return total
end

----------------------------------------------------------------------------------------------------
--										Ghi täa ®é b·i qu¸i									  	  --
----------------------------------------------------------------------------------------------------
function GetMapNameById(mapId)
    local fileName = "maplist.ini"
    local filePath = "settings/maplist.ini"
    local file = openfile(filePath, "r")
    if not file then
        print("Error: Could not open " .. filePath)
        return "Unknown"
    end

    local targetKey =mapId.."_name"
    local line = read(file, "*l")
    while line do
        if strfind(line, targetKey) then
            closefile(file)
            break
        end
        line = read(file, "*l")
    end

    local tbtemp = {}
    tbtemp = split(line, "=")
    return tbtemp[2] or "Unknown Map"

end

function GhiBaiQuai()
    local filePath = "settings/global/mel/"
    local fileName = "toado.txt"
    local pW, pX, pY = GetWorldPos()
    local pX1 = floor((tonumber(pX)*32)/256)
    local pY1 = floor((tonumber(pY)*32)/512)
    local szMapName = GetMapNameById(pW)
    local tbData = {pW, pX, pY, pX1, pY1, szMapName}
    tbVngLib_File:Table2File(filePath, fileName, "a", tbData)    
    Msg2Player("<color=red>Ghi täa ®é thµnh c«ng "..szMapName .." ("..pX1..","..pY1..")")
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>LÖnh bµi qu¶n lý tÝnh n¨ng vµ ho¹t ®éng.<color>\n"
    return szDesc
end