----------------------------------------------------------------------------------------------------
--										 Héi Qu¸n LÖnh Bµi										  --
----------------------------------------------------------------------------------------------------
function main(itemIdx)
	Say("Mét trong c¸c lo¹i ThÇn LÖnh thuéc <color=green>Héi Qu¸n Vâ L©m<color>")
	return 1
end

function GetDesc(itemIdx)
	local _,_,detail = GetItemProp(itemIdx)
	-- Vâ L©m LÖnh
	if(detail == 4905) then
		return "<color=water>Dïng ®Ó trao ®æi vËt phÈm.\nGÆp <color=orange>Vò TuyÖt ThÇn<color> t¹i <color=green>Héi Qu¸n Vâ L©m<color> ®Ó trao ®æi vËt phÈm.<color>"
	end
	-- Tèng Kim LÖnh
	if(detail == 4906) then
		return "<color=water>Cã thÓ dïng ®Ó n©ng cÊp vËt phÈm.\nGÆp <color=orange>Thiªn DiÖn Qu©n<color> t¹i <color=green>Héi Qu¸n Vâ L©m<color> ®Ó n©ng cÊp MÆt N¹.<color>"
	end
	-- Phong Háa LÖnh
	if(detail == 4907) then
		return "<color=water>Cã thÓ dïng ®Ó n©ng cÊp hoÆc trao ®æi vËt phÈm.\nGÆp <color=orange>Thiªn DiÖn Qu©n<color> t¹i <color=green>Héi Qu¸n Vâ L©m<color> ®Ó n©ng cÊp MÆt N¹.\nGÆp <color=orange>Ngù Phong Háa<color> t¹i <color=green>Héi Qu¸n Vâ L©m<color> ®Ó trao ®æi vËt phÈm.<color>"
	end
	-- Hoµng Kim LÖnh
	if(detail == 4908) then
		return "<color=water>Cã thÓ dïng ®Ó n©ng cÊp hoÆc trao ®æi vËt phÈm quı gi¸.\nGÆp <color=orange>Ch©n Vò T«n<color> t¹i <color=green>Héi Qu¸n Vâ L©m<color> ®Ó biÕt thªm th«ng tin.<color>"
	end
	-- TuyÖt §Ønh LÖnh
	if(detail == 4959) then
		return "<color=water>Dïng ®Ó quy ®æi <color=orange>Vò Khİ TuyÖt §Ønh<color>.\nGÆp <color=orange>TuyÖt §Ønh Vò §Õ<color> t¹i <color=green>Héi Qu¸n Vâ L©m<color> ®Ó biÕt thªm th«ng tin.<color>"
	end
end