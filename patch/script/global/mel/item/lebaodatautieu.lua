IncludeLib("ITEM")
Include("\\script\\lib\\awardtemplet.lua")

function main(nItemIdx)
    local nRand = random(1, 100)
    if (nRand <= 30) then
        tbAwardTemplet:GiveAwardByList({tbProp = {4,2045}, nCount = 50}, "Kim Loπi Hi’m", 1)
        Msg2Player("Bπn mÎ L‘ Bao D∑ T»u nhÀn Æ≠Óc 50 Kim Loπi Hi’m.")
    elseif (nRand <= 60) then
        tbAwardTemplet:GiveAwardByList({tbProp = {4,417}, nCount = 100}, "Ti“n ßÂng", 1)
        Msg2Player("Bπn mÎ L‘ Bao D∑ T»u nhÀn Æ≠Óc 100 Ti“n ßÂng.")
    elseif (nRand <= 90) then
        SetTask(747, GetTask(747) + 30000)
        Msg2Player("Bπn Æ∑ nhÀn Æ≠Óc th™m <color=green>30000<color> Æi”m t›ch lÚy TËng Kim!")
    else
        tbAwardTemplet:GiveAwardByList({tbProp = {6,1,4908,0,0,0}, nCount = 5}, "Hoµng Kim L÷nh", 1)
        Msg2Player("ThÀt may mæn! Bπn nhÀn Æ≠Óc 5 Hoµng Kim L÷nh.")
        Msg2SubWorld("<color=green>"..GetName().."<color> mÎ L‘ Bao D∑ T»u nhÀn Æ≠Óc <color=gold>5 Hoµng Kim L÷nh<color>!")
    end
    return 0
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>L‘ bao ph«n th≠Îng tı <color=green>D∑ T»u<color><color>\n"
    szDesc = szDesc.."<color=water>MÎ ra c„ tÿ l÷:\n"
    szDesc = szDesc.."<color=water><color=yellow>30%<color> nhÀn Æ≠Óc <color><color=yellow>50 Kim Loπi Hi’m<color>\n"
    szDesc = szDesc.."<color=water><color=yellow>30%<color> nhÀn Æ≠Óc <color><color=yellow>100 Ti“n ßÂng<color>\n"
    szDesc = szDesc.."<color=water><color=yellow>30%<color> nhÀn Æ≠Óc <color><color=yellow>30.000 Æi”m TËng Kim<color>\n"
    szDesc = szDesc.."<color=water><color=orange>10%<color> nhÀn Æ≠Óc <color><color=orange>5 Hoµng Kim L÷nh<color>"
    return szDesc
end