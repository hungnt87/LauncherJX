function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										  Kü n¨ng C«n L«n										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	hufeng_fa={ -- H« Phong Ph¸p - §ao 10
		physicsenhance_p={{{1,5},{20,75}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,15},{20,180}},
			[3]={{1,15},{20,180}}
		},
		addskilldamage1={ -- % Kü n¨ng Ng¹o TuyÕt Tiªu Phong - §ao 90
			[1]={{1,372},{2,372}},
			[3]={{1,1},{20,120}}
		},
		addskilldamage2={ -- % Kü n¨ng Cuång Phong SËu §iÖn - §ao 50
			[1]={{1,176},{2,176}},
			[3]={{1,1},{20,35}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,15},{20,15}}} -- Tiªu hao néi lùc
	},

	kunlun_daofa={ -- C«n L«n §ao Ph¸p - Hç trî §ao 10
		addphysicsdamage_p={{{1,35},{20,215}},{{1,-1},{2,-1}},{{1,1},{2,1}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,1},{20,20,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	kunlun_jianfa={ -- C«n L«n KiÕm Ph¸p - Hç trî KiÕm 10
		addlightingmagic_v={{{1,19},{20,215}},{{1,-1},{2,-1}}} -- L«i s¸t - néi c«ng
	},

	qingfeng_fu={ -- Thanh Phong Phï - Hç trî chñ ®éng 10
		fastwalkrun_p={{{1,22},{20,60}},{{1,18*120},{20,18*120}}}, -- Tèc ®é di chuyÓn %
		skill_cost_v={{{1,40},{20,40}}} -- Tiªu hao néi lùc
	},

	jiban_fu={ -- Ki B¸n Phï - Bïa 20
		fastwalkrun_p={{{1,-22},{20,-52}},{{1,18*20},{20,18*90}}}, -- Tèc ®é di chuyÓn %
		skill_cost_v={{{1,60},{20,60}}} -- Tiªu hao néi lùc
	},

	baichuan_nahai={ -- B¸ch Xuyªn N¹p H¶i - Hç trî chñ ®éng 30
		coldres_p={{{1,13},{20,32}},{{1,18*120},{20,18*120}}}, -- Kh¸ng b¨ng %
		physicsres_p={{{1,9},{20,28}},{{1,18*120},{20,18*120}}}, -- Phßng thñ vËt lý %
		skill_cost_v={{{1,12},{20,50}}} -- Tiªu hao néi lùc
	},

	yiqi_sanqing={ -- NhÊt KhÝ Tam Thanh - Hç trî bÞ ®éng 30
		addphysicsdamage_p={{{1,35},{20,250}},{{1,18*120},{20,18*120}},{{1,1},{2,1}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,1},{20,20,Conic}},{{1,18*120},{20,18*120}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	kuanglei_zhendi={ -- Cuång L«i ChÊn §Þa - KiÕm 10
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,27},{20,315}},
			[3]={{1,27},{20,315}}
		},
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng L«i §éng Cöu Thiªn - KiÕm 90
			[1]={{1,375},{2,375}},
			[3]={{1,1},{20,50}}
		},
		addskilldamage2={ -- % Kü n¨ng Ngò L«i Ch¸nh Ph¸p - KiÕm 60
			[1]={{1,182},{2,182}},
			[3]={{1,1},{20,35}}
		},
		skill_attackradius={{{1,320},{20,352}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,15},{20,15}}} -- Tiªu hao néi lùc
	},

	tianqing_dizhuo={ -- Thiªn Thanh §Þa Träc - Hç trî chñ ®éng 30
		lightingres_p={{{1,13},{20,32}},{{1,18*120},{20,18*120}}}, -- Kh¸ng l«i %
		fireres_p={{{1,9},{20,28}},{{1,18*120},{20,18*120}}}, -- Kh¸ng háa %
		coldres_p={{{1,13},{20,32}},{{1,18*120},{20,18*120}}}, -- Kh¸ng b¨ng %
		physicsres_p={{{1,9},{20,28}},{{1,18*120},{20,18*120}}}, -- Phßng thñ vËt lý %
		skill_cost_v={{{1,12},{20,90}}} -- Tiªu hao néi lùc
	},

	qixin_fu={ -- KhÝ T©m Phï
		stun_p={{{1,16},{20,35}},{{1,5},{20,36}}}, -- Lµm cho¸ng %
		skill_cost_v={{{1,100},{20,100}}} -- Tiªu hao néi lùc
	},

	tianji_xunlei={ -- Thiªn TÕ TÊn L«i - KiÕm 30
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,25},{20,650}},
			[3]={{1,25},{20,650}}
		},
		addskilldamage1={ -- % Kü n¨ng L«i §éng Cöu Thiªn - KiÕm 90
			[1]={{1,375},{2,375}},
			[3]={{1,1},{20,60}}
		},
		seriesdamage_p={{{1,1},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,35},{20,35}}} -- Tiªu hao néi lùc
	},

	kuangfeng_zhoudian={ -- Cuång Phong SËu §iÖn - §ao 50
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,55},{20,386}}}, -- S¸t th­¬ng vËt lý %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,45},{20,532}},
			[3]={{1,45},{20,532}}
		},
		stun_p={{{1,5},{20,15},{21,15}},{{1,1},{20,20},{21,20}}}, -- Lµm cho¸ng %
		addskilldamage1={ -- % Kü n¨ng KhiÕu Phong Tam Liªn KÝch - TÇng 2 Ng¹o TuyÕt Tiªu Phong - §ao 90
			[1]={{1,373},{2,373}},
			[3]={{1,1},{20,120}}
		},
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,25},{20,25}}} -- Tiªu hao néi lùc
	},

	wulei_zhengfa={ -- Ngò L«i Ch¸nh Ph¸p - KiÕm 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,25},{20,1000}},
			[3]={{1,25},{20,1000}}
		},
		addskilldamage1={ -- % Kü n¨ng L«i §éng Cöu Thiªn - KiÕm 90
			[1]={{1,375},{2,375}},
			[3]={{1,1},{20,70}}
		},
		skill_attackradius={{{1,448},{20,480},{21,480}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,50},{20,50}}} -- Tiªu hao néi lùc
	},

	shuangao_kunlun={ -- S­¬ng Ng¹o C«n L«n - TrÊn ph¸i 60
		deadlystrikeenhance_p={{{1,1},{30,30,Conic}},{{1,-1},{2,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		castspeed_v={{{1,25},{30,65},{34,73},{35,90},{36,92}},{{1,-1},{30,-1}}}, -- Tèc ®é ®¸nh - néi c«ng %
		attackspeed_v={{{1,25},{20,65},{33,92},{35,118},{38,124},{39,126}},{{1,-1},{30,-1}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
		addlightingmagic_v={{{1,30},{30,315,Conic}},{{1,-1},{2,-1}}}, -- L«i s¸t - néi c«ng
		addlightingdamage_v={{{1,15},{30,215,Conic}},{{1,-1},{2,-1}}}, -- L«i s¸t - ngo¹i c«ng
		lifemax_p={{{1,3},{30,30}},{{1,18*120},{30,18*360}}}, -- Sinh lùc tèi ®a %
	},

	shufu_zhou={ -- Thóc Ph­îc Chó - Bïa 10
		rangedamagereturn_p={{{1,-5},{20,-35}},{{1,18*45},{20,18*120}}}, -- Ph¶n ®ßn tÇm xa %
		skill_cost_v={{{1,30},{20,40}}} -- Tiªu hao néi lùc
	},

	beiming_daohai={ -- B¾c Minh §¸o H¶i - Bïa 30
		lifereplenish_v={{{1,-1},{20,-15}},{{1,18*45},{20,18*120}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		manareplenish_v={{{1,-1},{20,-20}},{{1,18*45},{20,18*120}}}, -- Phôc håi néi lùc mçi nöa gi©y
		skill_cost_v={{{1,30},{20,40}}} -- Tiªu hao néi lùc
	},

	qihan_aoxue={ -- Khi Hµn Ng¹o TuyÕt - Bïa 40
		castspeed_v={{{1,-6},{20,-39},{30,-50},{31,-50}},{{1,18*45},{20,18*120}}}, -- Tèc ®é ®¸nh - néi c«ng %
		skill_cost_v={{{1,30},{20,40}}} -- Tiªu hao néi lùc
	},

	mizhong_huanying={ -- Mª Tung ¶o ¶nh - Bïa 50
		freezetimereduce_p={{{1,-5},{20,-50}},{{1,18*45},{20,18*120}}}, -- Thêi gian lµm chËm %
		stuntimereduce_p={{{1,-5},{20,-50}},{{1,18*45},{20,18*120}}}, -- Thêi gian cho¸ng %
		skill_cost_v={{{1,30},{20,40}}} -- Tiªu hao néi lùc
	},

	zuixian_cuogu={ -- Tóy Tiªn T¸ Cèt - Bïa 90
		fastwalkrun_p={{{1,-12},{20,-52}},{{1,18*45},{20,18*120}}}, -- Tèc ®é di chuyÓn %
		freezetimereduce_p={{{1,-5},{20,-50}},{{1,18*45},{20,18*120}}}, -- Thêi gian lµm chËm %
		stuntimereduce_p={{{1,-5},{20,-50}},{{1,18*45},{20,18*120}}}, -- Thêi gian cho¸ng %
		lifereplenish_v={{{1,-1},{20,-15}},{{1,18*45},{20,18*120}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		manareplenish_v={{{1,-1},{20,-20}},{{1,18*45},{20,18*120}}}, -- Phôc håi néi lùc mçi nöa gi©y
		rangedamagereturn_p={{{1,-5},{20,-35}},{{1,18*45},{20,18*120}}}, -- Ph¶n ®ßn tÇm xa %
		skill_cost_v={{{1,100},{20,160}}} -- Tiªu hao néi lùc
	},

	wusuo_kunlun={ -- Vô Táa C«n L«n
		seriesdamage_p={{{1,20},{20,60}}},
		lightingdamage_v={
			[1]={{1,10},{20,256}},
			[3]={{1,10},{20,256}}
		},
		skill_attackradius={{{1,448},{20,480}}},
		skill_cost_v={{{1,60},{20,85}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,375},{20,375}}
		},
		skill_showevent={{{1,0},{10,0},{10,4},{20,4}}},
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,10}},{{1,0},{2,0}}},
		skill_skillexp_v={{{1,20000},{20,84567890,Conic}}},
	},

	leidong_jiutian={ -- L«i §éng Cöu Thiªn - KiÕm 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,80},{15,260},{20,470}},
			[3]={{1,80},{15,260},{20,470}}
		},
		skill_cost_v={{{1,40},{15,60},{20,60}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_collideevent={ -- Kü n¨ng tÇng 3: B×nh §Þa H¸m L«i
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,387},{20,387}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 2: Thiªn L«i ChÊn Nh¹c
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1242},{20,1242}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}}, -- Kü n¨ng tÇng 2-3
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(5330,1.15,1,8,1)},
				{2,SkillExpFunc(5330,1.15,2,8,1)},
				{3,SkillExpFunc(5330,1.16,3,8,1)},
				{4,SkillExpFunc(5330,1.17,4,8,1)},
				{5,SkillExpFunc(5330,1.18,5,8,1)},
				{6,SkillExpFunc(5330,1.19,6,8,1)},
				{7,SkillExpFunc(5330,1.20,7,8,1)},
				{8,SkillExpFunc(5330,1.21,8,8,1)},
				{9,SkillExpFunc(5330,1.22,9,8,1)},
				{10,SkillExpFunc(5330,1.23,10,8,1)},
				{11,SkillExpFunc(5330,1.24,11,8,1)},
				{12,SkillExpFunc(5330,1.23,12,8,1)},
				{13,SkillExpFunc(5330,1.22,13,8,1)},
				{14,SkillExpFunc(5330,1.21,14,8,1)},
				{15,SkillExpFunc(5330,1.20,15,8,1)},
				{16,SkillExpFunc(5330,1.19,16,8,1)},
				{17,SkillExpFunc(5330,1.18,17,8,1)},
				{18,SkillExpFunc(5330,1.17,18,8,1)},
				{19,SkillExpFunc(5330,1.16,19,8,1)},
				{20,SkillExpFunc(5330,1.15,20,8,1)},
			}
		},
	stun_p={{{1,10},{20,20},{25,40},{26,40}},{{1,1},{20,6},{21,6}}}, -- Lµm cho¸ng %
	},

	jiankunlun150={ -- TÇng 2 Kü n¨ng 150 - KiÕm
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		lightingdamage_v={
			[1]={{1,192},{15,624},{20,1130},{23,1737},{26,2040}},
			[3]={{1,192},{15,624},{20,1130},{23,1737},{26,2040}}
		},
	},

	jiankunlun150fu={ -- Kü n¨ng 150 - KiÕm
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		stun_p={{{1,16},{20,35},{23,41},{26,44}},{{1,1},{20,20},{21,21}}},
		lightingdamage_v={
			[1]={{1,25},{20,150}},
			[3]={{1,25},{20,150}}
		},
		skill_cost_v={{{1,48},{15,72},{20,115},{23,166},{26,192}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_vanishedevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1109},{20,1109}}
		},
		skill_showevent={{{1,0},{10,0},{10,8},{20,8}}},
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

	pingdi_hanlei={ -- B×nh §Þa H¸m L«i - TÇng 3 L«i §éng Cöu Thiªn - KiÕm 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,25},{20,150}},
			[3]={{1,25},{20,150}}
		},
	},

	aoxue_xiaofeng={ -- Ng¹o TuyÕt Tiªu Phong - §ao 90
		physicsenhance_p={{{1,5},{15,100},{20,280}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,39},{15,200},{20,673}},
			[3]={{1,39},{15,200},{20,673}}
		},
		stun_p={{{1,5},{20,25},{21,25}},{{1,1},{20,12},{21,12}}}, -- Lµm cho¸ng %
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,25},{20,45}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_startevent={ -- Kü n¨ng tÇng 2: Cuång Phong SËu §iÖn - §ao 50
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,176},{20,176}}
		},
		skill_collideevent={ -- Kü n¨ng tÇng 3: KhiÕu Phong Tam Liªn KÝch
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,373},{20,373}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}}, -- Kü n¨ng tÇng 2-3
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(6860,1.15,1,5,1)},
				{2,SkillExpFunc(6860,1.15,2,5,1)},
				{3,SkillExpFunc(6860,1.16,3,5,1)},
				{4,SkillExpFunc(6860,1.17,4,5,1)},
				{5,SkillExpFunc(6860,1.18,5,5,1)},
				{6,SkillExpFunc(6860,1.19,6,5,1)},
				{7,SkillExpFunc(6860,1.20,7,5,1)},
				{8,SkillExpFunc(6860,1.21,8,5,1)},
				{9,SkillExpFunc(6860,1.22,9,5,1)},
				{10,SkillExpFunc(6860,1.23,10,5,1)},
				{11,SkillExpFunc(6860,1.24,11,5,1)},
				{12,SkillExpFunc(6860,1.23,12,5,1)},
				{13,SkillExpFunc(6860,1.22,13,5,1)},
				{14,SkillExpFunc(6860,1.21,14,5,1)},
				{15,SkillExpFunc(6860,1.20,15,5,1)},
				{16,SkillExpFunc(6860,1.19,16,5,1)},
				{17,SkillExpFunc(6860,1.18,17,5,1)},
				{18,SkillExpFunc(6860,1.17,18,5,1)},
				{19,SkillExpFunc(6860,1.16,19,5,1)},
				{20,SkillExpFunc(6860,1.15,20,5,1)},
			}
		},
	},

	daokunlun150={ -- Kü n¨ng 150 - §ao
		physicsenhance_p={{{1,6},{15,120},{20,335},{23,593},{26,722}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		lightingdamage_v={
			[1]={{1,48},{15,240},{20,806},{23,1485},{26,1824}},
			[3]={{1,48},{15,240},{20,806},{23,1485},{26,1824}}
		},
		stun_p={{{1,6},{20,30},{21,30}},{{1,1},{20,12},{21,12}}},
		missle_speed_v={{{1,28},{20,32},{21,32}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,30},{20,55},{23,62}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1108},{20,1108}}
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

	daokunlun150_2={ -- TÇng 2 Kü n¨ng 150 - §ao
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		missle_lifetime_v={{{1,6},{20,24},{21,24}}},
		lightingdamage_v={
			[1]={{1,105},{20,395},{23,486},{26,532}},
			[3]={{1,135},{20,660},{23,825},{26,908}}
		},
	},

	yufeng_shu={ -- Ngù Phong ThuËt
		seriesdamage_p={{{1,20},{20,60},{21,62}}},
		physicsenhance_p={{{1,28},{20,282}}},
	},

	xiaofeng_sanlianji={ -- KhiÕu Phong Tam Liªn KÝch - TÇng 2 Ng¹o TuyÕt Tiªu Phong - §ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		missle_lifetime_v={{{1,6},{20,24},{21,24}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,15},{20,150}},
			[3]={{1,30},{20,300}}
		},
	},

	xuantianwuji={	-- HuyÒn Thiªn V« Cùc - Hç trî bÞ ®éng
		dynamicmagicshield_v={{{1,50},{10,230},{15,370},{20,550},{21,550}},{{1,-1},{20,-1}}}, -- Néi lùc hé th©n
		returnres_p={{{1,5},{20,30},{21,30}},{{1,-1},{20,-1}}}, -- Kh¸ng ph¶n ®ßn %
	},

	kunlun120={ -- Kü n¨ng 120: L­ìng Nghi Ch©n KhÝ
		autorescueskill={{{1,721*256 + 1},{20,721*256 + 20},{21,721*256 + 21}},{{1,-1},{20,-1}},{{1,20*18*256 + 15},{15,20*18*256 + 60},{20,20*18*256 + 65},{21,20*18*256 + 65}}},
		skill_desc=
			function(level)
				return "Khi sinh lùc thÊp h¬n 25% cã x¸c suÊt <color=orange>"..floor(Link(level,SKILLS.kunlun120.autorescueskill[3]) - 20*18*256).."%<color> ph¸t chiªu L­ìng Nghi Ch©n KhÝ \n"..
				"Ch©n khÝ chèng l¹i s¸t th­¬ng gÊp <color=orange>"..floor(Link(level,SKILLS.kunlun120mofadun.staticmagicshield_p[1]) / 100)..
				" lÇn<color> møc néi lùc trong <color=orange>"..floor(Link(level,SKILLS.kunlun120mofadun.staticmagicshield_p[2]) / 18).." gi©y<color>\n"..
				" vµ t¨ng <color=orange>"..floor((Link(level,SKILLS.kunlun120jiasu.fastwalkrun_p[1]))).."%<color> tèc ®é di chuyÓn trong <color=orange>"
				..floor(Link(level,SKILLS.kunlun120jiasu.fastwalkrun_p[2]) / 18).." gi©y<color>\n"..
				"Trong vßng <color=orange>"..floor((Link(level,SKILLS.kunlun120.autorescueskill[3]) / (18*256))).." gi©y<color> sau míi cã thÓ thi triÓn tiÕp"
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

	kunlun120mofadun={ -- L­ìng Nghi Ch©n KhÝ - BÊt tö
		staticmagicshield_p={{{1,1800},{15,9750},{20,10000},{21,10050}},{{1,5*18},{15,9*18},{20,10*18},{21,10*18}}},
	},

	kunlun120jiasu={ -- L­ìng Nghi Ch©n KhÝ - Tèc ®é
		fastwalkrun_p={{{1,5},{15,30},{20,35},{21,36}},{{1,3*18},{15,9*18},{20,10*18},{21,10*18}}}, -- Tèc ®é di chuyÓn %
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