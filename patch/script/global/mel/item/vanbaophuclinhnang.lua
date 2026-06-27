IncludeLib("ITEM")
Include("\\script\\dailogsys\\dailogsay.lua")

----------------------------------------------------------------------------------------------------
--									   V¹n B¶o Phôc Linh Nang									  --
----------------------------------------------------------------------------------------------------
function main(nItemIndex)
    dofile("script/global/mel/item/vanbaophuclinhnang.lua")
    local szThongTin = format("<color=green>Linh khÝ cña Trêi vµ §Êt<color>")
    local tbSay = {szThongTin}
		tinsert(tbSay, "LÊy m¸u theo sè l­îng/muamau")
		tinsert(tbSay, "LÊy m¸u ®Çy r­¬ng/muamaufull")
		tinsert(tbSay, "KÕt thóc ®èi tho¹i./no")
    CreateTaskSay(tbSay)
    return 1
end

function muamau()
	local totalcount =CalcFreeItemCellCount()
	AskClientForNumber("muamau1",0,totalcount, "3000/1: ")
end

function muamau1(n_key)
	if n_key*3000 > GetCash() then
		Talk(1,"","Kh«ng ®ñ ng©n l­îng")
		return 1
	end 
	for k=1,n_key do 		
	AddItem(1,2,0,5,0,0,0)
	Pay(3000)
	end
end

function muamaufull()
	local nJxb = 240000
	if GetCash() < nJxb then
		Msg2Player(format("CÇn Ýt nhÊt 18 v¹n trong r­¬ng",nJxb))
		return
	end
	local totalcount =CalcFreeItemCellCount()
	if totalcount == 0 then 
        Say("<color=yellow>§¹i hiÖp ®· cã ®Çy r­¬ng m¸u.",0)
		return
	end	
	for k=1,totalcount do 		
	AddItem(1,2,0,5,0,0,0)
	Pay(3000)
	end
end

function GetDesc(nItemIndex)
	local szDesc = "<color=water>Dïng ng©n l­îng ®Ó trao ®æi lÊy m¸u tõ trong tói<color>\n"
	szDesc = szDesc.."<color=water>Gi¸ 1 b×nh m¸u lµ <color=orange>3000 l­îng<color><color>\n"
	szDesc = szDesc.."<color=water>Lo¹i m¸u sau khi lÊy lµ <color=orange>Ngò Hoa Ngéc Lé Hoµn<color><color>"
	return szDesc
end