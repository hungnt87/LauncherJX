IncludeLib("SETTING")
Include("\\script\\lib\\common.lua")
Include("\\script\\dailogsys\\dailogsay.lua")
Include("\\script\\activitysys\\functionlib.lua")
Include("\\script\\activitysys\\playerfunlib.lua")

----------------------------------------------------------------------------------------------------
--								  LÖnh Bµi Boss Hoµng Kim ChØ §Þnh								  --
----------------------------------------------------------------------------------------------------
function main()
	local szTitle = format("Xin chµo")
	local tbOption = {}
		tinsert(tbOption, {"Gäi Boss Hoµng Kim", GoiBossHoangKim})	
		tinsert(tbOption, {"§ãng."})
	CreateNewSayEx(szTitle, tbOption)
end

function GoiBossHoangKim()
	BossHK(f_bossx,f_bossy)
end

TBBOSS  = {
	[1] =	{szName = "HuyÒn Gi¸c §¹i S­",		nBossId = 740,	nRate = 322, nSeries = 0, nLevel = 95},
	[2] =	{szName = "§­êng BÊt NhiÔm",		nBossId = 741,	nRate = 336, nSeries = 1, nLevel = 95},
	[3] =	{szName = "B¹ch Doanh Doanh",		nBossId = 742,	nRate = 336, nSeries = 1, nLevel = 95},
	[4] =	{szName = "Thanh TuyÖt S­ Th¸i",	nBossId = 743,	nRate = 341, nSeries = 2, nLevel = 95},
	[5] =	{szName = "Yªn HiÓu Tr¸i",			nBossId = 744,	nRate = 336, nSeries = 2, nLevel = 95},
	[6] =	{szName = "Hµ Nh©n Ng·",			nBossId = 745,	nRate = 321, nSeries = 3, nLevel = 95},
	[7] =	{szName = "Tõ §¹i Nh¹c",			nBossId = 1367,	nRate = 341, nSeries = 4, nLevel = 95},
	[8] =	{szName = "TuyÒn C¬ Tö",			nBossId = 747,	nRate = 341, nSeries = 4, nLevel = 95},
	[9] =	{szName = "Thanh Liªn Tö",			nBossId = 1368,	nRate = 200, nSeries = 4, nLevel = 95},
	[10] =	{szName = "§oan Méc DuÖ",			nBossId = 565,	nRate = 227, nSeries = 3, nLevel = 95},
	[11] =	{szName = "Cæ B¸ch",				nBossId = 566,	nRate = 200, nSeries = 0, nLevel = 95},
	[12] =	{szName = "§­êng Phi YÕn",			nBossId = 1366,	nRate = 200, nSeries = 1, nLevel = 95},	
	[13] =	{szName = "Hµ Linh Phiªu",			nBossId = 568,	nRate = 200, nSeries = 2, nLevel = 95},
	[14] =	{szName = "Lam Y Y",				nBossId = 582,	nRate = 200, nSeries = 1, nLevel = 95},
	[15] =	{szName = "M¹nh Th­¬ng L­¬ng",		nBossId = 583,	nRate = 200, nSeries = 3, nLevel = 95},
	[16] =	{szName = "Gia LuËt TÞ Ly",			nBossId = 563,	nRate = 200, nSeries = 3, nLevel = 95},
	[17] =	{szName = "§¹o Thanh Ch©n Nh©n",	nBossId = 562,	nRate = 200, nSeries = 4, nLevel = 95},
	[18] =	{szName = "V­¬ng T¸",				nBossId = 739,	nRate = 200, nSeries = 0, nLevel = 95},
	[19] =	{szName = "HuyÒn Nan §¹i S­",		nBossId = 1365,	nRate = 200, nSeries = 0, nLevel = 95},
	[20] =	{szName = "Chung Linh Tó",			nBossId = 567,	nRate = 200, nSeries = 2, nLevel = 95},
}

function BossHK(f_bossx,f_bossy)
	if (not f_bossx) then
		f_bossx1 = 1
		f_bossy1 = 12
	else
		f_bossx1 = f_bossx
		f_bossy1 = f_bossy
	end
	if (f_bossy1 - f_bossx1 > 11) then
		f_bossy1 = f_bossx1 + 11
	end
	local n_count = getn(TBBOSS)
	local tb = {}
	tb = {GetName().." b¹n muèn th¶ boss nµo?"}
	for i = f_bossx1, f_bossy1 do
		tinsert(tb,format("%s/#PickBoss(%d)",TBBOSS[i].szName,i))
	end
	if (f_bossx1 ~= 1) then
		tinsert(tb, "Trang tr­íc/#BossHK( 1,"..(f_bossx1-1)..")")
	end
	if (f_bossy1 < n_count) then
		tinsert(tb, "Trang sau/#BossHK( "..(f_bossy1+1)..","..n_count..")")
	end
	tinsert(tb,"§Ó ta suy nghÜ ®·/cancel")
	CreateTaskSay(tb)
end

function PickBoss(nIndex)
	if GetFightState() == 0 then 
		Talk(1,"","Kh«ng thÓ th¶ boss ë nh÷ng n¬i phi chiÕn ®Êu ®­îc.")
		return 
	end
	local item = TBBOSS[nIndex]
	local nw,nx,ny = GetWorldPos()
	local index = AddNpcEx(item.nBossId,item.nLevel,item.nSeries,SubWorldID2Idx(nw),nx*32,ny*32,1,item.szName,1);
	SetNpcDeathScript(index,"\\script\\global\\pgaming\\missions\\bosshoangkim\\bossdai\\goldboss_death.lua")		
	SetNpcParam(index,1,item.nBossId) --l­u id boss.
	SetNpcTimer(index,120*60*18)
	local W,X,Y = GetWorldPos()
	str = format("<color=yellow>%s<color> ®· xuÊt hiÖn t¹i <color=yellow>%s(%d,%d)<color>",item.szName,SubWorldName(SubWorld),floor(X/8),floor((Y+5)/16))
	local handle = OB_Create();
	ObjBuffer:PushObject(handle, str)
	RemoteExecute("\\script\\event\\msg2allworld.lua", "broadcast", handle)
	OB_Release(handle)
end

function cancel()
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>Lùa chän gäi ra<color>\n"
    szDesc = szDesc.."<color=orange>Boss §¹i Hoµng Kim<color>"
    return szDesc
end