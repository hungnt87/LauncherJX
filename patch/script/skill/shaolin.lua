function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										 Kü n¨ng ThiÕu L©m										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	jingang_fumo={ -- Kim Cang Phôc Ma - Bæng & §ao 10
		physicsenhance_p={{{1,15},{20,55}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng V« T­íng Tr¶m - §ao 90
			[1]={{1,321},{2,321}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage2={ -- % Kü n¨ng Hoµnh T¶o Thiªn Qu©n - Bæng 90
			[1]={{1,319},{2,319}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage3={ -- % Kü n¨ng Hoµnh T¶o Lôc Hîp - Bæng 50
			[1]={{1,11},{2,11}},
			[3]={{1,1},{20,150}}
		},
		addskilldamage4={ -- % Kü n¨ng Ma Ha V« L­îng - §ao 50
			[1]={{1,19},{2,19}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,18},{20,18}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,54},{20,54}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,2},{20,6}}} -- Tiªu hao néi lùc
	},

	shaolin_gunfa={ -- ThiÕu L©m C«n Ph¸p - Hç trî Bæng 10
		addphysicsdamage_p={{{1,25},{20,200}},{{1,-1},{2,-1}},{{1,2},{2,2}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,35},{20,500}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,6},{20,45,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	shaolin_daofa={ -- ThiÕu L©m §ao Ph¸p - Hç trî §ao 10
		addphysicsdamage_p={{{1,25},{20,215}},{{1,-1},{2,-1}},{{1,1},{2,1}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,5},{20,30,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	shaolin_quanfa={ -- ThiÕu L©m QuyÒn Ph¸p - Hç trî QuyÒn 10
		addphysicsdamage_p={{{1,25},{20,500}},{{1,-1},{2,-1}},{{1,9},{2,9}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,35},{20,350}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,6},{20,45,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	xinglong_buyu={ -- Hµng Long BÊt Vò - QuyÒn 10
		physicsenhance_p={{{1,60},{20,400}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng §¹t Ma §é Giang - §ao 90
			[1]={{1,318},{2,318}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage2={ -- % Kü n¨ng §¹t Ma §é Giang - §ao 90
			[1]={{1,317},{2,317}},
			[3]={{1,1},{20,60}}
		},
		addskilldamage3={ -- % Kü n¨ng Long Tr¶o Hæ Tr¶o - §ao 90
			[1]={{1,271},{2,271}},
			[3]={{1,1},{20,100}}
		},
		addskilldamage4={ -- % Kü n¨ng Long Tr¶o Hæ Tr¶o - §ao 90
			[1]={{1,272},{2,272}},
			[3]={{1,1},{20,100}}
		},
		skill_cost_v={{{1,2},{20,10}}} -- Tiªu hao néi lùc
	},

	longzhao_huzhua={ -- Long Tr¶o Hæ Tr¶o - QuyÒn 50
		physicsenhance_p={{{1,120},{20,1200}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		ignoredefense_p={{{1,9},{20,100},{21,86}}}, -- Bá qua nÐ tr¸nh %
		stun_p={{{1,1},{20,50}},{{1,1},{20,5}}}, -- Lµm cho¸ng %
		deadlystrike_p={{{1,5},{20,50}}}, -- TÊn c«ng chÝ m¹ng %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,100}}
		},
		addskilldamage1={ -- % Kü n¨ng §¹t Ma §é Giang - §ao 90
			[1]={{1,318},{2,318}},
			[3]={{1,1},{20,70}}
		},
		addskilldamage2={ -- % Kü n¨ng §¹t Ma §é Giang - §ao 90
			[1]={{1,317},{2,317}},
			[3]={{1,1},{20,70}}
		},
		missle_speed_v={{{1,26},{20,26}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,78},{20,78}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,1},{20,16}}} -- Tiªu hao néi lùc
	},

	luohan_zhen={ -- La H¸n TrËn - Hç trî bÞ ®éng 30 (Aura)
		addphysicsdamage_p={{{1,11},{20,135}},{{1,18},{2,18}},{{1,6},{2,6}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		meleedamagereturn_p={{{1,1},{20,20},{25,25},{26,26}},{{1,18},{2,18}}}, -- Ph¶n ®ßn cËn chiÕn %
		rangedamagereturn_p={{{1,1},{20,20},{25,25},{26,26}},{{1,18},{2,18}}}, -- PhÈn ®ßn tÇm xa %
		adddefense_v={{{1,40},{20,800}},{{1,18},{2,18}}}, -- NÐ tr¸nh
	},
	budong_mingwang={ -- BÊt §éng Minh V­¬ng - Hç trî chñ ®éng 20
		attackratingenhance_p={{{1,28},{20,275}},{{1,18*120},{20,18*180}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		adddefense_v={{{1,15},{20,250}},{{1,18*120},{20,18*180}}}, -- NÐ tr¸nh
		strength_v={{{1,5},{20,50},{29,50},{30,100},{31,100}},{{1,18*120},{20,18*180}}}, -- Søc m¹nh
		skill_cost_v={{{1,10},{20,40}}} -- Tiªu hao néi lùc
	},

	shizi_hou={ -- S­ Tö Hèng 40
		stun_p={{{1,15},{20,70},{21,71}},{{1,5},{20,27},{21,28}}}, -- Lµm cho¸ng %
		physicsdamage_v={ -- S¸t th­¬ng vËt lý
			[1]={{1,50},{20,150}},
			[3]={{1,50},{20,150}}
		},
		skill_cost_v={{{1,10},{20,60}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}},
	},

	mohe_wuliang={ -- Ma Ha V« L­îng - §ao 50
		physicsenhance_p={{{1,30},{20,300}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng V« T­íng Tr¶m - §ao 90
			[1]={{1,321},{2,321}},
			[3]={{1,1},{20,100}}
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,56}},
			[3]={{1,10},{20,56}}
		},
		missle_speed_v={{{1,28},{20,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,15},{20,35}}} -- Tiªu hao néi lùc
	},

	hengsao_liuhe={ -- Hoµnh T¶o Lôc Hîp - Bæng 50
		physicsenhance_p={{{1,71},{20,417}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		attackrating_p={{{1,12},{20,50}}}, -- §é chÝnh x¸c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,56}},
			[3]={{1,10},{20,56}}
		},
		deadlystrike_p={{{1,10},{20,30}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Hoµnh T¶o Thiªn Qu©n - Bæng 90
			[1]={{1,319},{2,319}},
			[3]={{1,1},{20,100}}
		},
		skill_attackradius={{{1,96},{20,96}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,8},{20,8}}} -- Tiªu hao néi lùc
	},

	yijin_jing={ -- DÞch C©n Kinh - Hç trî bÞ ®éng 60
		allres_p={{{1,1},{20,20}},{{1,-1},{2,-1}}}, -- Kh¸ng tÊt c¶
		meleedamagereturn_p={{{1,1},{20,20},{25,25},{26,26}},{{1,-1},{2,-1}}}, -- Ph¶n ®ßn cËn chiÕn %
		rangedamagereturn_p={{{1,1},{20,20},{25,25},{26,26}},{{1,-1},{2,-1}}} -- PhÈn ®ßn tÇm xa %
	},

	rulai_qianye={ -- Nh­ Lai Thiªn DiÖp - TrÊn ph¸i 60
		addphysicsdamage_p={{{1,65},{30,215}},{{1,18*120},{30,18*360}},{{1,6},{2,6}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		lifemax_p={{{1,3},{30,80}},{{1,18*120},{30,18*360}}}, -- Sinh lùc tèi ®a %
		addcolddamage_v={{{1,10},{30,215}},{{1,18*120},{30,18*360}}}, -- B¨ng s¸t - ngo¹i c«ng
		deadlystrikeenhance_p={{{1,5},{30,15}},{{1,18*120},{30,18*360}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		attackspeed_v={{{1,35},{30,65},{35,70},{36,82},{37,96},{38,98},{39,100},{40,101},{41,102},{42,103},{43,104},{44,105},{45,106},{46,107},{47,108}},{{1,18*120},{30,18*360}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
		skill_cost_v={{{1,15},{30,45}}} -- Tiªu hao néi lùc
	},

	damo_dujiang={ -- §¹t Ma §é Giang - QuyÒn 90
		physicsenhance_p={{{1,60},{15,200},{20,400}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		ignoredefense_p={{{1,100},{20,100}}}, -- Bá qua nÐ tr¸nh %
		stun_p={{{1,1},{20,20}},{{1,1},{20,5}}}, -- Lµm cho¸ng %
		skill_cost_v={{{1,15},{20,35}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: Hµng Long BÊt Vò 
		skill_collideevent={ -- Kü n¨ng tÇng 2: Hµng Long BÊt Vò 
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,14},{20,14}}
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,100}}
		},
		deadlystrike_p={{{1,5},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		skill_showevent={{{1,0},{10,0},{10,4},{20,4}}}, -- Kü n¨ng tÇng 2: Hµng Long BÊt Vò 
		addskillexp1={{{1,318},{2,318}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(6312,1.15,1,2,1)},
				{2,SkillExpFunc(6312,1.15,2,2,1)},
				{3,SkillExpFunc(6312,1.16,3,2,1)},
				{4,SkillExpFunc(6312,1.17,4,2,1)},
				{5,SkillExpFunc(6312,1.18,5,2,1)},
				{6,SkillExpFunc(6312,1.19,6,2,1)},
				{7,SkillExpFunc(6312,1.20,7,2,1)},
				{8,SkillExpFunc(6312,1.21,8,2,1)},
				{9,SkillExpFunc(6312,1.22,9,2,1)},
				{10,SkillExpFunc(6312,1.23,10,2,1)},
				{11,SkillExpFunc(6312,1.24,11,2,1)},
				{12,SkillExpFunc(6312,1.23,12,2,1)},
				{13,SkillExpFunc(6312,1.22,13,2,1)},
				{14,SkillExpFunc(6312,1.21,14,2,1)},
				{15,SkillExpFunc(6312,1.20,15,2,1)},
				{16,SkillExpFunc(6312,1.19,16,2,1)},
				{17,SkillExpFunc(6312,1.18,17,2,1)},
				{18,SkillExpFunc(6312,1.17,18,2,1)},
				{19,SkillExpFunc(6312,1.16,19,2,1)},
				{20,SkillExpFunc(6312,1.15,20,2,1)},
			}
		},
		missle_speed_v={{{1,30},{20,30}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,400},{20,400}}}, -- Ph¹m vi hiÖu qu¶
	},
	
	quanshaolin150={ -- Kü n¨ng 150 - QuyÒn
		physicsenhance_p={{{1,65},{15,415},{20,740},{23,1130},{26,1325}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		ignoredefense_p={{{1,9},{20,90},{21,94},{22,98},{23,99},{24,99},}},
		skill_cost_v={{{1,18},{20,42},{23,49}}},
		colddamage_v={
			[1]={{1,12},{20,185},{23,239},{26,266}},
			[3]={{1,12},{20,185},{23,239},{26,266}}
		},
		stun_p={{{1,1},{20,8},{21,10},{22,10}},{{1,5},{20,5},{21,6}}},
		deadlystrike_p={{{1,6},{20,45},{23,57},{26,63}}},
		missle_speed_v={{{1,30},{20,32},{21,32}}},
		missle_lifetime_v={{{1,6},{20,6}}},
		skill_attackradius={{{1,180},{20,180}}},
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

	hengsao_qianjun={ -- Hoµnh T¶o Thiªn Qu©n - Bæng 90
		physicsenhance_p={{{1,10},{15,150},{20,350}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		skill_cost_v={{{1,15},{20,20}}}, -- Tiªu hao néi lùc
		attackrating_p={{{1,25},{20,412}}}, -- §é chÝnh x¸c %
		deadlystrike_p={{{1,10},{20,30}}}, -- TÊn c«ng chÝ m¹ng %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,100}}
		},
		skill_attackradius={{{1,128},{20,128}}}, -- Ph¹m vi hiÖu qu¶
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: TuyÖt §Ønh Thiªn Qu©n
		skill_vanishedevent={ -- Kü n¨ng tÇng 2: TuyÖt §Ønh Thiªn Qu©n
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1240},{20,1240}}
		},
		skill_showevent={{{1,0},{10,0},{10,8},{20,8}}}, -- Kü n¨ng tÇng 2: TuyÖt §Ønh Thiªn Qu©n
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(5070,1.15,1,3,1)},
				{2,SkillExpFunc(5070,1.15,2,3,1)},
				{3,SkillExpFunc(5070,1.16,3,3,1)},
				{4,SkillExpFunc(5070,1.17,4,3,1)},
				{5,SkillExpFunc(5070,1.18,5,3,1)},
				{6,SkillExpFunc(5070,1.19,6,3,1)},
				{7,SkillExpFunc(5070,1.20,7,3,1)},
				{8,SkillExpFunc(5070,1.21,8,3,1)},
				{9,SkillExpFunc(5070,1.22,9,3,1)},
				{10,SkillExpFunc(5070,1.23,10,3,1)},
				{11,SkillExpFunc(5070,1.24,11,3,1)},
				{12,SkillExpFunc(5070,1.23,12,3,1)},
				{13,SkillExpFunc(5070,1.22,13,3,1)},
				{14,SkillExpFunc(5070,1.21,14,3,1)},
				{15,SkillExpFunc(5070,1.20,15,3,1)},
				{16,SkillExpFunc(5070,1.21,16,3,1)},
				{17,SkillExpFunc(5070,1.18,17,3,1)},
				{18,SkillExpFunc(5070,1.17,18,3,1)},
				{19,SkillExpFunc(5070,1.16,19,3,1)},
				{20,SkillExpFunc(5070,1.15,20,3,1)},
			}
		},
	},

	gunshaolin150={ -- Kü n¨ng 150 - Bæng
		physicsenhance_p={{{1,12},{15,180},{20,425},{23,719},{26,866}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		skill_cost_v={{{1,18},{20,25},{23,27}}},
		attackrating_p={{{1,65},{20,595},{23,762},{26,846}}},
		deadlystrike_p={{{1,20},{20,45},{23,52},{26,56}}},
		colddamage_v={
			[1]={{1,12},{20,138},{23,177},{26,197}},
			[3]={{1,12},{20,138},{23,177},{26,197}}
		},
		skill_attackradius={{{1,128},{20,128}}},
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

	tuyetdinhthienquan={ -- TuyÖt §Ønh Thiªn Qu©n - TÇng 2 Hoµnh T¶o Thiªn Qu©n - Bæng 90
		physicsenhance_p={{{1,5},{20,100}}}, -- S¸t th­¬ng vËt lý %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,100}}
		},
		skill_attackradius={{{1,128},{20,128}}}, -- Ph¹m vi hiÖu qu¶
	},

	wuxiang_zhan={ -- V« T­íng Tr¶m - §ao 90
		physicsenhance_p={{{1,45},{15,120},{20,400}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,100}}
		},
		skill_cost_v={{{1,15},{20,45}}}, -- Tiªu hao néi lùc
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(5700,1.15,1,2,1)},
				{2,SkillExpFunc(5700,1.15,2,2,1)},
				{3,SkillExpFunc(5700,1.16,3,2,1)},
				{4,SkillExpFunc(5700,1.17,4,2,1)},
				{5,SkillExpFunc(5700,1.18,5,2,1)},
				{6,SkillExpFunc(5700,1.19,6,2,1)},
				{7,SkillExpFunc(5700,1.20,7,2,1)},
				{8,SkillExpFunc(5700,1.21,8,2,1)},
				{9,SkillExpFunc(5700,1.22,9,2,1)},
				{10,SkillExpFunc(5700,1.23,10,2,1)},
				{11,SkillExpFunc(5700,1.24,11,2,1)},
				{12,SkillExpFunc(5700,1.23,12,2,1)},
				{13,SkillExpFunc(5700,1.22,13,2,1)},
				{14,SkillExpFunc(5700,1.21,14,2,1)},
				{15,SkillExpFunc(5700,1.20,15,2,1)},
				{16,SkillExpFunc(5700,1.19,16,2,1)},
				{17,SkillExpFunc(5700,1.18,17,2,1)},
				{18,SkillExpFunc(5700,1.17,18,2,1)},
				{19,SkillExpFunc(5700,1.16,19,2,1)},
				{20,SkillExpFunc(5700,1.15,20,2,1)},
			}
		},
		missle_speed_v={{{1,28},{20,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: Ma Ha V« L­îng - §ao 50
		skill_startevent={ -- Kü n¨ng tÇng 2: Ma Ha V« L­îng - §ao 50
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,19},{20,19}}
		},
		skill_showevent={{{1,0},{15,0},{15,1},{20,1}}}, -- Kü n¨ng tÇng 2: Ma Ha V« L­îng - §ao 50
	},

	daoshaolin150={ -- Kü n¨ng 150 - §ao
		physicsenhance_p={{{1,55},{15,180},{20,400},{23,664},{26,796}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		colddamage_v={
			[1]={{1,12},{20,135},{23,173},{26,193}},
			[3]={{1,12},{20,135},{23,173},{26,193}}
		},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_startevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1085},{20,1085}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1}}},
		skill_cost_v={{{1,18},{20,55},{23,66},{26,72}}},
		missle_speed_v={{{1,32},{20,36},{23,38},{30,38}}},
		skill_attackradius={{{1,448},{20,512}}},
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

	dachengrulaizhou={ -- Kü N¨ng 120: §¹i Thõa Nh­ Lai Chó
		poisondamagereturn_p={{{1,5},{15,40},{20,45},{21,45}},{{1,-1},{2,-1}}}, -- Ph¶n ®ßn khi bÞ tróng ®éc %
		returnskill_p={{{1,5},{15,50},{20,56},{21,57}},{{1,-1},{2,-1}}}, -- X¸c suÊt ph¶n ®ßn bïa chó %
		autoreplyskill={{{1,20 * 256 + 1},{20,20 * 256 + 20},{21,20*256 + 21}},{{1,-1},{2,-1}},{{1,10*18*256 + 1},{19,4*18*256 + 3},{20,5*18*256 + 3},{21,5*18*256 + 3}}},
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