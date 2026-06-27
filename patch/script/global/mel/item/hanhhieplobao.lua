Include("\\script\\global\\login_head.lua")

----------------------------------------------------------------------------------------------------
--										  Hµnh Hi÷p LÈ Bao								  		  --
----------------------------------------------------------------------------------------------------
function main(nItemIdx)
	local nDate = tonumber(GetLocalDate("%d"))
	if ( GetTask(DAY) ~= nDate ) then
		SetTask(DAY, nDate);
		SetTask(352,0);
		if (GetTask(352) <= 10000) then
			local k = random(1,100)
			SetTask(352,GetTask(352) + 1)
			if (k >= 95) then
				local x = random(1,100)
				if (x >= 90) then
					AddStackItem(4,4,2045,1,1,0,0,0)
					AddGlobalNews("ßπi hi÷p <color=green>"..GetName().."<color> mÎ Hµnh Hi÷p LÈ Bao , may mæn nhÀn Æ≠Óc <color=gold>2 Kim Loπi Hi’m<color> !")
					Msg2Player("MÎ Hµnh Hi÷p LÈ Bao, nhÀn Æ≠Óc 4 Kim Loπi Hi’m")
				else
					AddStackItem(2,4,2045,1,1,0,0,0)
					AddGlobalNews("ßπi hi÷p <color=green>"..GetName().."<color> mÎ Hµnh Hi÷p LÈ Bao , may mæn nhÀn Æ≠Óc <color=gold>Kim Loπi Hi’m<color> !")
					Msg2Player("MÎ Hµnh Hi÷p LÈ Bao, nhÀn Æ≠Óc 2 Kim Loπi Hi’m")
				end
			elseif (k >=40) then
				local m = random (15,60)
				n = GetLevel()
				AddOwnExp(n*m*200)
			else
				Earn(50000)
			end
		else
			Talk(1,"","<color=green>H´m nay Æ∑ mÎ ÆÒ 10000 Hµnh Hi÷p LÈ Bao rÂi, ngµy mai h∑y mÎ ti’p<color>")
		end
	else
		if (GetTask(352) <= 10000) then
			local k = random(1,100)
			SetTask(352,GetTask(352) + 1)
			if (k >= 95) then
				local x = random(1,100)
				if (x >= 90) then
					AddStackItem(4,4,2045,1,1,0,0,0)
					AddGlobalNews("ßπi hi÷p <color=green>"..GetName().."<color> mÎ Hµnh Hi÷p LÈ Bao , may mæn nhÀn Æ≠Óc <color=gold>2 Kim Loπi Hi’m<color> !")
					Msg2Player("MÎ Hµnh Hi÷p LÈ Bao, nhÀn Æ≠Óc 4 Kim Loπi Hi’m")
				else
					AddStackItem(2,4,2045,1,1,0,0,0)
					AddGlobalNews("ßπi hi÷p <color=green>"..GetName().."<color> mÎ Hµnh Hi÷p LÈ Bao , may mæn nhÀn Æ≠Óc <color=gold>Kim Loπi Hi’m<color> !")
					Msg2Player("MÎ Hµnh Hi÷p LÈ Bao, nhÀn Æ≠Óc 2 Kim Loπi Hi’m")
				end
			elseif (k >=40) then
				local m = random (5,45)
				n = GetLevel()
				AddOwnExp(n*m*200)
			else
				Earn(70000)
			end
		else
			Talk(1,"","<color=green>H´m nay Æ∑ mÎ ÆÒ 10000 Hµnh Hi÷p LÈ Bao rÂi, ngµy mai h∑y mÎ ti’p<color>")
		end
	end
end

function GetDesc(nItemIdx)
	local szDesc = "<color=water>Loπi vÀt ph»m c„ Æ≠Óc tı luy÷n c´ng.<color>\n"
    szDesc = szDesc.."<color=water>MÎ ra c„ tÿ l÷ nhÀn Æ≠Óc <color><color=yellow>Kim Loπi Hi’m<color>\n"
    return szDesc
end