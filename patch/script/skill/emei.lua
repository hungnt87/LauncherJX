function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										   Kü n¨ng Nga My										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	piaoyun_chuanxue={ -- Phiªu TuyÕt Xuyªn V©n - Ch­ëng 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,15},{20,275}},
			[3]={{1,25},{20,415}}
		},
		addskilldamage2={ -- % Kü n¨ng Phong S­¬ng To¸i ¶nh - Ch­ëng 90
			[1]={{1,380},{2,380}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage1={ -- % Kü n¨ng PhËt Quang Phæ ChiÕu - Ch­ëng 60
			[1]={{1,91},{2,91}},
			[3]={{1,1},{20,50}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,10}}} -- Tiªu hao néi lùc
	},

	emei_jianfa={ -- Nga My KiÕm Ph¸p - Hç trî KiÕm 10
		addphysicsdamage_p={{{1,15},{20,250}},{{1,-1},{2,-1}},{{1,0},{2,0}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,6},{20,45}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	emei_zhangfa={ -- Nga My Ch­ëng Ph¸p - Hç trî Ch­ëng 10
		addcoldmagic_v={{{1,15},{20,550}},{{1,-1},{2,-1}}} -- B¨ng s¸t - néi c«ng
	},

	sixiang_tonggui={ -- Tø T­îng §ång Quy - Ch­ëng 30
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,35},{20,335}},
			[3]={{1,45},{20,500}}
		},
		addskilldamage1={ -- % Kü n¨ng Kim §Ønh PhËt Quang - TÇng 2 Phong S­¬ng To¸i ¶nh - Ch­ëng 90
			[1]={{1,331},{2,331}},
			[3]={{1,1},{20,100}}
		},
		skill_attackradius={{{1,384},{20,416}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,25},{20,35}}} -- Tiªu hao néi lùc
	},

	yiye_zhiqiu={ -- NhÊt DiÖp Tri Thu - KiÕm 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,30},{20,100}}}, -- S¸t th­¬ng vËt lý %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,80}},
			[3]={{1,10},{20,80}}
		},
		deadlystrike_p={{{1,10},{20,20}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Tam Nga TÒ TuyÕt - KiÕm 90
			[1]={{1,328},{2,328}},
			[3]={{1,1},{20,150}}
		},
		addskilldamage2={ -- % Kü n¨ng BÊt DiÖt BÊt TuyÖt - KiÕm 60
			[1]={{1,88},{2,88}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,25},{20,25}}} -- Tiªu hao néi lùc
	},

	liushui={ -- L­u Thñy - Hç trî bÞ ®éng 40 (Aura)
		fastwalkrun_p={{{1,9},{20,66}},{{1,18*8},{2,18*8}}} -- Tèc ®é di chuyÓn %
	},

	bumie_bujue={ -- BÊt DiÖt BÊt TuyÖt - KiÕm 60
		physicsenhance_p={{{1,80},{20,385}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,282}},
			[3]={{1,10},{20,282}}
		},
		deadlystrike_p={{{1,15},{20,54}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Tam Nga TÒ TuyÕt - KiÕm 90
			[1]={{1,328},{2,328}},
			[3]={{1,1},{20,180}}
		},
		missle_speed_v={{{1,28},{20,32},{21,32}}},  -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,30},{20,35}}} -- Tiªu hao néi lùc
	},

	mengdie={ -- Méng §iÖp - Hç trî bÞ ®éng 30 (Aura)
		lifereplenish_v={{{1,1},{20,20}},{{1,18*8},{2,18*8}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		manareplenish_v={{{1,1},{20,20}},{{1,18*8},{2,18*8}}}, -- Phôc håi néi lùc mçi nöa gi©y
	},

	foguang_puzhao={ -- PhËt Quang Phæ ChiÕu - Ch­ëng 60
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,80},{20,800}},
			[3]={{1,80},{20,1300}}
		},
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage2={ -- % Kü n¨ng Phong S­¬ng To¸i ¶nh - Ch­ëng 90
			[1]={{1,380},{2,380}},
			[3]={{1,1},{20,120}}
		},
		skill_cost_v={{{1,30},{20,60}}} -- Tiªu hao néi lùc
	},

	cihang_pudu={ -- Tõ Hµng Phæ §é - Hç trî chñ ®éng 20
		lifereplenish_v={{{1,275},{20,750}},{{1,36},{2,36}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		skill_cost_v={{{1,100},{20,100}}} -- Tiªu hao néi lùc
	},

	fofa_wubian={ -- PhËt Ph¸p V« Biªn - TrÊn ph¸i 60
		addcoldmagic_v={{{1,30},{30,315}},{{1,-1},{2,-1}}}, -- B¨ng s¸t - néi c«ng
		addcolddamage_v={{{1,70},{30,315}},{{1,-1},{2,-1}}}, -- B¨ng s¸t - ngo¹i c«ng
		attackspeed_v={{{1,12},{30,65},{33,70},{35,90},{38,95},{41,100}},{{1,-1},{2,-1}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
		castspeed_v={{{1,12},{30,65},{33,70},{35,90},{38,95},{41,100}},{{1,-1},{2,-1}}}, -- Tèc ®é ®¸nh - néi c«ng %
		coldenhance_p={{{1,8},{30,37}},{{1,-1},{2,-1}}}, -- Thêi gian tr× ho·n %
	},

	foxin_ciyou={ -- PhËt T©m Tõ H÷u - Hç trî bÞ ®éng 50 (Aura)
		lifemax_p={{{1,30},{20,125}},{{1,18*8},{2,18*8}}}, -- Sinh lùc tèi ®a %
	},

	tuichuang_wangyue={ -- Th«i Song Väng NguyÖt - KiÕm 30
		physicsenhance_p={{{1,40},{20,175}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,120}},
			[3]={{1,10},{20,120}}
		},
		deadlystrike_p={{{1,10},{20,30}}}, -- TÊn c«ng chÝ m¹ng %
		addskilldamage1={ -- % Kü n¨ng Ngäc TuyÒn TÈy TrÇn - TÇng 2 Tam Nga TÒ TuyÕt - KiÕm 90
			[1]={{1,329},{2,329}},
			[3]={{1,1},{20,150}}
		},
		addskilldamage2={
			[1]={{1,1091},{2,1091}},
			[3]={{1,1},{20,40}}
		},
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,20}}} -- Tiªu hao néi lùc
	},

	qingyin_fanchang={ -- Thanh ¢m Ph¹n X­íng - Hç trî bÞ ®éng 60 (Aura)
		fasthitrecover_v={{{1,1},{20,20},{31,31},{32,31}},{{1,18*8},{2,18*8}}}, -- Thêi gian phôc håi
		fatallystrikeres_p={{{1,1},{20,20}},{{1,18*8},{2,18*8}}}, -- Kh¸ng ®ßn chÝ m¹ng %
		freezetimereduce_p={{{1,1},{20,30}},{{1,18*8},{2,18*8}}}, -- Thêi gian lµm chËm %
		poisontimereduce_p={{{1,1},{20,30}},{{1,18*8},{2,18*8}}}, -- Thêi gian tróng ®éc %
		stuntimereduce_p={{{1,1},{20,30}},{{1,18*8},{2,18*8}}} -- Thêi gian cho¸ng %
	},

	pudu_zhongsheng={ -- Phæ §é Chóng Sinh - Hç trî bÞ ®éng 90 (Aura)
		lifereplenish_v={{{1,2},{20,40}},{{1,18*8},{2,18*8}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		manareplenish_v={{{1,2},{20,40}},{{1,18*8},{2,18*8}}}, -- Phôc håi néi lùc mçi nöa gi©y
		allres_p={{{1,1},{20,40}},{{1,18*8},{2,18*8}}} -- Kh¸ng tÊt c¶ %
	},

	sane_jixue={ -- Tam Nga TÒ TuyÕt - KiÕm 90
		physicsenhance_p={{{1,10},{15,100},{20,237}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,111}},
			[3]={{1,10},{20,111}}
		},
		deadlystrike_p={{{1,10},{20,54}}}, -- TÊn c«ng chÝ m¹ng %
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,35},{20,35}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: Ngäc TuyÒn TÈy TrÇn
		skill_startevent={ -- Kü n¨ng tÇng 2: Ngäc TuyÒn TÈy TrÇn
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,329},{20,329}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{20,1}}}, -- Kü n¨ng tÇng 2: Ngäc TuyÒn TÈy TrÇn
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={  -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(5000,1.25,1,3,1)},
				{2,SkillExpFunc(5000,1.15,2,3,1)},
				{3,SkillExpFunc(5000,1.16,3,3,1)},
				{4,SkillExpFunc(5000,1.17,4,3,1)},
				{5,SkillExpFunc(5000,1.18,5,3,1)},
				{6,SkillExpFunc(5000,1.19,6,3,1)},
				{7,SkillExpFunc(5000,1.20,7,3,1)},
				{8,SkillExpFunc(5000,1.21,8,3,1)},
				{9,SkillExpFunc(5000,1.22,9,3,1)},
				{10,SkillExpFunc(5000,1.23,10,3,1)},
				{11,SkillExpFunc(5000,1.24,11,3,1)},
				{12,SkillExpFunc(5000,1.23,12,3,1)},
				{13,SkillExpFunc(5000,1.22,13,3,1)},
				{14,SkillExpFunc(5000,1.21,14,3,1)},
				{15,SkillExpFunc(5000,1.20,15,3,1)},
				{16,SkillExpFunc(5000,1.19,16,3,1)},
				{17,SkillExpFunc(5000,1.18,17,3,1)},
				{18,SkillExpFunc(5000,1.17,18,3,1)},
				{19,SkillExpFunc(5000,1.16,19,3,1)},
				{20,SkillExpFunc(5000,1.15,20,3,1)},
			}
		},
	},
	
	yuquan_xichen={ -- Ngäc TuyÒn TÈy TrÇn - TÇng 2 Tam Nga TÒ TuyÕt - KiÕm 90
		physicsenhance_p={{{1,30},{20,150}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		deadlystrike_p={{{1,10},{20,20}}}, -- TÊn c«ng chÝ m¹ng %
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 3: TuyÖt §Ønh Thiªn KiÕm
		skill_startevent={ -- Kü n¨ng tÇng 3: TuyÖt §Ønh Thiªn KiÕm
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1245},{20,1245}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{20,1}}}, -- Kü n¨ng tÇng 3: TuyÖt §Ønh Thiªn KiÕm
	},

	tuyetdinhthienkiem={ -- TuyÖt §Ønh Thiªn KiÕm
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,50}},
			[3]={{1,10},{20,50}},
		},
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		missle_speed_v={{{1,24},{20,28},{21,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_misslenum_v={{{1,1},{10,1},{20,3},{29,3},{30,4},{31,4}}}, -- Sè l­îng Missle
	},

	jianemei150={ -- Kü n¨ng 150 - KiÕm
		physicsenhance_p={{{1,12},{15,120},{20,285},{23,483},{26,582}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		colddamage_v={
			[1]={{1,20},{20,195},{23,250},{26,277}},
			[3]={{1,20},{20,195},{23,250},{26,277}}
		},
		deadlystrike_p={{{1,12},{20,65},{23,81},{26,90}}},
		missle_speed_v={{{1,36},{20,36},{21,36}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,45},{20,45}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_startevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1089},{20,1089}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{20,1}}},
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
				{20,90000},
				{21,120000},
				{22,150000},
				{23,200000},
				{24,250000},
				{25,300000},
			}
		},	
	},

	jianemei150_2={ -- TÇng 2 Kü n¨ng 150 - KiÕm
		physicsenhance_p={{{1,36},{20,175},{23,218},{26,240}}},
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		deadlystrike_p={{{1,12},{20,24},{23,27}}},
		colddamage_v={
			[1]={{1,10},{20,110},{23,141},{26,157}},
			[3]={{1,10},{20,110},{23,141},{26,157}}
		},
	},

	qianfo_qianye={ -- Thiªn PhËt Thiªn DiÖp - Ch­ëng
		colddamage_v={
			[1]={{1,45},{20,100}},
			[3]={{1,45},{20,100}}
		},
		seriesdamage_p={{{1,20},{20,60},{21,62}}},
		skill_attackradius={{{1,448},{20,512}}},
		skill_cost_v={{{1,30},{20,65}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_startevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,380},{20,380}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{20,1}}},
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,10}},{{1,0},{2,0}}},
		skill_skillexp_v={{{1,20000},{20,100000000,Conic}}},
	},

	fengshuang_suiying={ -- Phong S­¬ng To¸i ¶nh - Ch­ëng 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,30},{15,400},{20,1000}},
			[3]={{1,30},{15,400},{20,1000}}
		},
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: Kim §Ønh PhËt Quang
		skill_cost_v={{{1,30},{20,65}}}, -- Tiªu hao néi lùc
		skill_startevent={ -- Kü n¨ng tÇng 2: Kim §Ønh PhËt Quang
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,331},{20,331}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{20,1}}}, -- Kü n¨ng tÇng 2: Kim §Ønh PhËt Quang
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(6260,1.25,1,3,1)},
				{2,SkillExpFunc(6260,1.15,2,3,1)},
				{3,SkillExpFunc(6260,1.16,3,3,1)},
				{4,SkillExpFunc(6260,1.17,4,3,1)},
				{5,SkillExpFunc(6260,1.18,5,3,1)},
				{6,SkillExpFunc(6260,1.19,6,3,1)},
				{7,SkillExpFunc(6260,1.20,7,3,1)},
				{8,SkillExpFunc(6260,1.21,8,3,1)},
				{9,SkillExpFunc(6260,1.22,9,3,1)},
				{10,SkillExpFunc(6260,1.23,10,3,1)},
				{11,SkillExpFunc(6260,1.24,11,3,1)},
				{12,SkillExpFunc(6260,1.23,12,3,1)},
				{13,SkillExpFunc(6260,1.22,13,3,1)},
				{14,SkillExpFunc(6260,1.21,14,3,1)},
				{15,SkillExpFunc(6260,1.20,15,3,1)},
				{16,SkillExpFunc(6260,1.19,16,3,1)},
				{17,SkillExpFunc(6260,1.18,17,3,1)},
				{18,SkillExpFunc(6260,1.17,18,3,1)},
				{19,SkillExpFunc(6260,1.16,19,3,1)},
				{20,SkillExpFunc(6260,1.15,20,3,1)},
			}
		},
	},

	jinding_foguang={ -- Kim §Ønh PhËt Quang - TÇng 2 Phong S­¬ng To¸i ¶nh - Ch­ëng 90
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,585},{21,600}},
			[3]={{1,10},{20,585},{21,600}},
		},
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		missle_speed_v={{{1,24},{20,28},{21,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_misslenum_v={{{1,1},{10,1},{20,3},{29,3},{30,4},{31,4}}}, -- Sè l­îng Missle
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: Tø T­îng §ång Quy
		skill_startevent={ -- Kü n¨ng tÇng 2: Tø T­îng §ång Quy
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,82},{20,82}}
		},
		skill_showevent={{{1,0},{15,0},{15,1},{20,1}}}, -- Kü n¨ng tÇng 2: Tø T­îng §ång Quy
	},

	zhangemei150={ -- Kü n¨ng 150 - Ch­ëng
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		colddamage_v={
			[1]={{1,24},{15,420},{20,930},{23,1542},{26,1848}},
			[3]={{1,36},{15,480},{20,1200},{23,2064},{26,2496}}
		},
		skill_cost_v={{{1,36},{20,78},{23,91}}},
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
				{20,90000},
				{21,120000},
				{22,150000},
				{23,200000},
				{24,250000},
				{25,300000},
			}
		},	
	},
	zhangemei150_2={ -- TÇng 2 Kü n¨ng 150 - Ch­ëng
		colddamage_v={
			[1]={{1,10},{20,585},{21,600}},
			[3]={{1,10},{20,585},{21,600}},
		},
		seriesdamage_p={{{1,20},{20,60},{21,62}}},
		missle_speed_v={{{1,24},{20,28},{21,28}}},
		skill_misslenum_v={{{1,1},{10,1},{20,3},{21,3}}},
	},

	emei120={ -- Kü n¨ng 120: BÕ NguyÖt PhÊt TrÇn
		skill_appendskill={{{1,86},{20,86}},{{1,1},{19,19},{20,40},{21,40}}},
		skill_desc=
			function(level)
				return "§¼ng cÊp kü n¨ng nµy sÏ lÊy theo kü n¨ng hç trî cã cÊp thÊp nhÊt \n"
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

	emei120_1={ -- Kü n¨ng 120: BÕ NguyÖt PhÊt TrÇn
		skill_appendskill={{{1,89},{20,89}},{{1,1},{19,19},{20,40},{21,40}}},
	},

	emei120_2={ -- Kü n¨ng 120: BÕ NguyÖt PhÊt TrÇn
		skill_appendskill={{{1,92},{20,92}},{{1,1},{19,19},{20,40},{21,40}}},
	},

	emei120_3={ -- Kü n¨ng 120: BÕ NguyÖt PhÊt TrÇn
		skill_appendskill={{{1,282},{20,282}},{{1,1},{19,19},{20,40},{21,40}}},
	},

	emei120_4={ -- Kü n¨ng 120: BÕ NguyÖt PhÊt TrÇn
		skill_appendskill={{{1,332},{20,332}},{{1,1},{19,19},{20,40},{21,40}}},
	},

	fuzhuemei150={ -- Kü n¨ng 150 - Hç trî chñ ®éng
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}},
		colddamage_v={
			[1]={{1,20},{15,200},{20,400},{23,640},{26,760}},
			[3]={{1,30},{15,200},{20,500},{23,860},{26,1040}}
		},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_cost_v={{{1,30},{20,65},{23,76}}},
		skill_flyevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[2]={{1,20},{20,20}},
			[3]={{1,1115},{20,1115}}
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
				{20,90000},
				{21,120000},
				{22,150000},
				{23,200000},
				{24,250000},
				{25,300000},
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