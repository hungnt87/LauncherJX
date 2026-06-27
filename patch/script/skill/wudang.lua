function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										  Kü n¨ng Vâ §ang										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	nulei_zhi={ -- Né L«i ChØ - Ch­ëng 10
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,1},{20,25}},
			[3]={{1,1},{20,75}}
		},
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng Thiªn §Þa V« Cùc - Ch­ëng 90
			[1]={{1,365},{2,365}},
			[3]={{1,1},{20,100}}
		},
		addskilldamage2={ -- % Kü n¨ng V« Ng· V« KiÕm - Ch­ëng 60
			[1]={{1,165},{2,165}},
			[3]={{1,1},{20,80}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,15},{20,20}}} -- Tiªu hao néi lùc
	},

	wudang_jianfa ={ -- Vâ §ang KiÕm Ph¸p - Hç trî KiÕm 10
		addphysicsdamage_p={{{1,25},{20,300}},{{1,-1},{2,-1}},{{1,0},{2,0}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		attackratingenhance_p={{{1,15},{20,500}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c %
		deadlystrikeenhance_p={{{1,6},{20,25,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	wudang_quanfa={ -- Vâ §ang QuyÒn Ph¸p - Hç trî Ch­ëng 10
		manashield_p={{{1,-5},{15,-15},{19,-20},{20,-25},{21,-25}},{{1,-1},{20,-1}}}, -- Néi lùc hé th©n %
		addlightingmagic_v={{{1,20},{15,250},{20,915},{25,1115},{26,1248}},{{1,-1},{2,-1}}} -- L«i s¸t - néi c«ng
	},

	canghai_mingyue={ -- Th­¬ng H¶i Minh NguyÖt - KiÕm 10
		physicsenhance_p={{{1,5},{20,75}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,6},{20,12}},
			[3]={{1,6},{20,115}}
		},
		addskilldamage1={ -- % Kü n¨ng Nh©n KiÕm Hîp NhÊt - KiÕm 90
			[1]={{1,368},{2,368}},
			[3]={{1,1},{20,140}}
		},
		addskilldamage2={ -- % Kü n¨ng Tam Hoµn Thao NguyÖt - KiÕm 60
			[1]={{1,267},{2,267}},
			[3]={{1,1},{20,100}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,15}}} -- Tiªu hao néi lùc
	},

	zuowang_wuwo={ -- Täa Väng V« Ng· - Hç trî chñ ®éng 50
		manashield_p={{{1,25},{5,75},{20,99},{21,100},{22,100}},{{1,18*120},{20,18*180}}}, -- Néi lùc hé th©n %
		manareplenish_v={{{1,5},{20,50}},{{1,18*120},{2,18*180}}}, -- Phôc håi néi lùc mçi nöa gi©y
		skill_cost_v={{{1,60},{20,160}}} -- Tiªu hao néi lùc

	},

	jianfei_jingtian={ -- KiÕm Phi Kinh Thiªn - KiÕm 30
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,20},{20,115}}}, -- S¸t th­¬ng vËt lý %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,10},{20,24}},
			[3]={{1,10},{20,225}}
		},
		addskilldamage1={ -- % Kü n¨ng HuyÒn NhÊt V« T­îng - TÇng 3 Nh©n KiÕm Hîp NhÊt - KiÕm 90
			[1]={{1,162},{2,162}},
			[3]={{1,3},{20,250}}
		},
		skill_attackradius={{{1,384},{20,416}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,25}}} -- Tiªu hao néi lùc
	},

	qingxing_zhen={ -- ThÊt Tinh TrËn - Hç trî bÞ ®éng 20 (Aura)
		attackratingenhance_p={{{1,24},{20,450}},{{1,18},{2,18}}}, -- TØ lÖ c«ng kÝch chÝ chính x¸c %
		energy_v={{{1,5},{20,100}},{{1,18},{2,18}}}, -- Néi c«ng
		adddefense_v={{{1,97},{20,800}},{{1,18},{20,18}}}, -- NÐ tr¸nh 
	},

	tiyun_zong={ -- ThÕ V©n Tung - Hç trî bÞ ®éng 40
		fastwalkrun_p={{{1,18},{20,60}},{{1,-1},{20,-1}}}, -- Tèc ®é di chuyÓn %
		attackratingenhance_v={{{1,100},{20,3000}},{{1,-1},{2,-1}}}, -- TØ lÖ c«ng kÝch chÝnh x¸c
	},

	boji_erfu={ -- B¸c CÊp Nhi Phôc - Ch­ëng 30
		seriesdamage_p={{{1,5},{20,30}}},
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,5},{20,15}},
			[3]={{1,5},{20,275}}
		},
		stun_p={{{1,10},{20,10}},{{1,1},{20,20}}}, -- Lµm cho¸ng %
		addskilldamage1={ -- % Kü n¨ng Thiªn §Þa V« Cùc - Ch­ëng 90
			[1]={{1,365},{2,365}},
			[3]={{1,1},{20,120}}
		},
		skill_attackradius={{{1,512},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,60},{20,70}}} -- Tiªu hao néi lùc
	},

	wuwo_wujian={ -- V« Ng· V« KiÕm - Ch­ëng 60
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,1},{20,5}},
			[3]={{1,5},{20,800}}
		},
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng Thiªn §Þa V« Cùc - Ch­ëng 90
			[1]={{1,365},{2,365}},
			[3]={{1,3},{20,150}}
		},
		stun_p={{{1,5},{20,20}},{{1,1},{20,10},{21,10}}}, -- Lµm cho¸ng %
		skill_misslenum_v={{{1,1},{20,8},{21,8}}}, -- Sè l­îng Missle
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,70},{20,130}}} -- Tiªu hao néi lùc
	},

	taiji_shengong={ -- Th¸i Cùc ThÇn C«ng - TrÊn ph¸i 60
		attackspeed_v={{{1,21},{30,65},{33,69},{35,90},{38,94},{41,98}},{{1,-1},{30,-1}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
		castspeed_v={{{1,21},{30,65},{33,69},{35,81},{41,90},{44,94}},{{1,-1},{30,-1}}}, -- Tèc ®é ®¸nh - néi c«ng %
		addlightingdamage_v={{{1,20},{20,300}},{{1,-1},{2,-1}}}, -- L«i s¸t - néi c«ng
		manamax_p={{{1,35},{30,245}},{{1,-1},{2,-1}}}, -- Néi lùc tèi ®a
		manareplenish_v={{{1,1},{30,30}},{{1,-1},{2,-1}}}, -- Phôc håi néi lùc mçi nöa gi©y
		deadlystrikeenhance_p={{{1,5},{30,25}},{{1,-1},{2,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		lightingenhance_p={{{1,16},{30,100},{33,108},{38,108},{41,116}},{{1,-1},{2,-1}}}, -- L«i s¸t tæi thiÓu %
	},

	sanhuan_taoyue={ -- Tam Hoµn Thao NguyÖt - KiÕm 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,20},{20,231}}}, -- S¸t th­¬ng vËt lý %
		attackrating_p={{{1,65},{20,345}}}, -- §é chÝnh x¸c %
		stealmana_p={{{1,1},{20,5}}}, -- Hót néi lùc %
		deadlystrike_p={{{1,16},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		stun_p={{{1,1},{20,10}},{{1,1},{20,10},{21,10}}}, -- Lµm cho¸ng %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,6},{20,20}},
			[3]={{1,6},{20,386}}
		},
		addskilldamage1={ -- % Kü n¨ng Nh©n KiÕm Hîp NhÊt - KiÕm 90
			[1]={{1,368},{2,368}},
			[3]={{1,1},{20,180}}
		},
		missle_speed_v={{{1,26},{20,26}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,78},{20,78}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,15},{20,40}}} -- Tiªu hao néi lùc
	},

	tiandi_wuji={ -- Thiªn §Þa V« Cùc - Ch­ëng 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,5},{20,8}},
			[3]={{1,5},{15,150},{20,350}}
		},
		skill_attackradius={{{1,448},{20,512},{20,512}}}, -- Ph¹m vi hiÖu qu¶
		missle_lifetime_v={{{1,8},{20,20},{21,20}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		stun_p={{{1,10},{20,20},{25,30},{26,30}},{{1,1},{20,6},{21,6}}}, -- Lµm cho¸ng %
		skill_cost_v={{{1,60},{20,150}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: B¸c CÊp Nhi Phôc - Ch­ëng 30
		skill_startevent={ -- Kü n¨ng tÇng 2: B¸c CÊp Nhi Phôc - Ch­ëng 30
			[1]={{1,1},{20,1}},
			[3]={{1,164},{20,164}}
		},
		skill_showevent={{{1,1},{20,1}}}, -- Kü n¨ng tÇng 2: B¸c CÊp Nhi Phôc - Ch­ëng 30
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(5880,1.15,1,5,1)},
				{2,SkillExpFunc(5880,1.15,2,5,1)},
				{3,SkillExpFunc(5880,1.16,3,5,1)},
				{4,SkillExpFunc(5880,1.17,4,5,1)},
				{5,SkillExpFunc(5880,1.18,5,5,1)},
				{6,SkillExpFunc(5880,1.19,6,5,1)},
				{7,SkillExpFunc(5880,1.20,7,5,1)},
				{8,SkillExpFunc(5880,1.21,8,5,1)},
				{9,SkillExpFunc(5880,1.22,9,5,1)},
				{10,SkillExpFunc(5880,1.23,10,5,1)},
				{11,SkillExpFunc(5880,1.24,11,5,1)},
				{12,SkillExpFunc(5880,1.23,12,5,1)},
				{13,SkillExpFunc(5880,1.22,13,5,1)},
				{14,SkillExpFunc(5880,1.21,14,5,1)},
				{15,SkillExpFunc(5880,1.20,15,5,1)},
				{16,SkillExpFunc(5880,1.19,16,5,1)},
				{17,SkillExpFunc(5880,1.18,17,5,1)},
				{18,SkillExpFunc(5880,1.17,18,5,1)},
				{19,SkillExpFunc(8000,1.16,19,5,1)},
				{20,SkillExpFunc(8000,1.15,20,5,1)},
			}
		},
	},

	qiwudang150={ -- Kü n¨ng 150 - Ch­ëng
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		lightingdamage_v={
			[1]={{1,6},{20,10},{23,11}},
			[3]={{1,6},{15,180},{20,420},{23,708},{26,852}}
		},
		skill_attackradius={{{1,448},{20,512},{20,512}}},
		missle_lifetime_v={{{1,20},{20,30},{21,30}}},
		stun_p={{{1,10},{20,30},{23,36},{26,36}},{{1,1},{20,6},{21,6}}},
		skill_cost_v={{{1,72},{20,180},{23,214},{26,231}}},
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

	jianqi_zongheng={ -- KiÕm KhÝ Tung Hoµnh - Ch­ëng (Kh«ng sö dông)
		seriesdamage_p={{{1,20},{20,60}}},
		lightingdamage_v={
			[1]={{1,12},{20,60}},
			[3]={{1,58},{20,610}}
		},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,366},{20,366}}
		},
		skill_showevent={{{1,0},{10,0},{10,4},{20,4}}},
	},

	taiji_wuyi={ -- Th¸i Cùc V« ý - Ch­ëng (Kh«ng sö dông)
		seriesdamage_p={{{1,20},{20,60}}},
		stun_p={{{1,10},{20,20}},{{1,1},{20,10}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_vanishedevent={
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,377},{20,377}}
		},
		skill_showevent={{{1,0},{15,0},{15,8},{20,8}}},
	},

	nulei_lianhuanji={ -- Né L«i Liªn hoµn KÝch - Ch­ëng (Kh«ng sö dông)
		seriesdamage_p={{{1,20},{20,60}}},
		lightingdamage_v={
			[1]={{1,12},{20,60}},
			[3]={{1,58},{20,610}}
		},
	},

	renjian_heyi={ -- Nh©n KiÕm Hîp NhÊt - KiÕm 90
		physicsenhance_p={{{1,8},{15,80},{20,250}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		lightingdamage_v={ -- L«i s¸t
			[1]={{1,12},{20,35}},
			[3]={{1,12},{15,100},{20,300}}
		},
		attackrating_p={{{1,65},{20,345}}}, -- §é chÝnh x¸c %
		stealmana_p={{{1,1},{20,10}}}, -- Hót néi lùc %
		deadlystrike_p={{{1,16},{20,25}}}, -- TÊn c«ng chÝ m¹ng %
		missle_speed_v={{{1,40},{20,40}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		missle_lifetime_v={{{1,4},{20,4}}}, -- HiÖu qu¶ xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,100},{20,100}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,35},{20,60}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3-4: Nh©n KiÕm Hîp NhÊt - KiÕm 90
		skill_collideevent={ -- Kü n¨ng tÇng 4: HuyÒn NhÊt V« T­îng
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,162},{20,162}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 2: Th¸i Cùc KiÕm ý
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,371},{20,371}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}}, -- Kü n¨ng tÇng 2-3-4: Nh©n KiÕm Hîp NhÊt - KiÕm 90
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(7200,1.15,1,3,1)},
				{2,SkillExpFunc(7200,1.15,2,3,1)},
				{3,SkillExpFunc(7200,1.16,3,3,1)},
				{4,SkillExpFunc(7200,1.17,4,3,1)},
				{5,SkillExpFunc(7200,1.18,5,3,1)},
				{6,SkillExpFunc(7200,1.19,6,3,1)},
				{7,SkillExpFunc(7200,1.20,7,3,1)},
				{8,SkillExpFunc(7200,1.21,8,3,1)},
				{9,SkillExpFunc(7200,1.22,9,3,1)},
				{10,SkillExpFunc(7200,1.23,10,3,1)},
				{11,SkillExpFunc(7200,1.24,11,3,1)},
				{12,SkillExpFunc(7200,1.23,12,3,1)},
				{13,SkillExpFunc(7200,1.22,13,3,1)},
				{14,SkillExpFunc(7200,1.21,14,3,1)},
				{15,SkillExpFunc(7200,1.20,15,3,1)},
				{16,SkillExpFunc(7200,1.19,16,3,1)},
				{17,SkillExpFunc(7200,1.18,17,3,1)},
				{18,SkillExpFunc(7200,1.17,18,3,1)},
				{19,SkillExpFunc(7200,1.16,19,3,1)},
				{20,SkillExpFunc(7200,1.15,20,3,1)},
			}
		},
	},

	jianwudang150={ -- Kü n¨ng 150 - KiÕm
		physicsenhance_p={{{1,12},{15,115},{20,280},{23,478},{26,577}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		lightingdamage_v={
			[1]={{1,15},{20,42},{23,50},{26,54}},
			[3]={{1,15},{15,120},{20,321},{23,562},{26,682}}
		},
		attackrating_p={{{1,78},{20,415},{23,521},{26,574}}},
		stealmana_p={{{1,1},{20,5},{23,6}}},
		deadlystrike_p={{{1,20},{20,30},{23,33},{26,34}}},
		missle_speed_v={{{1,0},{20,0}}},
		missle_lifetime_v={{{1,9},{20,9}}},
		skill_attackradius={{{1,90},{20,90}}},
		skill_cost_v={{{1,40},{20,72},{23,82},{26,87}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1105},{20,1105}}
		},
		skill_startevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1107},{20,1107}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}},
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

	xuanyi_wuxiang={ -- HuyÒn NhÊt V« T­îng - TÇng 4 Nh©n KiÕm Hîp NhÊt - KiÕm 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}},
		lightingdamage_v={
			[1]={{1,1},{20,15}},
			[3]={{1,15},{20,150}}
		},
	},

	jianwudang150_2={ -- TÇng 2 Kü n¨ng 150 - KiÕm
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		stun_p={{{1,1},{20,24},{23,31},{26,34}},{{1,1},{19,9},{20,10}}},
		lightingdamage_v={
			[1]={{1,1},{20,12},{23,15}},
			[3]={{1,12},{20,120},{23,154},{26,171}}
		},
	},

	taiji_jianyi={ -- Th¸i Cùc KiÕm ý - TÇng 2 Nh©n KiÕm Hîp NhÊt - KiÕm 90
		stun_p={{{1,1},{20,30}},{{1,1},{19,9},{20,10}}},
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 3: KiÕm Phi Kinh Thiªn - KiÕm 30
		skill_startevent={ -- Kü n¨ng tÇng 3: KiÕm Phi Kinh Thiªn - KiÕm 30
			[1]={{1,0},{13,0},{13,1},{20,1}},
			[3]={{1,158},{20,158}}
		},
		skill_showevent={{{1,0},{13,0},{13,1},{20,1}}}, -- Kü n¨ng tÇng 3: KiÕm Phi Kinh Thiªn - KiÕm 30
	},

	jianwudang150_3={ -- TÇng 3 Kü n¨ng 150 - KiÕm
		stun_p={{{1,1},{20,24},{23,31},{26,34}},{{1,1},{19,9},{20,10}}},
		lightingdamage_v={
			[1]={{1,20},{20,60},{23,72},{26,78}},
			[3]={{1,60},{15,180},{20,400},{23,664},{26,796}}
		},
		physicsenhance_p={{{1,12},{15,115},{20,280},{23,478},{26,577}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		stealmana_p={{{1,1},{20,5},{23,6}}},
		deadlystrike_p={{{1,20},{20,30},{23,33},{26,34}}},
	},

	wudang120={ -- Kü n¨ng 120: XuÊt ø BÊt NhiÔm
		skill_cost_v={{{1,15},{20,50},{21,50}}}, -- Tiªu hao néi lùc
		missle_missrate={{{1,85},{15,25},{20,15},{21,15}}},
		ignorenegativestate_p={
			{{1,1},{15,1},{20,1},{21,1}},
			{{1,18},{20,18},{21,18}},
		},
		skill_mintimepercastonhorse_v={{{1,35*18},{15,18*18},{20,15*18},{21,15*18}}}, -- Thêi gian kh«i phôc chiªu thøc trªn ngùa
		skill_mintimepercast_v={{{1,35*18},{15,18*18},{20,15*18},{21,15*18}}}, -- Thêi gian kh«i phôc chiªu thøc
		skill_desc=
			function(level)
				return "Thêi gian kh«i phôc chiªu thøc: <color=orange>"..floor(Link(level,SKILLS.wudang120.skill_mintimepercast_v[1]) / 18).." gi©y<color>\n"..
				"Thêi gian kh«i phôc chiªu thøc trªn ngùa: <color=orange>"..floor(Link(level,SKILLS.wudang120.skill_mintimepercastonhorse_v[1]) / 18).." gi©y<color>\n" ..
				"X¸c suÊt <color=orange>"..floor(100 - Link(level,SKILLS.wudang120.missle_missrate[1])).."%<color> <color>lo¹i bá tr¹ng th¸i dÞ th­êng cho ®ång ®éi \n"..
				"X¸c suÊt <color=orange>"..floor(100 - Link(level,SKILLS.wudang120_child.missle_missrate[1])).."%<color> <color>tù lo¹i bá vµ miÔn dÞch tr¹ng th¸i dÞ th­êng trong <color=orange>"..
				floor(Link(level,SKILLS.wudang120_child.ignorenegativestate_p[2]) / 18).." gi©y<color>\n"
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

	wudang120_child={ -- Kü n¨ng phô - XuÊt ø BÊt NhiÔm
		missle_missrate={{{1,85},{15,20},{20,15},{21,15}}},
		ignorenegativestate_p={
			{{1,100},{15,100},{20,100},{21,100}},
			{{1,1*18},{20,3*18},{21,3*18}},
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