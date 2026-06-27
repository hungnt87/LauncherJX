function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										 Kü n¨ng §­êng M«n										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	pili_dan={ -- TÝch LÞch §¬n - Phi ®ao, Tô tiÔn, Phi tiªu 10
		physicsenhance_p={{{1,20},{20,80}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,1},{20,5}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		deadlystrike_p={{{1,1},{20,8}}}, -- TÊn c«ng chÝ m¹ng %
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_vanishedevent={
			[1]={{1,1},{20,1}},
			[3]={{1,1113},{20,1113}}
		},
		skill_showevent={{{1,8},{20,8}}},
		addskilldamage1={ -- % Kü n¨ng NhiÕp Hån NguyÖt ¶nh - Phi ®ao 90
			[1]={{1,339},{2,339}},
			[3]={{1,1},{20,70}}
		},
		addskilldamage2={ -- % Kü n¨ng B¹o Vò Lª Hoa - Tô tiÔn 90
			[1]={{1,302},{2,302}},
			[3]={{1,1},{20,50}}
		},
		addskilldamage3={ -- % Kü n¨ng Cöu Cung Phi Tinh - Phi tiªu 90
			[1]={{1,342},{2,342}},
			[3]={{1,1},{20,40}}
		},
		addskilldamage4={ -- % Kü n¨ng T¸n Hoa Tiªu - Phi tiªu 60
			[1]={{1,341},{2,341}},
			[3]={{1,1},{20,40}}
		},
		addskilldamage5={ -- % Kü n¨ng TiÓu Lý Phi §ao - Phi ®ao 60
			[1]={{1,249},{2,249}},
			[3]={{1,1},{20,50}}
		},
		addskilldamage6={ -- % Kü n¨ng Thiªn La §Þa Vâng - Tô tiÔn 60
			[1]={{1,58},{2,58}},
			[3]={{1,1},{20,50}}
		},
		skill_cost_v={{{1,12},{20,12}}} -- Tiªu hao néi lùc
	},

	tangmen_anqi={ -- §­êng M«n ¸m KhÝ - Hç trî bÞ ®éng 10
		addphysicsdamage_p={{{1,25},{20,250}},{{1,-1},{2,-1}},{{1,7},{2,7}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,2},{20,25}},{{1,-1},{2,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	duohun_biao={ -- §o¹t Hån Tiªu - Phi tiªu 30
		physicsenhance_p={{{1,25},{20,115}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,2},{20,12}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Cöu Cung Phi Tinh - Phi tiªu 90
			[1]={{1,342},{2,342}},
			[3]={{1,1},{20,50}}
		},
		poisondamage_v={{{1,3},{20,8}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,5},{20,16}}} -- Tiªu hao néi lùc
	},

	xinyan={ -- T©m Nh·n - TrÊn ph¸i 60
		addcolddamage_v={{{1,10},{30,110}},{{1,-1},{2,-1}}}, -- B¨ng s¸t - ngo¹i c«ng
		addpoisondamage_v={{{1,1},{30,10}},{{1,-1},{2,-1}},{{1,10},{2,10}}}, -- §éc s¸t - ngo¹i c«ng
		addphysicsdamage_p={{{1,15},{20,115}},{{1,-1},{2,-1}},{{1,7},{2,7}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		poisonenhance_p={{{1,3},{30,33}},{{1,-1},{2,-1}}}, -- Thêi gian ®éc ph¸t %
		deadlystrikeenhance_p={{{1,8},{30,36}},{{1,-1},{2,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		attackspeed_v={{{1,29},{30,106},{33,113},{34,116},{35,149},{38,156},{39,159},{40,162}},{{1,-1},{2,-1}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
	},

	zhuixin_jian={ -- Truy T©m TiÔn - Phi ®ao 30
		physicsenhance_p={{{1,20},{20,185}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,3},{20,8}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		deadlystrike_p={{{1,5},{20,15}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng NhiÕp Hån NguyÖt ¶nh - Phi ®ao 90
			[1]={{1,339},{2,339}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,512},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,20}}}, -- Tiªu hao néi lùc
	},

	mantian_huayu={ -- M¹n Thiªn Hoa Vò - Tô tiÔn 30
		physicsenhance_p={{{1,30},{20,185}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,3},{20,8}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		deadlystrike_p={{{1,1},{20,8}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng B¹o Vò Lª Hoa - Tô tiÔn 90
			[1]={{1,302},{2,302}},
			[3]={{1,1},{20,50}}
		},
		skill_attackradius={{{1,512},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,40},{20,40}}} -- Tiªu hao néi lùc
	},

	tianluo_diwang={ -- Thiªn La §Þa Vâng - Tô tiÔn 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,80},{20,344}}}, -- S¸t th­¬ng vËt lý %
		poisondamage_v={{{1,5},{20,24}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		deadlystrike_p={{{1,5},{20,14}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng B¹o Vò Lª Hoa - Tô tiÔn 90
			[1]={{1,302},{2,302}},
			[3]={{1,1},{20,50}}
		},
		missle_speed_v={{{1,26},{20,28},{21,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,50},{20,50}}} -- Tiªu hao néi lùc
	},

	tianluo_diwang1={ -- Thiªn La §Þa Vâng tiÓu Phi §ao
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,80/2},{20,240/2}}}, -- S¸t th­¬ng vËt lý %
		missle_speed_v={{{1,26},{20,28},{21,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
	},

	xiaoli_feidao={ -- TiÓu Lý Phi §ao - Phi ®ao 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,50},{20,344},{25,344},{26,359}}}, -- S¸t th­¬ng vËt lý %
		poisondamage_v={{{1,5},{20,24}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		deadlystrike_p={{{1,10},{20,59}}}, -- TÊn c«ng chÝ m¹ng %
		skill_dohurt={{{1,10},{20,60},{21,62}}}, -- TØ lÖ t¹o thµnh s¸t th­¬ng %
		addskilldamage1={ -- % Kü n¨ng Ng©n §ao X¹ NguyÖt - TÇng 2 NhiÕp Hån NguyÖt ¶nh - Phi ®ao 90
			[1]={{1,340},{2,340}},
			[3]={{1,1},{20,100}}
		},
		skill_attackradius={{{1,512},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,50},{20,50}}} -- Tiªu hao néi lùc
	},

	diyan_huo={ -- §Þa DiÖm Háa - BÉy 10
		firedamage_v={ -- Háa s¸t
			[1]={{1,60},{20,400}},
			[3]={{1,60},{20,400}}
		},
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		skill_cost_v={{{1,20},{20,60}}} -- Tiªu hao néi lùc
	},

	duci_gu={ -- §éc ThÝch Cèt - BÉy 20
		poisondamage_v={ -- §éc s¸t
			[1]={{1,8},{20,40}},
			[2]={{1,100},{20,100}},
			[3]={{1,10},{20,10}}
		},
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		skill_cost_v={{{1,20},{20,60}}} -- Tiªu hao néi lùc
	},

	chuanxin_ci={ -- Xuyªn T©m ThÝch - BÉy 30
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsdamage_v={ -- S¸t th­¬ng vËt lý
			[1]={{1,60},{20,400}},
			[3]={{1,60},{20,400}}
		},
		skill_cost_v={{{1,20},{20,60}}} -- Tiªu hao néi lùc
	},

	hanbing_ci={ -- Hµn B¨ng ThÝch - BÉy 40
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,60},{20,400}},
			[2]={{1,1},{20,18}},
			[3]={{1,60},{20,400}}
		},
		skill_cost_v={{{1,20},{20,60}}} -- Tiªu hao néi lùc
	},

	leiji_shu={ -- L«i KÝch ThuËt - BÉy 50
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,60},{20,400}},
			[3]={{1,60},{20,400}}
		},
		stun_p={{{1,1},{20,20}},{{1,1},{20,20}}}, -- Lµm cho¸ng %
		skill_cost_v={{{1,20},{20,60}}} -- Tiªu hao néi lùc
	},

	luanhuan_ji={ -- Lo¹n Hoµn KÝch - BÉy 90
		firedamage_v={ -- Háa s¸t
			[1]={{1,100},{20,500}},
			[3]={{1,100},{20,500}}
		},
		poisondamage_v={ -- §éc s¸t
			[1]={{1,50},{20,100}},
			[2]={{1,100},{20,100}},
			[3]={{1,10},{20,10}}
		},
		physicsdamage_v={ -- S¸t th­¬ng vËt lý
			[1]={{1,100},{20,500}},
			[3]={{1,100},{20,500}}
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,100},{20,500}},
			[2]={{1,1},{20,18}},
			[3]={{1,100},{20,500}}
		},
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,100},{20,500}},
			[3]={{1,100},{20,500}}
		},
		stun_p={{{1,1},{20,20}},{{1,1},{20,20}}}, -- Lµm cho¸ng %
		skill_cost_v={{{1,80},{20,80}}} -- Tiªu hao néi lùc
	},

	nomovespeedatt={
		nomovespeed={
			[1]={{1,100},{10,0}},
			[2]={{1,5*18},{20,20*18}},
			[3]={{1,10},{20,10}}
		},
		skill_cost_v={{{1,1},{20,20}}}
	},

	shehun_yueying={ -- NhiÕp Hån NguyÖt ¶nh - Phi ®ao 90
		physicsenhance_p={{{1,25},{15,150},{20,350}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,5},{20,31}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		deadlystrike_p={{{1,10},{20,59}}}, -- TÊn c«ng chÝ m¹ng %
		skill_cost_v={{{1,30},{20,60}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_collideevent={ -- Kü n¨ng tÇng 3: Ng©n §ao X¹ NguyÖt
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,340},{20,340}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 2: TuyÖt §Ønh Hoa Vò
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1243},{20,1243}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}}, -- Kü n¨ng tÇng 2-3
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(4000,1.215,1,1,3)},
				{2,SkillExpFunc(4000,1.15,2,1,3)},
				{3,SkillExpFunc(4000,1.16,3,1,3)},
				{4,SkillExpFunc(4000,1.17,4,1,3)},
				{5,SkillExpFunc(4000,1.18,5,1,3)},
				{6,SkillExpFunc(4000,1.19,6,1,3)},
				{7,SkillExpFunc(4000,1.20,7,1,3)},
				{8,SkillExpFunc(4000,1.21,8,1,3)},
				{9,SkillExpFunc(4000,1.22,9,1,3)},
				{10,SkillExpFunc(4000,1.23,10,1,3)},
				{11,SkillExpFunc(4000,1.24,11,1,3)},
				{12,SkillExpFunc(4000,1.23,12,1,3)},
				{13,SkillExpFunc(4000,1.22,13,1,3)},
				{14,SkillExpFunc(4000,1.21,14,1,3)},
				{15,SkillExpFunc(4000,1.20,15,1,3)},
				{16,SkillExpFunc(4000,1.19,16,1,3)},
				{17,SkillExpFunc(4000,1.18,17,1,3)},
				{18,SkillExpFunc(4000,1.17,18,1,3)},
				{19,SkillExpFunc(4000,1.16,19,1,3)},
				{20,SkillExpFunc(4000,1.15,20,1,3)},
			}
		},
	},

	yindao_sheyue={ -- Ng©n §ao X¹ NguyÖt - TÇng 2 NhiÕp Hån NguyÖt ¶nh - Phi ®ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,25},{20,120}}}, -- S¸t th­¬ng vËt lý %
	},

	feidaotang150={ -- Kü n¨ng 150 - Phi ®ao
		physicsenhance_p={{{1,30},{15,180},{20,360},{23,576},{26,684}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		poisondamage_v={{{1,6},{20,38},{23,48},{26,53}},{{1,60},{20,60}},{{1,10},{20,10}}},
		deadlystrike_p={{{1,12},{20,72},{23,90},{26,100}}},
		skill_cost_v={{{1,40},{20,80},{23,92}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1097},{20,1097}}
		},
		skill_showevent={{{1,0},{10,0},{10,4},{20,4}}},
		missle_speed_v={{{1,32},{20,40},{21,40}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
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

	feidaotang150_2={ -- TÇng 2 Kü n¨ng 150 - Phi ®ao
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,30},{20,140},{23,174},{26,192}}},
	},

	baoyu_lihua={ -- B¹o Vò Lª Hoa - Tô tiÔn 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,15},{15,200},{20,400}}}, -- S¸t th­¬ng vËt lý %
		skill_cost_v={{{1,25},{20,65}}}, -- Tiªu hao néi lùc
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		poisondamage_v={{{1,1},{20,20}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		missle_lifetime_v={{{1,18},{20,18*2},{21,18*2}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(12260,1.15,1,1,1)},
				{2,SkillExpFunc(12260,1.15,2,1,1)},
				{3,SkillExpFunc(12260,1.16,3,1,1)},
				{4,SkillExpFunc(12260,1.17,4,1,1)},
				{5,SkillExpFunc(12260,1.18,5,1,1)},
				{6,SkillExpFunc(12260,1.19,6,1,1)},
				{7,SkillExpFunc(12260,1.20,7,1,1)},
				{8,SkillExpFunc(12260,1.21,8,1,1)},
				{9,SkillExpFunc(12260,1.22,9,1,1)},
				{10,SkillExpFunc(12260,1.23,10,1,1)},
				{11,SkillExpFunc(12260,1.24,11,1,2)},
				{12,SkillExpFunc(12260,1.23,12,1,2)},
				{13,SkillExpFunc(12260,1.22,13,1,2)},
				{14,SkillExpFunc(12260,1.21,14,1,2)},
				{15,SkillExpFunc(12260,1.20,15,1,2)},
				{16,SkillExpFunc(12260,1.19,16,1,2)},
				{17,SkillExpFunc(12260,1.18,17,1,2)},
				{18,SkillExpFunc(12260,1.17,18,1,2)},
				{19,SkillExpFunc(12260,1.19,19,1,2)},
				{20,SkillExpFunc(12260,1.15,20,1,2)},
			}
		},
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: Truy Tinh Trôc §iÖn
		skill_flyevent={ -- Kü n¨ng tÇng 2: Truy Tinh Trôc §iÖn
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[2]={{1,30},{20,30},{60,10},{61,10}},
			[3]={{1,301},{20,301}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 2: TuyÖt §Ønh Truy T©m TiÔn
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1244},{20,1244}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,3},{20,3}}}, -- Kü n¨ng tÇng 2-3
	},

	zhuixing_zhudian={ -- Truy Tinh Trôc §iÖn - TÇng 2 B¹o Vò Lª Hoa - Tô tiÔn 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,1},{20,20}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
	},

	nutang150={ -- Kü n¨ng 150 - Tô tiÔn
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,18},{15,240},{20,520},{23,856},{26,1024}}},
		skill_cost_v={{{1,35},{20,100},{23,120}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		poisondamage_v={{{1,1},{20,25},{23,32},{26,36}},{{1,60},{20,60}},{{1,10},{20,10}}},
		missle_lifetime_v={{{1,18},{20,18*2},{21,18*2}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_flyevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[2]={{1,18},{20,18},{60,18},{61,16}},
			[3]={{1,1098},{20,1098}}
		},
		skill_showevent={{{1,0},{10,0},{10,2},{20,2}}},
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

	nutang150_2={ -- TÇng 2 Kü n¨ng 150 - Tô tiÔn
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,18},{15,120},{20,180},{23,252},{26,288}}},
		poisondamage_v={{{1,10},{20,20},{23,23}},{{1,60},{20,60}},{{1,10},{20,10}}},
	},

	jiugong_feixing={ -- Cöu Cung Phi Tinh - Phi tiªu 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,10},{15,80},{20,120}}}, -- S¸t th­¬ng vËt lý %
		deadlystrike_p={{{1,10},{20,30}}}, -- TÊn c«ng chÝ m¹ng %
		poisondamage_v={{{1,1},{20,20}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,30},{20,65}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: T¸n Hoa Tiªu
		skill_startevent={ -- Kü n¨ng tÇng 2: T¸n Hoa Tiªu
			[1]={{1,1},{20,1}},
			[3]={{1,341},{20,341}}
		},
		skill_showevent={{{1,1},{20,1}}}, -- Kü n¨ng tÇng 2: T¸n Hoa Tiªu
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(4680,1.15,1,1,5)},
				{2,SkillExpFunc(4680,1.15,2,1,5)},
				{3,SkillExpFunc(4680,1.16,3,1,5)},
				{4,SkillExpFunc(4680,1.17,4,1,5)},
				{5,SkillExpFunc(4680,1.18,5,1,5)},
				{6,SkillExpFunc(4680,1.19,6,1,5)},
				{7,SkillExpFunc(4680,1.20,7,1,5)},
				{8,SkillExpFunc(4680,1.21,8,1,5)},
				{9,SkillExpFunc(4680,1.22,9,1,5)},
				{10,SkillExpFunc(4680,1.23,10,1,5)},
				{11,SkillExpFunc(4680,1.24,11,1,5)},
				{12,SkillExpFunc(4680,1.23,12,1,5)},
				{13,SkillExpFunc(4680,1.22,13,1,5)},
				{14,SkillExpFunc(4680,1.21,14,1,5)},
				{15,SkillExpFunc(4680,1.20,15,1,5)},
				{16,SkillExpFunc(4680,1.19,16,1,5)},
				{17,SkillExpFunc(4680,1.18,17,1,5)},
				{18,SkillExpFunc(4680,1.17,18,1,5)},
				{19,SkillExpFunc(4680,1.16,19,1,5)},
				{20,SkillExpFunc(4680,1.15,20,1,5)},
			}
		},
	},

	biaotang150={ -- Kü n¨ng 150 - Phi tiªu
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,12},{15,120},{20,355},{23,637},{26,778}}},
		deadlystrike_p={{{1,12},{20,45},{23,55},{26,60}}},
		poisondamage_v={{{1,1},{20,36},{23,47},{26,52}},{{1,60},{20,60}},{{1,10},{20,10}}},
		missle_speed_v={{{1,32},{20,32},{21,32}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,36},{20,90},{23,107}}},
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

	biaotang150_2={ -- TÇng 2 Kü n¨ng 150 - Phi tiªu
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,12},{15,120},{20,355}}},
		deadlystrike_p={{{1,12},{20,45}}},
		poisondamage_v={{{1,1},{20,36}},{{1,60},{20,60}},{{1,10},{20,10}}},
		missle_speed_v={{{1,32},{20,32},{21,32}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,36},{20,90}}},
	},

	biaotang150_3={ -- TÇng 3 Kü n¨ng 150 - Phi tiªu
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,12},{15,120},{20,355}}},
		deadlystrike_p={{{1,12},{20,45}}},
		poisondamage_v={{{1,1},{20,36}},{{1,60},{20,60}},{{1,10},{20,10}}},
		missle_speed_v={{{1,32},{20,32},{21,32}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,36},{20,90}}},
	},

	sanhua_biao={ -- T¸n Hoa Tiªu - Phi tiªu 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,20},{20,200}}}, -- S¸t th­¬ng vËt lý %
		deadlystrike_p={{{1,10},{20,30}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Cöu Cung Phi Tinh - Phi tiªu 90
			[1]={{1,342},{2,342}},
			[3]={{1,1},{20,60}}
		},
		poisondamage_v={{{1,5},{20,20}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		skill_cost_v={{{1,35},{20,35}}}, -- Tiªu hao néi lùc
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
	},

	tangmen120={ -- Kü N¨ng 120: Mª ¶nh Tung
		skill_cost_v={{{1,25},{20,60}}}, -- Tiªu hao néi lùc
		skill_mintimepercast_v={{{1,15*18},{15,7*18},{20,5*18},{21,5*18}}}, -- Thêi gian kh«i phôc chiªu thøc
		skill_mintimepercastonhorse_v={{{1,20*18},{15,10*18},{20,8*18},{21,8*18}}}, -- Thêi gian kh«i phôc chiªu thøc trªn ngùa
		skill_param1_v={{{1,120},{15,360},{20,400},{21,405}}}, -- Kho¶ng c¸ch di h×nh tèi ®a
		skill_desc=
			function(level)
				return "Kho¶ng c¸ch di h×nh tèi ®a: <color=orange>"..floor(Link(level,SKILLS.tangmen120.skill_param1_v[1])).."<color>\n"..
				"Thêi gian kh«i phôc chiªu thøc: <color=orange>"..floor(Link(level,SKILLS.tangmen120.skill_mintimepercast_v[1]) / 18).." gi©y<color>\n"..
				"Thêi gian kh«i phôc chiªu thøc trªn ngùa: <color=orange>"..floor(Link(level,SKILLS.tangmen120.skill_mintimepercastonhorse_v[1]) / 18).." gi©y<color>\n" 
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