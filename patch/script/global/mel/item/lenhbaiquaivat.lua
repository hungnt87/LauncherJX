IncludeLib("NPCINFO")
Include("\\script\\dailogsys\\dailogsay.lua")

----------------------------------------------------------------------------------------------------
--										 LÖnh Bµi Qu¸i VËt										  --
----------------------------------------------------------------------------------------------------
function main(nItemIndex)
    dofile("script/global/mel/item/lenhbaiquaivat.lua")
    local szThongTin = format("B¹n cã muèn t¹o qu¸i kh«ng?")
    local tbSay = {szThongTin}
		tinsert(tbSay, "T¹o b·i qu¸i/meltaobai")
		tinsert(tbSay, "Xãa b·i qu¸i/melxoabai")
		tinsert(tbSay, "KÕt thóc ®èi tho¹i./no")
    CreateTaskSay(tbSay)
    return 1
end

-- T¹o B·i Qu¸i
function meltaobai()
	local tbNpcList = GetAroundNpcList(60)
	local pW, pX, pY = GetWorldPos()
	local tmpFound = {}
	local nNpcIdx
	for i=1,getn(tbNpcList) do
		nNpcIdx = tbNpcList[i]
		local nSettingIdx = GetNpcSettingIdx(nNpcIdx)
		local name = GetNpcName(nNpcIdx)
		local level = NPCINFO_GetLevel(nNpcIdx)
		local kind = GetNpcKind(nNpcIdx)
		if nSettingIdx > 0 and kind == 0 then
			tinsert(tmpFound, {nSettingIdx, name, level})
		end
	end
	local total = getn(tmpFound)
	if total == 0 then
		return 0
	end
	local j = 0
	while j < 20 do
		local data = tmpFound[random(1, total)]
		local isBoss = 0
		if (j==10) then
			isBoss = 2
		end
		local nNpcIndex = AddNpcEx(data[1], data[3], random(0,4), SubWorldID2Idx(pW),(pX + random(-5,5)) * 32, (pY + random(-5,5)) * 32, 0, data[2] , isBoss)
		if nNpcIndex > 0 then
			j = j + 1
		end
	end
	return 0
end

-- Xãa B·i Qu¸i
function melxoabai()
    local tbNpcList = GetAroundNpcList(30)
    local pW, pX, pY = GetWorldPos()
    local tmpFound = {}
    local nNpcIdx
    for i=1,getn(tbNpcList) do
        nNpcIdx = tbNpcList[i]
        local kind = GetNpcKind(nNpcIdx)
        local nSettingIdx = GetNpcSettingIdx(nNpcIdx)
        local nNpcType = GetNpcPowerType(nNpcIdx)
        if nSettingIdx > 0 and kind == 0 and nNpcType ~= 3 then
            DelNpc(nNpcIdx)
        end
    end
    return 0
end

function GetDesc(nItemIndex)
	local szDesc = "<color=water>LÊy linh hån qu¸i vËt xung quanh b¶n ®å råi triÖu håi.<color>\n"
	szDesc = szDesc.."<color=water>Qu¸i vËt triÖu håi cã thÓ xãa bá b»ng c¸ch t¸i kÝch ho¹t.<color>\n"
	return szDesc
end