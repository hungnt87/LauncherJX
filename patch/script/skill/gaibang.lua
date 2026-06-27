function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										  Kü n¨ng C¸i Bang										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	gaibang_bangfa={ -- C¸i Bang Bæng Ph¸p - Hç trî Bæng 10
		addphysicsdamage_p={{{1,10},{20,200}},{{1,-1},{2,-1}},{{1,2},{2,2}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,2},{20,45,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	gaibang_zhangfa={ -- C¸i Bang Ch­ëng Ph¸p - Hç trî Ch­ëng 10
		addfiremagic_v={{{1,25},{20,475}},{{1,-1},{2,-1}}} -- Háa s¸t - néi c«ng
	},

	yanmen_tuobo={ -- Diªn M«n Th¸c B¸t - Bæng 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,10},{20,55}}}, -- S¸t th­¬ng vËt lý %
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,150}}
		},
		addskilldamage1={ -- % Kü n¨ng Thiªn H¹ V« CÈu - Bæng 90
			[1]={{1,359},{2,359}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage2={ -- % Kü n¨ng Bæng §¶ ¸c CÈu - Bæng 50
			[1]={{1,125},{2,125}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,10}}} -- Tiªu hao néi lùc
	},

	jianren_shenshou={ -- KiÕn Nh©n ThÇn Thñ - Ch­ëng 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,15},{20,75}},
			[3]={{1,15},{20,215}}
		},
		addskilldamage1={ -- % Kü n¨ng Phi Long T¹i Thiªn - Ch­ëng 90
			[1]={{1,357},{2,357}},
			[3]={{1,1},{20,150}}
		},
		addskilldamage2={ -- % Kü n¨ng Kh¸ng Long H÷u Hèi - Ch­ëng 50
			[1]={{1,128},{2,128}},
			[3]={{1,1},{20,50}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,25},{20,25}}} -- Tiªu hao néi lùc
	},

	huabu_liushou={ -- Ho¹t BÊt L­u Thñ - Hç trî chñ ®éng 40
		fastwalkrun_p={{{1,9},{20,66}},{{1,18*120},{20,18*180}}}, -- Tèc ®é di chuyÓn %
		skill_cost_v={{{1,24},{20,50}}} -- Tiªu hao néi lùc
	},

	dagou_zhen={ -- §¶ CÈu Bæng - Hç trî bÞ ®éng 30
		addphysicsdamage_p={{{1,10},{20,175}},{{1,-1},{30,-1}},{{1,2},{2,2}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
	},

	xianglong_zhang={ -- Gi¸ng Long Ch­ëng - Hç trî bÞ ®éng 30
		lifemax_p={{{1,1},{20,20}},{{1,-1},{2,-1}}}, -- Sinh lùc tèi ®a %
		manamax_p={{{1,2},{20,40}},{{1,-1},{2,-1}}}, -- Néi lùc tèi ®a %
		addfiremagic_v={{{1,35},{15,250},{20,950}},{{1,-1},{2,-1}}}, -- Háa s¸t - néi c«ng
	},

	bangda_egou={ -- Bæng §¶ ¸c CÈu - Bæng 50
		physicsenhance_p={{{1,10},{20,179}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,70},{20,360}},
			[3]={{1,70},{20,420}}
		},
		addskilldamage1={ -- % Kü n¨ng Thiªn H¹ V« CÈu - Bæng 90
			[1]={{1,359},{2,359}},
			[3]={{1,1},{20,120}}
		},
		missle_speed_v={{{1,28},{20,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,28},{20,48}}} -- Tiªu hao néi lùc
	},

	zuidie_kuangwu={ -- Tóy §iÖp Cuång Vò - TrÊn ph¸i 60
		allres_p={{{1,1},{30,30}},{{1,18*120},{30,18*180}}}, -- Kh¸ng tÊt c¶ %
		addfiremagic_v={{{1,10},{30,315}},{{1,18*120},{30,18*180}}}, -- Háa s¸t - néi c«ng
		addfiredamage_v={{{1,10},{30,175}},{{1,18*120},{30,18*180}}}, -- Háa s¸t - ngo¹i c«ng
		deadlystrikeenhance_p={{{1,5},{20,30,Conic}},{{1,18*120},{30,18*180}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		returnres_p={{{1,5},{30,30}},{{1,18*120},{30,18*180}}}, -- Kh¸ng ph¶n ®ßn %
		skill_cost_v={{{1,50},{20,100}}} -- Tiªu hao néi lùc
	},

	kanglong_youhui={ -- Kh¸ng Long H÷u Hèi - Ch­ëng 50
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{20,536}},
			[3]={{1,10},{20,536}}
		},
		addskilldamage1={ -- % Kü n¨ng Phi Long T¹i Thiªn - Ch­ëng 90
			[1]={{1,357},{2,357}},
			[3]={{1,1},{20,105}}
		},
		skill_misslesform_v={{{1,1},{10,1},{10,2},{20,2}}}, -- H×nh thøc Missle
		skill_misslenum_v={{{1,1},{10,1},{20,15},{25,18},{26,18}}}, -- Sè l­îng Missle
		skill_param1_v={{{1,0},{10,0},{10,2},{20,2},{21,2}}}, -- Th«ng sè kü n¨ng
		missle_speed_v={{{1,28},{20,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,50}}} -- Tiªu hao néi lùc
	},

	huaxian_weiyi={ -- Hãa HiÓm Vi Di - Hç trî bÞ ®éng 20
		meleedamagereturn_p={{{1,4},{20,46}},{{1,-1},{20,-1}}}, -- Ph¶n ®ßn cËn chiÕn %
		rangedamagereturn_p={{{1,4},{20,46}},{{1,-1},{20,-1}}}, -- Ph¶n ®ßn tÇm xa %
		adddefense_v={{{1,48},{20,800}},{{1,-1},{20,-1}}}, -- NÐ tr¸nh
	},

	xiaoyao_gong={ -- Tiªu Diªu C«ng - Hç trî bÞ ®éng 60
		attackspeed_v={{{1,6},{20,65},{25,90},{31,108},{32,118},{33,121}},{{1,-1},{20,-1}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
		castspeed_v={{{1,6},{20,65},{25,90},{31,108},{32,118},{33,121}},{{1,-1},{2,-1}}}, -- Tèc ®é ®¸nh - néi c«ng %
		addphysicsdamage_p={{{1,5},{20,100}},{{1,-1},{2,-1}},{{1,2},{2,2}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
	},

	philongtaithien_new={ -- Phi Long T¹i Thiªn (New) - Ch­ëng 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{15,400},{20,1050}},
			[3]={{1,10},{15,400},{20,1050}}
		},
		missle_speed_v={{{1,24},{20,40},{21,40}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_misslenum_v={{{1,1},{11,1},{12,2},{15,2},{16,2},{20,3},{21,3}}}, -- Sè l­îng Missle
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,65}}}, -- Tiªu hao néi lùc
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(8600,1.15,1,1,1)},
				{2,SkillExpFunc(8600,1.15,2,1,1)},
				{3,SkillExpFunc(8600,1.16,3,1,1)},
				{4,SkillExpFunc(8600,1.17,4,1,1)},
				{5,SkillExpFunc(8600,1.18,5,1,1)},
				{6,SkillExpFunc(8600,1.19,6,2,1)},
				{7,SkillExpFunc(8600,1.20,7,2,1)},
				{8,SkillExpFunc(8600,1.21,8,2,1)},
				{9,SkillExpFunc(8600,1.22,9,2,1)},
				{10,SkillExpFunc(8600,1.23,10,2,1)},
				{11,SkillExpFunc(8600,1.24,11,2,1)},
				{12,SkillExpFunc(8600,1.23,12,2,1)},
				{13,SkillExpFunc(8600,1.22,13,2,1)},
				{14,SkillExpFunc(8600,1.21,14,2,1)},
				{15,SkillExpFunc(8600,1.20,15,3,1)},
				{16,SkillExpFunc(8600,1.19,16,3,1)},
				{17,SkillExpFunc(8600,1.18,17,3,1)},
				{18,SkillExpFunc(8600,1.17,18,3,1)},
				{19,SkillExpFunc(8600,1.16,19,3,1)},
				{20,SkillExpFunc(8600,1.15,20,4,1)},
			}
		},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_startevent={ -- Kü n¨ng tÇng 2: TuyÖt §Ønh Phi Long
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1246},{20,1246}}
		},
		skill_collideevent={ -- Kü n¨ng tÇng 3: TuyÖt §Ønh Ngò DiÖu
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1247},{20,1247}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}}, -- Kü n¨ng tÇng 2-3
	},

	tuyetdinhngudieu={ -- TuyÖt §Ønh Ngò DiÖu
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,20},{20,400}},
			[3]={{1,20},{20,400}}
		},
	},

	tuyetdinhphilong={ -- TuyÖt §Ønh Phi Long
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{15,300},{20,850}},
			[3]={{1,10},{15,300},{20,850}}
		},
		missle_speed_v={{{1,24},{20,28},{21,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_misslenum_v={{{1,1},{9,1},{10,2},{19,2},{20,3},{21,3}}}, -- Sè l­îng Missle
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
	},

	zhanggaibang150={ -- Kü n¨ng 150 - Ch­ëng
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		firedamage_v={
			[1]={{1,24},{15,720},{20,1800},{23,3096},{26,3744}},
			[3]={{1,24},{15,720},{20,1800},{23,3096},{26,3744}}
		},
		missle_speed_v={{{1,24},{20,40},{21,40}}},
		skill_misslenum_v={{{1,1},{11,1},{12,2},{15,2},{16,2},{20,3},{21,3}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,12},{20,78},{23,98}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1072},{20,1072}}
		},
		skill_showevent={{{1,0},{10,0},{10,4},{20,4}}},
		skill_skillexp_v={
			{
				{1,300},
				{2,600},
				{3,1000},
				{4,1500},
				{5,2100},
				{6,2800},
				{7,3600},
				{8,4500},
				{9,5500},
				{10,6600},
				{11,7800},
				{12,9100},
				{13,10500},
				{14,12000},
				{15,13600},
				{16,15300},
				{17,17100},
				{18,19000},
				{19,21400},
				{20,21000},
			}
		},	
	},

	longzhan_yuye={ -- Long ChiÕn ¦ D· - TÇng 2 Phi Long T¹i Thiªn - Ch­ëng 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,17},{20,371}},
			[3]={{1,17},{20,371}}
		},
	},

	zhanggaibang150_2={ -- TÇng 2 Kü n¨ng 150 - Ch­ëng
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		firedamage_v={
			[1]={{1,20},{20,450},{23,585},{26,653}},
			[3]={{1,20},{20,450},{23,585},{26,653}}
		},
	},

	tianxia_wugou={ -- Thiªn H¹ V« CÈu - Bæng 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		skill_misslenum_v={{{1,1},{20,3},{21,3},{29,3},{30,4},{31,4}}}, -- Sè l­îng Missle
		physicsenhance_p={{{1,12},{15,90},{20,180}}}, -- S¸t th­¬ng vËt lý %
		firedamage_v={ -- Háa s¸t
			[1]={{1,70},{15,150},{20,285}},
			[3]={{1,70},{15,200},{20,432}}
		},
		missle_speed_v={{{1,20},{20,24},{21,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,50}}}, -- Tiªu hao néi lùc
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(7000,1.15,1,1,1)},
				{2,SkillExpFunc(7000,1.15,2,1,1)},
				{3,SkillExpFunc(7000,1.16,3,1,1)},
				{4,SkillExpFunc(7000,1.17,4,1,1)},
				{5,SkillExpFunc(7000,1.18,5,1,1)},
				{6,SkillExpFunc(7000,1.19,6,1,1)},
				{7,SkillExpFunc(7000,1.20,7,1,1)},
				{8,SkillExpFunc(7000,1.21,8,1,1)},
				{9,SkillExpFunc(7000,1.22,9,1,1)},
				{10,SkillExpFunc(7000,1.23,10,1,1)},
				{11,SkillExpFunc(7000,1.24,11,1,1)},
				{12,SkillExpFunc(7000,1.23,12,1,1)},
				{13,SkillExpFunc(7000,1.22,13,1,1)},
				{14,SkillExpFunc(7000,1.21,14,2,1)},
				{15,SkillExpFunc(7000,1.20,15,2,1)},
				{16,SkillExpFunc(7000,1.19,16,2,1)},
				{17,SkillExpFunc(7000,1.18,17,3,1)},
				{18,SkillExpFunc(7000,1.17,18,3,1)},
				{19,SkillExpFunc(7000,1.16,19,3,1)},
				{20,SkillExpFunc(7000,1.15,20,3,1)},
			}
		},
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: TuyÖt §Ønh §¶ CÈu
		skill_startevent={ -- Kü n¨ng tÇng 2: TuyÖt §Ønh §¶ CÈu
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1250},{20,1250}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{20,1}}}, -- Kü n¨ng tÇng 2: TuyÖt §Ønh §¶ CÈu
	},

	gungaibang150={ -- Kü n¨ng 150 - Bæng
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		skill_misslenum_v={{{1,1},{20,5},{21,5}}},
		physicsenhance_p={{{1,10},{15,80},{20,165},{23,267},{26,318}}},
		firedamage_v={
			[1]={{1,60},{15,120},{20,230},{23,362},{26,428}},
			[3]={{1,60},{15,160},{20,345},{23,567},{26,678}}
		},
		missle_speed_v={{{1,24},{20,24},{21,24}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,20},{20,50},{23,59}}},
		skill_skillexp_v={
			{
				{1,300},
				{2,600},
				{3,1000},
				{4,1500},
				{5,2100},
				{6,2800},
				{7,3600},
				{8,4500},
				{9,5500},
				{10,6600},
				{11,7800},
				{12,9100},
				{13,10500},
				{14,12000},
				{15,13600},
				{16,15300},
				{17,17100},
				{18,19000},
				{19,21400},
				{20,21000},
			}
		},	
	},

	gaibang120={ -- Kü n¨ng 120: Hçn Thiªn KhÝ C«ng
		autoattackskill={{{1,720*256 + 1},{20,720*256 + 20},{21,720*256 + 21}},{{1,-1},{20,-1}},{{1,12*18*256 + 1},{15,12*18*256 + 5},{20,12*18*256 + 6},{21,12*18*256 + 6}}},
		skill_desc=
			function(level)
				return "X¸c suÊt <color=orange>"..floor(Link(level,SKILLS.gaibang120.autoattackskill[3]) - 12*18*256).."%<color> g©y ho¹i th­¬ng \n"..
				"Ho¹i th­¬ng lµm gi¶m <color=orange>"..floor(-Link(level,SKILLS.gaibang120zuzhou.physicsres_p[1]))..
				"%<color> PTVL, gi¶m <color=orange>"..floor(-Link(level,SKILLS.gaibang120zuzhou.fireres_p[1]))..
				"%<color>,\n ®ång thêi lµm gi¶m gi¸ trÞ phßng thñ vËt lý lín nhÊt <color=orange>"..floor(-Link(level,SKILLS.gaibang120zuzhou.physicsresmax_p[1]))..
				"%<color>,gi¶m gi¸ trÞ phßng háa lín nhÊt <color=orange>"..floor(-Link(level,SKILLS.gaibang120zuzhou.fireresmax_p[1]))..
				"%<color> kh¸ng háa \n ®ång thêi ph¶n ®ßn khi bÞ tÊn c«ng tÇm xa gi¶m <color=orange>"..floor(-Link(level,SKILLS.gaibang120zuzhou.rangedamagereturn_p[1]))..
				"%<color> tèc ®é di chuyÓn trong <color=orange>"..floor(Link(level,SKILLS.gaibang120zuzhou.physicsres_p[2]) / 18).." gi©y<color>\n"..
				"Trong vßng <color=orange>"..floor((Link(level,SKILLS.gaibang120.autoattackskill[3]) / (18*256))).." gi©y<color> sau míi cã thÓ thi triÓn tiÕp"
			end,
		skill_skillexp_v={
			{
				{1,17851239},
				{2,19487603},
				{3,22760330},
				{4,27669421},
				{5,34214875},
				{6,42396694},
				{7,52214875},
				{8,63669421},
				{9,76760330},
				{10,91487603},
				{11,107851239},
				{12,135669421},
				{13,174942148},
				{14,225669421},
				{15,274418181},
				{16,344618181},
				{17,425738181},
				{18,517778181},
				{19,620738181},
				{20,620738181},
			}
		},	
	},

	gaibang120zuzhou={ -- Kü n¨ng 120: Hçn Thiªn KhÝ C«ng
		physicsres_p={{{1,-2},{15,-8},{20,-10},{21,-11}},{{1,3*18},{15,8*18},{20,9*18},{21,9*18}}}, -- Phßng thñ vËt lý %
		fireres_p={{{1,-3},{15,-12},{20,-15},{21,-16}},{{1,3*18},{15,8*18},{20,9*18},{21,9*18}}}, -- Kh¸ng háa %
		physicsresmax_p={{{1,-1},{15,-1},{20,-5},{21,-5}},{{1,3*18},{15,8*18},{20,9*18},{21,9*18}}}, -- Phßng thñ vËt lý tèi ®a %
		fireresmax_p={{{1,-1},{15,-2},{20,-5},{21,-5}},{{1,3*18},{15,8*18},{20,9*18},{21,9*18}}}, -- Kh¸ng háa tèi ®a %
		rangedamagereturn_p={{{1,-4},{15,-25},{20,-30},{21,-30}},{{1,3*18},{15,8*18},{20,9*18},{21,9*18}}}, -- Ph¶n ®ßn tÇm xa %
	},
}

----------------------------------------------------------------------------------------------------
function Line(x,x1,y1,x2,y2)
	if(x2==x1) then
		return y2
	end
	return (y2-y1)*(x-x1)/(x2-x1)+y1
end

function Conic(x,x1,y1,x2,y2)
	if((x1 < 0) or (x2<0))then 
		return 0
	end
	if(x2==x1) then
		return y2
	end
	return (y2-y1)*x*x/(x2*x2-x1*x1)-(y2-y1)*x1*x1/(x2*x2-x1*x1)+y1
end

function Extrac(x,x1,y1,x2,y2)
	if((x1 < 0) or (x2<0))then 
		return 0
	end
	if(x2==x1) then
		return y2
	end
	return (y2-y1)*(x-x1)/(x2-x1)+y1
end

function Link(x,points)
	num = getn(points)
	if(num<2) then
		return -1
	end
	for i=1,num do
		if(points[i][3]==nil) then
			points[i][3]=Line
		end
	end
	if(x < points[1][1]) then
		return points[1][3](x,points[1][1],points[1][2],points[2][1],points[2][2])
	end
	if(x > points[num][1]) then
		return points[num][3](x,points[num-1][1],points[num-1][2],points[num][1],points[num][2])
	end
	c = 2
	for i=2,num do
		if((x >= points[i-1][1]) and (x <= points[i][1])) then
			c = i
			break
		end
	end
	return points[c][3](x,points[c-1][1],points[c-1][2],points[c][1],points[c][2])
end

function GetSkillLevelData(levelname, data, level)
	if(data==nil) then
		return ""
	end
	if(data == "") then
		return ""
	end
	if(SKILLS[data]==nil) then
		return ""
	end
	if(SKILLS[data][levelname]==nil) then
		return ""
	end
	if(type(SKILLS[data][levelname]) == "function") then
		return SKILLS[data][levelname](level)
	end
	if(SKILLS[data][levelname][1]==nil) then
		SKILLS[data][levelname][1]={{0,0},{20,0}}
	end
	if(SKILLS[data][levelname][2]==nil) then
		SKILLS[data][levelname][2]={{0,0},{20,0}}
	end
	if(SKILLS[data][levelname][3]==nil) then
		SKILLS[data][levelname][3]={{0,0},{20,0}}
	end
	p1=floor(Link(level,SKILLS[data][levelname][1]))
	p2=floor(Link(level,SKILLS[data][levelname][2]))
	p3=floor(Link(level,SKILLS[data][levelname][3]))
	return Param2String(p1,p2,p3)
end

function Param2String(Param1, Param2, Param3)
	return Param1..","..Param2..","..Param3
end