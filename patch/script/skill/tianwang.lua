function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										Kü n¨ng Thiªn V­¬ng										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	zhanlong_jue={ -- Tr¶m Long QuyÕt - Chïy 10
		physicsenhance_p={{{1,80},{20,185}}}, -- S¸t th­¬ng vËt lý %
		ignoredefense_p={{{1,5},{20,20}}}, -- Bá qua nÐ tr¸nh %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,6},{20,10}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Truy Phong QuyÕt - Chïy 90
			[1]={{1,325},{2,325}},
			[3]={{1,1},{20,30}}
		},
		addskilldamage2={ -- % Kü n¨ng Truy Phong QuyÕt - Chïy 90
			[1]={{1,408},{2,408}},
			[3]={{1,1},{20,30}}
		},
		addskilldamage3={ -- % Kü n¨ng Thõa Long QuyÕt - Chïy 60
			[1]={{1,324},{2,324}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage4={ -- % Kü n¨ng Thõa Long QuyÕt - Chïy 60
			[1]={{1,407},{2,407}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,18},{20,18}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,54},{20,54}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,2},{20,6}}} -- Tiªu hao sinh mÖnh
	},

	tianwang_qiangfa={ -- Thiªn V­¬ng Th­¬ng Ph¸p - Hç trî Th­¬ng 10
		addphysicsdamage_p={{{1,25},{20,330}},{{1,-1},{2,-1}},{{1,3},{2,3}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,75},{20,270}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,2},{20,15}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	tianwang_daofa={ -- Thiªn V­¬ng §ao Ph¸p - Hç trî §ao 10
		addphysicsdamage_p={{{1,50},{20,315}},{{1,-1},{2,-1}},{{1,1},{2,1}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,15},{20,72}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,2},{20,15}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	tianwang_chuifa={ -- Thiªn V­¬ng Chïy Ph¸p - Hç trî Chïy 10
		addphysicsdamage_p={{{1,25},{20,275}},{{1,-1},{2,-1}},{{1,4},{2,4}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,15},{20,72}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,2},{20,15}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	huifeng_luoyan={ -- Håi Phong L¹c Nh¹n - Th­¬ng 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,80},{20,215}}}, -- S¸t th­¬ng vËt lý %
		attackrating_p={{{1,10},{20,147}}}, -- §é chÝnh x¸c %
		addskilldamage1={ -- % Kü n¨ng Truy Tinh Trôc NguyÖt - Th­¬ng 90
			[1]={{1,323},{2,323}},
			[3]={{1,1},{20,50}}
		},
		addskilldamage2={ -- % Kü n¨ng Truy Tinh Trôc NguyÖt - Th­¬ng 90
			[1]={{1,327},{2,327}},
			[3]={{1,1},{20,50}}
		},
		addskilldamage3={ -- % Kü n¨ng HuyÕt ChiÕn B¸t Ph­¬ng - Th­¬ng 60
			[1]={{1,41},{2,41}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage4={ -- % Kü n¨ng HuyÕt ChiÕn B¸t Ph­¬ng - Th­¬ng 60
			[1]={{1,225},{2,225}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,18},{20,18}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,54},{20,54}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,4},{20,10}}} -- Tiªu hao sinh mÖnh
	},

	xingyun_jue={ -- Hµng V©n QuyÕt - Chïy 30
		physicsenhance_p={{{1,30},{20,255}}}, -- S¸t th­¬ng vËt lý %
		ignoredefense_p={{{1,10},{20,35}}}, -- Bá qua nÐ tr¸nh %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,8},{20,20}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Truy Phong QuyÕt - Chïy 90
			[1]={{1,325},{2,325}},
			[3]={{1,1},{20,50}}
		},
		addskilldamage2={ -- % Kü n¨ng Truy Phong QuyÕt - Chïy 90
			[1]={{1,408},{2,408}},
			[3]={{1,1},{20,50}}
		},
		missle_speed_v={{{1,22},{20,22}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,66},{20,66}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,3},{20,7}}} -- Tiªu hao sinh mÖnh
	},

	wuxin_zhan={ -- V« T©m Tr¶m - §ao 60
		physicsenhance_p={{{1,65},{20,453}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,4},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Ph¸ Thiªn Tr¶m - §ao 90
			[1]={{1,322},{2,322}},
			[3]={{1,1},{20,130}}
		},
		addskilldamage2={ -- % Kü n¨ng Ph¸ Thiªn Tr¶m - §ao 90
			[1]={{1,326},{2,326}},
			[3]={{1,1},{20,130}}
		},
		missle_speed_v={{{1,26},{20,26}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,78},{20,78}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,20}}} -- Tiªu hao sinh mÖnh
	},

	jingxin_jue={ -- TÜnh T©m QuyÕt - Hç trî chñ ®éng 20
		attackratingenhance_p={{{1,50},{20,500}},{{1,18*120},{20,18*180}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		attackratingenhance_v={{{1,50},{20,500}},{{1,18*120},{20,18*180}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c
		dexterity_v={{{1,5},{20,200},{21,200}},{{1,18*120},{20,18*180}}}, -- Th©n ph¸p
		add_damage_p={{{1,1},{20,10},{21,10}},{{1,18*120},{20,18*180}}}, -- Lùc c«ng kÝch %
		skill_cost_v={{{1,5},{20,20}}} -- Tiªu hao sinh mÖnh
	},
	
	jinglei_zhan={ -- Kinh L«i Tr¶m - §ao 10
		physicsenhance_p={{{1,40},{20,200}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng Ph¸ Thiªn Tr¶m - §ao 90
			[1]={{1,322},{2,322}},
			[3]={{1,1},{20,60}}
		},
		addskilldamage2={ -- % Kü n¨ng Ph¸ Thiªn Tr¶m - §ao 90
			[1]={{1,326},{2,326}},
			[3]={{1,1},{20,60}}
		},
		addskilldamage3={ -- % Kü n¨ng V« T©m Tr¶m - §ao 60
			[1]={{1,32},{2,32}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage4={ -- % Kü n¨ng V« T©m Tr¶m - §ao 60
			[1]={{1,220},{2,220}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,18},{20,18}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,54},{20,54}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,5},{20,10}}} -- Tiªu hao sinh mÖnh
	},

	yangguan_sandie={ -- D­¬ng Quan Tam §iÖp - Th­¬ng 30
		physicsenhance_p={{{1,130},{20,375}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		attackrating_p={{{1,10},{20,180}}}, -- §é chÝnh x¸c %
		addskilldamage1={ -- % Kü n¨ng Truy Tinh Trôc NguyÖt - Th­¬ng 90
			[1]={{1,323},{2,323}},
			[3]={{1,1},{20,100}}
		},
		addskilldamage2={ -- % Kü n¨ng Truy Tinh Trôc NguyÖt - Th­¬ng 90
			[1]={{1,327},{2,327}},
			[3]={{1,1},{20,100}}
		},
		missle_speed_v={{{1,22},{20,22}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,66},{20,66}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,9},{20,16}}} -- Tiªu hao sinh mÖnh
	},

	tianwang_zhanyi={ -- Thiªn V­¬ng ChiÕn ý - TrÊn ph¸i 60
		lifemax_p={{{1,21},{30,185}},{{1,-1},{30,-1}}}, -- Sinh lùc tèi ®a %
		deadlystrikeenhance_p={{{1,5},{30,45}},{{1,-1},{30,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		addphysicsdamage_p={{{1,1},{30,1},{35,135},{36,145}},{{1,18},{2,18}},{{1,6},{2,6}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		fastwalkrun_p={{{1,1},{30,30}},{{1,-1},{30,-1}}}, -- Tèc ®é di chuyÓn %
		skill_cost_v={{{1,10},{30,50}}} -- Tiªu hao sinh mÖnh
	},
	
	pofeng_zhan={ -- B¸t Phong Tr¶m - §ao 30
		physicsenhance_p={{{1,120},{20,275}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng Ph¸ Thiªn Tr¶m - §ao 90
			[1]={{1,322},{2,322}},
			[3]={{1,1},{20,100}}
		},
		addskilldamage2={ -- % Kü n¨ng Ph¸ Thiªn Tr¶m - §ao 90
			[1]={{1,326},{2,326}},
			[3]={{1,1},{20,100}}
		},
		missle_speed_v={{{1,22},{20,22}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,66},{20,66}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,8},{20,12}}} -- Tiªu hao sinh mÖnh
	},

	duanhun_ci={ -- §o¹n Hån ThÝch 40
		physicsenhance_p={{{1,25},{20,215}}}, -- S¸t th­¬ng vËt lý %
		stun_p={{{1,16},{20,35}},{{1,5},{20,18},{25,28},{26,29}}}, -- Lµm cho¸ng %
		skill_param1_v={{{1,4},{5,12},{20,24},{28,31},{31,31}}},
		skill_param2_v={{{1,18},{20,1},{21,1}}},
		deadlystrike_p={{{1,4},{20,80}}}, -- TÊn c«ng chÝ m¹ng %
		missle_speed_v={{{1,22},{20,30},{21,32},{22,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,22*16},{20,30*16},{21,30*16}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,20}}} -- Tiªu hao sinh mÖnh
	},

	xuezhan_bafang={ -- HuyÕt ChiÕn B¸t Ph­¬ng - Th­¬ng 60
		physicsenhance_p={{{1,60},{20,723}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		attackrating_p={{{1,75},{20,320}}}, -- §é chÝnh x¸c %
		deadlystrike_p={{{1,4},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Truy Tinh Trôc NguyÖt - Th­¬ng 90
			[1]={{1,323},{2,323}},
			[3]={{1,1},{20,110}}
		},
		addskilldamage2={ -- % Kü n¨ng Truy Tinh Trôc NguyÖt - Th­¬ng 90
			[1]={{1,327},{2,327}},
			[3]={{1,1},{20,110}}
		},
		missle_speed_v={{{1,26},{20,26}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,78},{20,78}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,11},{20,45}}} -- Tiªu hao sinh mÖnh
	},

	jinzhong_zhao={ -- Kim Chung Tr¸o - Hç trî chñ ®éng 50
		physicsres_p={{{1,12},{20,50}},{{1,18*120},{20,18*180}}}, -- Phßng thñ vËt lý %
		poisonres_p={{{1,12},{20,49}},{{1,18*120},{20,18*180}}}, -- Kh¸ng ®éc %
		coldres_p={{{1,7},{20,45}},{{1,18*120},{20,18*180}}}, -- Kh¸ng b¨ng %
		fireres_p={{{1,-5},{20,-15},{21,-15}},{{1,18*120},{20,18*180}}}, -- Kh¸ng háa %
		skill_cost_v={{{1,12},{20,40}}} -- Tiªu hao sinh mÖnh
	},

	chenglong_jue={ -- Thõa Long QuyÕt - Chïy 60
		physicsenhance_p={{{1,40},{20,495}}}, -- S¸t th­¬ng vËt lý %
		ignoredefense_p={{{1,38},{20,80},{21,82}}}, -- Bá qua nÐ tr¸nh %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,5},{20,40}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Truy Phong QuyÕt - Chïy 90
			[1]={{1,325},{2,325}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage2={ -- % Kü n¨ng Truy Phong QuyÕt - Chïy 90
			[1]={{1,408},{2,408}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,26},{20,26}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,78},{20,78}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,16}}} -- Tiªu hao sinh mÖnh
	},

	potian_zhan={ -- Ph¸ Thiªn Tr¶m - §ao 90
		physicsenhance_p={{{1,35},{15,150},{20,385}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,4},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		attackrating_p={{{1,35},{20,215}}}, -- §é chÝnh x¸c %
		missle_speed_v={{{1,36},{20,36}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,8},{20,8}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,280},{20,280}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,15},{20,30}}}, -- Tiªu hao sinh mÖnh
		addskillexp1={{{1,322},{2,322}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(7280,1.25,1,2.5,1)},
				{2,SkillExpFunc(7280,1.25,2,2.5,1)},
				{3,SkillExpFunc(7280,1.25,3,2.5,1)},
				{4,SkillExpFunc(7280,1.25,4,2.5,1)},
				{5,SkillExpFunc(7280,1.25,5,2.5,1)},
				{6,SkillExpFunc(7280,1.25,6,2.5,1)},
				{7,SkillExpFunc(7280,1.25,7,2.5,1)},
				{8,SkillExpFunc(7280,1.25,8,2.5,1)},
				{9,SkillExpFunc(7280,1.25,9,2.5,1)},
				{10,SkillExpFunc(7280,1.25,10,2.5,1)},
				{11,SkillExpFunc(7280,1.25,11,2.5,1)},
				{12,SkillExpFunc(7280,1.25,12,2.5,1)},
				{13,SkillExpFunc(7280,1.25,13,2.5,1)},
				{14,SkillExpFunc(7280,1.25,14,2.5,1)},
				{15,SkillExpFunc(7280,1.25,15,2.5,1)},
				{16,SkillExpFunc(7280,1.25,16,2.5,1)},
				{17,SkillExpFunc(7280,1.25,17,2.5,1)},
				{18,SkillExpFunc(7280,1.25,18,2.5,1)},
				{19,SkillExpFunc(7280,1.25,19,2.5,1)},
				{20,SkillExpFunc(7280,1.25,20,2.5,1)},
			}
		},
	},

	daotianwang150={ -- Kü n¨ng 150 - §ao
		physicsenhance_p={{{1,45},{15,180},{20,405},{23,675},{26,810}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		deadlystrike_p={{{1,5},{20,30},{23,37},{26,41}}},
		attackrating_p={{{1,35},{20,215},{23,271},{26,300}}},
		missle_speed_v={{{1,36},{20,36}}},
		missle_lifetime_v={{{1,8},{20,8}}},
		skill_attackradius={{{1,280},{20,280}}},
		skill_cost_v={{{1,20},{20,35},{23,39}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1086},{20,1086}}
		},
		skill_showevent={{{1,0},{10,0},{10,5},{20,5}}},
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

	zhuixing_zhuyue={ -- Truy Tinh Trôc NguyÖt - Th­¬ng 90
		physicsenhance_p={{{1,50},{15,200},{20,400}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		attackrating_p={{{1,95},{20,360}}}, -- §é chÝnh x¸c %
		deadlystrike_p={{{1,4},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		missle_speed_v={{{1,30},{20,30}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,100},{20,100}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,65}}}, -- Tiªu hao sinh mÖnh
		addskillexp1={{{1,323},{2,323}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(6550,1.25,1,5,1)},
				{2,SkillExpFunc(6550,1.25,2,5,1)},
				{3,SkillExpFunc(6550,1.25,3,5,1)},
				{4,SkillExpFunc(6550,1.25,4,5,1)},
				{5,SkillExpFunc(6550,1.25,5,5,1)},
				{6,SkillExpFunc(6550,1.25,6,5,1)},
				{7,SkillExpFunc(6550,1.25,7,5,1)},
				{8,SkillExpFunc(6550,1.25,8,5,1)},
				{9,SkillExpFunc(6550,1.25,9,5,1)},
				{10,SkillExpFunc(6550,1.25,10,5,1)},
				{11,SkillExpFunc(6550,1.25,11,5,1)},
				{12,SkillExpFunc(6550,1.25,12,5,1)},
				{13,SkillExpFunc(6550,1.25,13,5,1)},
				{14,SkillExpFunc(6550,1.25,14,5,1)},
				{15,SkillExpFunc(6550,1.25,15,5,1)},
				{16,SkillExpFunc(6550,1.25,16,5,1)},
				{17,SkillExpFunc(6550,1.25,17,5,1)},
				{18,SkillExpFunc(6550,1.25,18,5,1)},
				{19,SkillExpFunc(6550,1.25,19,5,1)},
				{20,SkillExpFunc(6550,1.25,20,5,1)},
			}
		},
	},

	qiangtianwang150={ -- Kü n¨ng 150 - Th­¬ng
		physicsenhance_p={{{1,60},{15,240},{20,460},{23,724},{26,856}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		attackrating_p={{{1,95},{20,360},{23,443},{26,485}}},
		deadlystrike_p={{{1,5},{20,30},{23,37},{26,41}}},
		missle_speed_v={{{1,36},{20,36}}},
		missle_lifetime_v={{{1,3},{20,3}}},
		skill_attackradius={{{1,108},{20,108}}},
		skill_cost_v={{{1,12},{20,80},{23,101}}},
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

	zhuifeng_jue={ -- Truy Phong QuyÕt - Chïy 90
		physicsenhance_p={{{1,25},{15,140},{20,380}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		ignoredefense_p={{{1,12},{20,90},{21,94},{22,98},{23,99},{24,99}}}, -- Bá qua nÐ tr¸nh %
		deadlystrike_p={{{1,5},{20,40}}}, -- TÊn c«ng chÝ m¹ng %
		missle_speed_v={{{1,30},{20,30}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,100},{20,100}}}, -- Ph¹m vi hiÖu qu¶
		addskillexp1={{{1,325},{2,325}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(7750,1.25,1,2.5,1)},
				{2,SkillExpFunc(7750,1.25,2,2.5,1)},
				{3,SkillExpFunc(7750,1.25,3,2.5,1)},
				{4,SkillExpFunc(7750,1.25,4,2.5,1)},
				{5,SkillExpFunc(7750,1.25,5,2.5,1)},
				{6,SkillExpFunc(7750,1.25,6,2.5,1)},
				{7,SkillExpFunc(7750,1.25,7,2.5,1)},
				{8,SkillExpFunc(7750,1.25,8,2.5,1)},
				{9,SkillExpFunc(7750,1.25,9,2.5,1)},
				{10,SkillExpFunc(7750,1.25,10,2.5,1)},
				{11,SkillExpFunc(7750,1.25,11,2.5,1)},
				{12,SkillExpFunc(7750,1.25,12,2.5,1)},
				{13,SkillExpFunc(7750,1.25,13,2.5,1)},
				{14,SkillExpFunc(7750,1.25,14,2.5,1)},
				{15,SkillExpFunc(7750,1.25,15,2.5,1)},
				{16,SkillExpFunc(7750,1.25,16,2.5,1)},
				{17,SkillExpFunc(7750,1.25,17,2.5,1)},
				{18,SkillExpFunc(7750,1.25,18,2.5,1)},
				{19,SkillExpFunc(7750,1.25,19,2.5,1)},
				{20,SkillExpFunc(7750,1.25,20,2.5,1)},
			}
		},
		skill_cost_v={{{1,10},{20,30}}} -- Tiªu hao sinh mÖnh
	},

	chuitianwang150={ -- Kü n¨ng 150 - Chïy
		physicsenhance_p={{{1,30},{15,210},{20,455},{23,749},{26,896}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		ignoredefense_p={{{1,12},{20,90},{21,94},{22,98},{23,99},{24,99}}},
		deadlystrike_p={{{1,5},{20,50},{23,64},{26,71}}},
		missle_speed_v={{{1,32},{20,32}}},
		missle_lifetime_v={{{1,4},{20,4}}},
		skill_attackradius={{{1,108},{20,108}}},
		skill_cost_v={{{1,12},{20,36},{23,43}}},
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

	daoxutian={ -- Kü N¨ng 120: §¶o H­ Thiªn
		allres_p={{{1,1},{20,10},{21,10}},{{1,-1},{2,-1}}}, -- Kh¸ng tÊt c¶ %
		allresmax_p={{{1,1},{20,5},{21,5}},{{1,-1},{2,-1}}}, -- Møc kh¸ng tÝnh tèi ®a %
		lifereplenish_p={{{1,1},{15,30},{20,35},{21,36}},{{1,-1},{2,-1}}}, -- Håi phôc sinh lùc %
		ignoreskill_p={{{1,5},{15,79},{20,89},{21,89}},{{1,-1},{2,-1}}}, -- X¸c suÊt bá qua bïa gi¶m kh¸ng %
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