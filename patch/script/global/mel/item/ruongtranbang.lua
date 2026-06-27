IncludeLib("ITEM")
Include("\\script\\lib\\awardtemplet.lua")
Include("\\script\\lib\\log.lua")
Include("\\script\\lib\\progressbar.lua")

----------------------------------------------------------------------------------------------------
--                                       R­¬ng TrÊn Bang Chi B¶o                                  --
----------------------------------------------------------------------------------------------------
tbAwardTranBang = {
    {769, "[TrÊn Bang Chi B¶o] Méng Long Tö Kim B¸t Nh· Giíi"},
    {771, "[TrÊn Bang Chi B¶o] Phôc Ma V« L­îng Kim Cang UyÓn"},
    {776, "[TrÊn Bang Chi B¶o] Tø Kh«ng §¹t Ma T¨ng Hµi"},
    {793, "[TrÊn Bang Chi B¶o] Ngù Long TÊn Phong Ph¸t C¬"},
    {796, "[TrÊn Bang Chi B¶o] V« Gian Thanh Phong NhuyÔn KÞch"},
    {801, "[TrÊn Bang Chi B¶o] V« YÓm Thu Thñy L­u Quang §¸i"},
    {808, "[TrÊn Bang Chi B¶o] V« TrÇn TÞnh ¶nh L­u T«"},
    {811, "[TrÊn Bang Chi B¶o] Thª Hoµng HuÖ T©m Tr­êng Sinh KhÊu"},
    {816, "[TrÊn Bang Chi B¶o] BÝch H¶i Hoµn Ch©u Tuyªn Thanh C©n"},
    {829, "[TrÊn Bang Chi B¶o] Minh Hoan Song Hoµn Xµ KhÊu"},
    {834, "[TrÊn Bang Chi B¶o] Chó Phäc Trïng Cèt Ngäc Béi"},
    {843, "[TrÊn Bang Chi B¶o] Thiªn Quang §Þa Hµnh Thiªn Lý Ngoa"},
    {854, "[TrÊn Bang Chi B¶o] §Þa Ph¸ch Phong Hµn Thóc Yªu"},
    {855, "[TrÊn Bang Chi B¶o] §ång Cõu Ngù Long Ngäc Béi"},
    {868, "[TrÊn Bang Chi B¶o] Ma S¸t Cö Háa Liªu Thiªn Hoµn"},
    {874, "[TrÊn Bang Chi B¶o] Ma Hoµng Dung Kim §o¹n NhËt Giíi"},
    {876, "[TrÊn Bang Chi B¶o] Ma ThÞ LÖ Ma PhÖ T©m §¸i"},
    {881, "[TrÊn Bang Chi B¶o] L¨ng Nh¹c V« Ng· Thóc §¸i"},
    {888, "[TrÊn Bang Chi B¶o] CËp Phong Thóy Ngäc HuyÒn Hoµng UyÓn"},
    {891, "[TrÊn Bang Chi B¶o] S­¬ng Tinh L­u Tinh C¶n NguyÖt KhÊu"},
    {898, "[TrÊn Bang Chi B¶o] L«i Khung Linh Ngäc Èn L«i UyÓn"},
    {901, "[TrÊn Bang Chi B¶o] Vô Hoan Th¸i Uyªn Ch©n Vò Liªn"}
}

local _GetFruit = function(nItemIndex)
    if ConsumeItem(3, 1, 6, 1, 4889, -1) ~= 1 then
        Talk(1, "", "CÇn <color=green>Ch×a Khãa Hoµng Kim<color> míi më ®­îc <color=yellow>R­¬ng TrÊn Bang<color>");
        return
    end
    RemoveItemByIndex(nItemIndex)
    local nSize = getn(%tbAwardTranBang)
    local nRand = random(1, nSize)
    local nGoldID = %tbAwardTranBang[nRand][1]
    local szRealName = %tbAwardTranBang[nRand][2]
    local pIdx = AddGoldItem(0, nGoldID)
    if (pIdx > 0) then
        --SetItemBindState(pIdx, -2)
        SyncItem(pIdx)
        local msg = format("Chóc mõng <color=green>%s<color> më <color=yellow>R­¬ng TrÊn Bang<color> nhËn ®­îc <color=yellow>%s<color>", GetName(), szRealName)
        Msg2Player("B¹n nhËn ®­îc: "..szRealName.." (Khãa vÜnh viÔn)")
        Msg2SubWorld(msg)
        AddGlobalNews(msg)
    else
        Msg2Player("Lçi: Kh«ng thÓ trao vËt phÈm ID "..nGoldID)
    end
end

local _OnBreak = function()
    Msg2Player("Më r­¬ng gi¸n ®o¹n!")
end

function main(nItemIndex)
    dofile("script/global/mel/item/ruongtranbang.lua")
    local nExPiredTime = ITEM_GetExpiredTime(nItemIndex)
    if nExPiredTime ~= 0 and (nExPiredTime - GetCurServerTime()) <= 60 then
        Msg2Player("VËt phÈm ®· qu¸ h¹n sö dông")
        return 0
    end
    if CalcFreeItemCellCount() < 40 then
        Talk(1, "", "Xin h·y s¾p xÕp l¹i hµnh trang! Nhí ®Ó trèng 40 « trë lªn nhÐ.")
        return 1
    end
    if CalcItemCount(3, 6, 1, 4889, -1) >= 1 then
        tbProgressBar:OpenByConfig(11, %_GetFruit, {nItemIndex}, %_OnBreak)
    else
        Talk(1, "", "CÇn <color=green>Ch×a Khãa Hoµng Kim<color> míi më ®­îc <color=yellow>R­¬ng TrÊn Bang Chi B¶o<color>")
        return 1
    end
    return 1
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>B¶o r­¬ng TrÊn Bang hiÕm cã, vâ c«ng cao c­êng míi së h÷u ®­îc.<color>\n"
    szDesc = szDesc.."<color=water>Më ra cã tØ lÖ ngÉu nhiªn nhËn ®­îc ®å <color><color=yellow>TrÊn Bang Chi B¶o<color>\n"
    return szDesc
end