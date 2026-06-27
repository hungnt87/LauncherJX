IncludeLib("SETTING")

----------------------------------------------------------------------------------------------------
--										TuyÖt §Ønh Tiªn §¬n										  --
----------------------------------------------------------------------------------------------------
function main(nItemIdx)
    AddSkillState(1216, 1, 1, 64800 * 8, 1)
    Msg2Player("Sö dông thµnh c«ng <color=green>TuyÖt §Ønh Tiªn §¬n<color>.")
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>VËt phÈm t¨ng kinh nghiÖm, cã thÓ dïng chung c¸c lo¹i:<color>\n"
    szDesc = szDesc.."<color=orange>Tiªn Th¶o Lé<color>\n"
    szDesc = szDesc.."<color=orange>Héi Qu¸n Linh D­îc Lé<color>\n"
    szDesc = szDesc.."<color=orange>TuyÖt §Ønh Tiªn §¬n<color>"
    return szDesc
end