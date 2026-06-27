IncludeLib("SETTING")

----------------------------------------------------------------------------------------------------
--										Qu’ Hoa Tˆu ß∆c Bi÷t									  --
----------------------------------------------------------------------------------------------------
function main()
	local nPreservedPlayerIndex = PlayerIndex
	local nMemCount = GetTeamSize()
	if (nMemCount == 0 ) then
		AddSkillState(450, 20, 1, 64800 * 8,1)
		return 0
	end
	for i = 1, nMemCount do
		PlayerIndex = GetTeamMember( i )
		AddSkillState(450, 20, 1, 64800 * 8,1)
	end
	PlayerIndex = nPreservedPlayerIndex
	return 0
end

function GetDesc(nItemIdx)
    local szDesc = "<color=water>Trong 8 ti’ng:<color>\n"
    szDesc = szDesc.."<color=water>T®ng <color=orange>20 Æi”m May Mæn<color> cho toµn ÆÈi!<color>"
    return szDesc
end