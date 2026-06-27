function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										 Kü n¨ng Thiªn NhÉn										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	canyang_ruxue={ -- Tµn D­¬ng Nh­ HuyÕt - Th­¬ng 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,5},{20,55}}}, -- S¸t th­¬ng vËt lý %
		firedamage_v={ -- Háa s¸t
			[1]={{1,5},{20,50}},
			[3]={{1,5},{20,50}}
		},
		addskilldamage1={ -- % Kü n¨ng V©n Long KÝch - Th­¬ng 90
			[1]={{1,361},{2,361}},
			[3]={{1,1},{20,95}}
		},
		addskilldamage2={ -- % Kü n¨ng Th©u Thiªn Ho¸n NhËt - Th­¬ng 60
			[1]={{1,142},{2,142}},
			[3]={{1,1},{20,35}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,8},{20,8}}} -- Tiªu hao néi lùc
	},

	tianren_daofa={ -- Thiªn NhÉn §ao Ph¸p - Hç trî §ao 10
		addfiremagic_v={{{1,15},{20,315}},{{1,-1},{2,-1}}} -- Háa s¸t - néi c«ng
	},

	tianren_maofa={ -- Thiªn NhÉn M©u Ph¸p - Hç trî Th­¬ng 10
		addphysicsdamage_p={{{1,15},{20,215}},{{1,-1},{2,-1}},{{1,3},{2,3}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,35},{20,272}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,6},{20,35}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	huolian_fenhua={ -- Háa Liªn PhÇn Hoa - Bïa 10
		meleedamagereturn_p={{{1,-5},{20,-35}},{{1,18*40},{20,18*120}}}, -- Ph¶n ®ßn cËn chiÕn %
		skill_cost_v={{{1,12},{20,12}}} -- Tiªu hao néi lùc
	},

	huanying_feihu={ -- ¶o ¶nh Phi Hå - Bïa 20
		attackratingenhance_p={{{1,-15},{20,-132}},{{1,18*40},{20,18*120}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		skill_cost_v={{{1,20},{20,20}}} -- Tiªu hao néi lùc
	},

	tuishan_tianhai={ -- Th«i S¬n §iÒn H¶i - §ao 30
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,5},{20,45}},
			[3]={{1,5},{20,45}}
		},
		addskilldamage1={ -- % Kü n¨ng Thiªn Ngo¹i L­u Tinh - §ao 90
			[1]={{1,362},{2,362}},
			[3]={{1,1},{20,150}}
		},
		skill_cost_v={{{1,32},{20,50}}} -- Tiªu hao néi lùc
	},

	feihong_wuji={ -- Phi Hång V« TÝch - Bïa 30
		adddefense_v={{{1,-150},{20,-1100}},{{1,18*40},{20,18*120}}}, -- NÐ tr¸nh
		skill_cost_v={{{1,25},{20,25}}} -- Tiªu hao néi lùc
	},

	liehuo_qingtian={ -- LiÖt Háa T×nh Thiªn - Th­¬ng 30
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,15},{20,75}}}, -- S¸t th­¬ng vËt lý %
		firedamage_v={ -- Háa s¸t
			[1]={{1,8},{20,150}},
			[3]={{1,8},{20,150}}
		},
		addskilldamage1={ -- % Kü n¨ng V©n Long KÝch - Th­¬ng 90
			[1]={{1,361},{2,361}},
			[3]={{1,1},{20,100}}
		},
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,25},{20,25}}} -- Tiªu hao néi lùc
	},

	toutian_huanri={ -- Th©u Thiªn Ho¸n NhËt - Th­¬ng 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,25},{20,231}}}, -- S¸t th­¬ng vËt lý %
		deadlystrike_p={{{1,4},{20,55}}}, -- TÊn c«ng chÝ m¹ng %
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{20,482}},
			[3]={{1,10},{20,482}}
		},
		addskilldamage1={ -- % Kü n¨ng V©n Long KÝch - Th­¬ng 90
			[1]={{1,361},{2,361}},
			[3]={{1,1},{20,120}}
		},
		steallife_p={{{1,1},{20,8}}}, -- Hót sinh lùc %
		stealmana_p={{{1,1},{20,6}}}, -- Hót néi lùc %
		missle_speed_v={{{1,26},{20,26}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{2,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,78},{20,78}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,12},{20,20}}} -- Tiªu hao néi lùc
	},

	limo_duopo={ -- LÞch Ma §o¹t Hån - Bïa 50
		addphysicsdamage_p={{{1,-25},{20,-215}},{{1,18*40},{20,18*120}},{{1,6},{20,6}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		skill_cost_v={{{1,30},{20,30}}} -- Tiªu hao néi lùc
	},

	tanzhi_lieyan={ -- §¬n ChØ LiÖt DiÖm - §ao 10
		firedamage_v={ -- Háa s¸t
			[1]={{1,30},{20,250}},
			[3]={{1,30},{20,250}}
		},
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng Thiªn Ngo¹i L­u Tinh - §ao 90
			[1]={{1,362},{2,362}},
			[3]={{1,1},{20,120}}
		},
		addskilldamage2={ -- % Kü n¨ng Ma DiÖm ThÊt S¸t - §ao 60
			[1]={{1,148},{2,148}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,30}}} -- Tiªu hao néi lùc
	},

	wuxing_zhen={ -- Ngò Hµnh TrËn
		adddefense_v={{{1,75},{20,550}},{{1,18},{20,18}}}, -- NÐ tr¸nh
	},

	moyan_qisha={ -- Ma DiÖm ThÊt S¸t - §ao 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,35},{20,637}},
			[3]={{1,35},{20,637}}
		},
		addskilldamage1={ -- % Kü n¨ng NghiÖp Háa Phµn Thµnh - TÇng 2 Thiªn Ngo¹i L­u Tinh - §ao 90
			[1]={{1,363},{2,363}},
			[3]={{1,1},{20,135}}
		},
		fatallystrike_p={{{1,5},{20,30},{21,30}}}, -- TÊn c«ng chÝ tö %
		missle_speed_v={{{1,20},{20,24},{21,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,30}}} -- Tiªu hao néi lùc
	},

	tianmo_jieti={ -- Thiªn Ma Gi¶i ThÓ - TrÊn ph¸i 60
		adddefense_v={{{1,75},{30,850}},{{1,18*120},{30,18*360}}}, -- NÐ tr¸nh
		attackratingenhance_p={{{1,65},{30,1000}},{{1,18*120},{30,18*360}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		fasthitrecover_v={{{1,5},{20,40}},{{1,18*120},{20,18*360}}}, -- Thêi gian phôc håi
		addfiremagic_v={{{1,20},{30,315}},{{1,18*120},{30,18*360}}}, -- Háa s¸t - néi c«ng
		addfiredamage_v={{{1,20},{30,315}},{{1,18*120},{30,18*360}}}, -- Háa s¸t - ngo¹i c«ng
		fireenhance_p={{{1,31},{30,100}},{{1,18*120},{30,18*360}}}, -- Háa s¸t tèi ®a %
		attackspeed_v={{{1,26},{30,102},{33,109},{35,134},{38,138},{41,145},{42,163},{43,165}},{{1,18*120},{30,18*360}}}, -- Tèc ®é ®¸nh - ngäai c«ng %
		castspeed_v={{{1,26},{30,81},{33,86},{35,101},{36,103}},{{1,18*120},{30,18*360}}}, -- Tèc ®é ®¸nh - néi c«ng %
		skill_cost_v={{{1,100},{20,100}}} -- Tiªu hao néi lùc
	},

	beisu_qingfeng={ -- Bi T« Thanh Phong - Bïa 40
		fasthitrecover_v={{{1,-6},{20,-30},{23,-34},{28,-34},{29,-35}},{{1,18*40},{20,18*120}}}, -- Thêi gian phôc håi
		skill_cost_v={{{1,20},{20,20}}} -- Tiªu hao néi lùc
	},

	yunlong_ji={ -- V©n Long KÝch - Th­¬ng 90
		physicsenhance_p={{{1,55},{20,535},{23,686},{26,762}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,1},{20,40}}}, -- TÊn c«ng chÝ m¹ng %
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{20,200}},
			[3]={{1,10},{20,200}}
		},
		steallife_p={{{1,1},{20,16},{23,20},{26,23}}}, -- Hót sinh lùc %
		stealmana_p={{{1,1},{20,16},{23,20},{26,23}}}, -- Hót néi lùc %
		missle_speed_v={{{1,40},{20,40}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,12},{2,12}}}, -- Ma ¢m KÝch
		skill_attackradius={{{1,250},{20,250}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,36},{20,36}}}, -- Tiªu hao néi lùc
		randmove={{{1,1},{20,1}},{{1,1},{20,5},{23,6},{26,9},{27,9}}}, -- Ma ¢m KÝch
		missle_missrate={{{1,99},{20,80}}}, -- Ma ¢m KÝch
		skill_desc= -- Ma ¢m KÝch
			function(level)
				local szTime = format("%.2f", (floor(Link(level,SKILLS.yunlong_ji.randmove[2])*100/18 )/100))
				return "TuyÖt §Ønh <color=blue>Ma ¢m KÝch<color> vµ <color=orange>"..floor(100 -Link(level,SKILLS.yunlong_ji.missle_missrate[1])).."% <color>Tû lÖ g©y khiÕp sî "..
						"<color=orange>"..szTime.." gi©y<color>\n"
			end,
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_vanishedevent={ -- Kü n¨ng tÇng 2: TuyÖt §Ønh T×nh Thiªn
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1251},{20,1251}}
		},
		skill_startevent={ -- Ma ¢m KÝch
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1249},{20,1249}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,9},{20,9}}}, -- Kü n¨ng tÇng 2-3
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(11600,1.15,1,1,1)},
				{2,SkillExpFunc(11600,1.15,2,1,1)},
				{3,SkillExpFunc(11600,1.16,3,1,1)},
				{4,SkillExpFunc(11600,1.17,4,1,1)},
				{5,SkillExpFunc(11600,1.18,5,1,1)},
				{6,SkillExpFunc(11600,1.19,6,1,1)},
				{7,SkillExpFunc(11600,1.20,7,1,1)},
				{8,SkillExpFunc(11600,1.21,8,1,1)},
				{9,SkillExpFunc(11600,1.22,9,1,1)},
				{10,SkillExpFunc(11600,1.23,10,1,1)},
				{11,SkillExpFunc(11600,1.24,11,1,1)},
				{12,SkillExpFunc(11600,1.23,12,1,1)},
				{13,SkillExpFunc(11600,1.22,13,1,1)},
				{14,SkillExpFunc(11600,1.21,14,1,1)},
				{15,SkillExpFunc(11600,1.20,15,1,1)},
				{16,SkillExpFunc(11600,1.19,16,1,1)},
				{17,SkillExpFunc(11600,1.18,17,1,1)},
				{18,SkillExpFunc(11600,1.17,18,1,1)},
				{19,SkillExpFunc(11600,1.16,19,1,1)},
				{20,SkillExpFunc(11600,1.15,20,1,1)},
			}
		},
	},

	zhanren150={ -- Kü n¨ng 150 - Th­¬ng
		physicsenhance_p={{{1,55},{20,535},{23,686},{26,762}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		deadlystrike_p={{{1,6},{20,80},{23,103},{26,115}}},
		firedamage_v={
			[1]={{1,10},{15,120},{20,455},{23,857},{26,1058}},
			[3]={{1,10},{15,120},{20,455},{23,857},{26,1058}}
		},
		steallife_p={{{1,1},{20,16},{23,20},{26,23}}},
		stealmana_p={{{1,1},{20,16},{23,20},{26,23}}},
		missle_speed_v={{{1,40},{20,40}}},
		missle_lifetime_v={{{1,12},{2,12}}},
		skill_attackradius={{{1,198},{20,198}}},
		skill_cost_v={{{1,36},{20,36}}},
		randmove={{{1,1},{20,1}},{{1,1},{20,5},{23,6},{26,9},{27,9}}},
		missle_missrate={{{1,99},{20,80}}},
		skill_desc=
			function(level)
				local szTime = format("%.2f", (floor(Link(level,SKILLS.zhanren150.randmove[2])*100/18 )/100))
				return "T¨ng thªm h×nh thøc thø hai <color=blue> ma ©m kÝch <color> vµ <color=orange>"..floor(100 -Link(level,SKILLS.zhanren150.missle_missrate[1])).."%<color>Tû lÖ khiÕn cho ®èi ph­¬ng khiÕp sî"..
						"<color=orange>"..szTime.." gi©y<color>\n"
			end,
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_startevent={
			[1]={{1,1},{20,1}},
			[3]={{1,1131},{20,1131}}
		},
		skill_showevent={{{1,1},{20,1}}},
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

	fenghuo_liantian={ -- Phong Háa Liªn Thiªn
		seriesdamage_p={{{1,20},{20,60}}},
		firedamage_v={
			[1]={{1,5},{20,40}},
			[3]={{1,5},{20,40}}
		},
	},

	tianwai_liuxing={ -- Thiªn Ngo¹i L­u Tinh - §ao 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,11},{15,200},{20,465}},
			[3]={{1,11},{15,200},{20,465}}
		},
		fatallystrike_p={{{1,5},{20,10},{21,10}}}, -- TÊn c«ng chÝ tö %
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,50}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_vanishedevent={ -- Kü n¨ng tÇng 2: NghiÖp Háa Phµn Thµnh
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,363},{20,363}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 3: TuyÖt §Ønh LiÖu Nguyªn
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1248},{20,1248}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,9},{20,9}}}, -- Kü n¨ng tÇng 2-3
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(4085,1.15,1,3,1)},
				{2,SkillExpFunc(4085,1.15,2,3,1)},
				{3,SkillExpFunc(4085,1.16,3,3,1)},
				{4,SkillExpFunc(4085,1.17,4,3,1)},
				{5,SkillExpFunc(4085,1.18,5,3,1)},
				{6,SkillExpFunc(4085,1.19,6,3,1)},
				{7,SkillExpFunc(4085,1.20,7,3,1)},
				{8,SkillExpFunc(4085,1.21,8,3,1)},
				{9,SkillExpFunc(4085,1.22,9,3,1)},
				{10,SkillExpFunc(4085,1.23,10,3,1)},
				{11,SkillExpFunc(4085,1.24,11,3,1)},
				{12,SkillExpFunc(4085,1.23,12,3,1)},
				{13,SkillExpFunc(4085,1.22,13,3,1)},
				{14,SkillExpFunc(4085,1.21,14,3,1)},
				{15,SkillExpFunc(4085,1.20,15,3,1)},
				{16,SkillExpFunc(4085,1.19,16,3,1)},
				{17,SkillExpFunc(4085,1.18,17,3,1)},
				{18,SkillExpFunc(4085,1.17,18,3,1)},
				{19,SkillExpFunc(4085,1.16,19,3,1)},
				{20,SkillExpFunc(4085,1.15,20,3,1)},
			}
		},
	},

	moren150={ -- Kü n¨ng 150 - §ao
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		firedamage_v={
			[1]={{1,45},{20,760},{23,985},{26,1098}},
			[3]={{1,45},{20,760},{23,985},{26,1098}}
		},
		fatallystrike_p={{{1,10},{20,30}}},
		missle_speed_v={{{1,0},{20,0}}},
		skill_attackradius={{{1,448},{20,480}}},
		skill_cost_v={{{1,25},{20,36},{23,39}}},
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

	yehuo_fencheng={ -- NghiÖp Háa Phµn Thµnh - TÇng 2 Thiªn Ngo¹i L­u Tinh - §ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		firedamage_v={ -- Háa s¸t
			[1]={{1,20},{20,250}},
			[3]={{1,20},{20,250}}
		},
	},

	tuyetdinhlieunguyen={ -- TuyÖt §Ønh LiÖu Nguyªn
		firedamage_v={ -- Háa s¸t
			[1]={{1,10},{20,150}},
			[3]={{1,10},{20,150}}
		},
		missle_speed_v={{{1,0},{20,0}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,512},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		fatallystrike_p={{{1,5},{20,5},{21,5}}}, -- TÊn c«ng chÝ tö %
	},

	shehun_luanxin={ -- NhiÕp Hån Lo¹n T©m - Bïa 90
		attackratingenhance_p={{{1,-12},{20,-128}},{{1,18*40},{20,18*120}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		adddefense_v={{{1,-80},{20,-800}},{{1,18*40},{20,18*120}}}, -- NÐ tr¸nh
		addphysicsdamage_p={{{1,-15},{20,-215}},{{1,18*40},{20,18*120}},{{1,6},{20,6}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		fasthitrecover_v={{{1,-6},{20,-30}},{{1,18*40},{20,18*120}}}, -- Thêi gian phôc håi
		lifereplenish_v={{{1,-1},{20,-15}},{{1,18*40},{20,18*120}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		deadlystrikeenhance_p={{{1,-6},{20,-35}},{{1,18*40},{20,18*120}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		skill_cost_v={{{1,60},{20,120}}}, -- Tiªu hao néi lùc
	},

	tianren120={ -- Kü n¨ng 120: Ma ¢m PhÖ Ph¸ch
		skill_cost_v={{{1,25},{20,80},{21,80}}}, -- Tiªu hao néi lùc
		skill_mintimepercastonhorse_v={{{1,45*18},{15,25*18},{20,20*18},{21,20*18}}}, -- Thêi gian kh«i phôc chiªu thøc trªn ngùa
		skill_mintimepercast_v={{{1,45*18},{15,25*18},{20,20*18},{21,20*18}}}, -- Thêi gian kh«i phôc chiªu thøc
		autodeathskill={{{1,723*256 + 41},{20,723*256 + 60},{21,723*256 + 60}},{{1,-1},{20,-1}},{{1,100},{2,100}}}, -- ChÕt sÏ xuÊt kü n¨ng
		skill_desc=
			function(level)
				return "Thêi gian kh«i phôc chiªu thøc: <color=orange>"..floor(Link(level,SKILLS.tianren120.skill_mintimepercast_v[1]) / 18).." gi©y<color>\n"..
				"Thêi gian kh«i phôc chiªu thøc trªn ngùa: <color=orange>"..floor(Link(level,SKILLS.tianren120.skill_mintimepercastonhorse_v[1]) / 18).." gi©y<color>\n"..
				"X¸c suÊt <color=orange>"..floor(100 -Link(level,SKILLS.quntisuijizoudong.missle_missrate[1])).."%<color> khiÕn cho tèi ®a "..
				floor(Link(level,SKILLS.quntisuijizoudong.missle_hitcount[1])).." môc tiªu gÇn bÞ ho¶ng lo¹n trong <color=orange>"..
				floor(Link(level,SKILLS.quntisuijizoudong.randmove[2]) / 18).." gi©y<color>\n"..
				"Sau khi chÕt cã x¸c suÊt <color=orange>"..floor(Link(level,SKILLS.tianren120.autodeathskill[3])).."%<color> khiÕn cho tèi ®a "..
				floor(Link(level,SKILLS.quntisuijizoudong.missle_hitcount[1])).." môc tiªu gÇn bÞ ho¶ng lo¹n trong <color=orange>"..
				floor(Link(level,SKILLS.quntisuijizoudong.randmove[2]) / 18).." gi©y<color>\n"..
				"Trong lóc ho¶ng lo¹n kh«ng thÓ tÊn c«ng vµ di chuyÓn \n"
			end,
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
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

	quntisuijizoudong={ -- Ma ¢m PhÖ Ph¸ch - Ho¶ng lo¹n
		randmove={{{1,1},{20,1}},{{1,1*18},{15,3*18},{20,4*18},{21,4*18},{40,4*18},{41,1*18},{55,3*18},{60,4*18},{61,4*18}}},
		missle_missrate={{{1,65},{15,20},{20,15},{21,15},{40,15},{41,0},{60,0}}},
		missle_hitcount={{{1,6},{20,6}}},
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