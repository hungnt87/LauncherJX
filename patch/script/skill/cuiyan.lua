function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										  Kü n¨ng Thóy Yªn										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	fenghua_xueyue={ -- Phong Hoa TuyÕt NguyÖt - §ao 10
		physicsenhance_p={{{1,5},{20,85}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng B¨ng Tung V« ¶nh - §ao 90
			[1]={{1,336},{2,336}},
			[3]={{1,1},{20,80}}
		},
		addskilldamage2={ -- % Kü n¨ng Môc D· L­u Tinh - §ao 60
			[1]={{1,108},{2,108}},
			[3]={{1,1},{20,50}}
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,5},{20,80}},
			[3]={{1,5},{20,150}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,10}}} -- Tiªu hao néi lùc
	},

	cuiyan_daofa={ -- Thóy Yªn §ao Ph¸p - Hç trî §ao 10
		addphysicsdamage_p={{{1,45},{20,215}},{{1,-1},{2,-1}},{{1,1},{2,1}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		deadlystrikeenhance_p={{{1,6},{20,35,Conic}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	cuiyan_shuangdao={ -- Thóy Yªn Song §ao - Hç trî Song ®ao 10
		addcoldmagic_v={{{1,20},{20,215}},{{1,-1},{2,-1}}} -- B¨ng s¸t - néi c«ng
	},

	huti_hanbing={ -- Hé ThÓ Hµn B¨ng - Hç trî chñ ®éng 40
		meleedamagereturn_p={{{1,5},{20,20}},{{1,18*120},{20,18*120}}}, -- Ph¶n ®ßn cËn chiÕn %
		rangedamagereturn_p={{{1,5},{20,20}},{{1,18*120},{20,18*120}}}, -- Phµn ®ßn tÇm xa %
		skill_cost_v={{{1,40},{20,60}}} -- Tiªu hao néi lùc
	},

	fengjuan_canxue={ -- Phong QuyÓn Tµn TuyÕt - Song ®ao 10
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsdamage_v={ -- S¸t th­¬ng vËt lý
			[1]={{1,25},{20,235}},
			[3]={{1,25},{20,375}},
		},
		addskilldamage1={ -- % Kü n¨ng B¨ng T©m Tiªn Tö - Song ®ao 90
			[1]={{1,337},{2,337}},
			[3]={{1,1},{20,250}}
		},
		addskilldamage2={ -- % Kü n¨ng BÝch H¶i TriÒu Sinh - Song ®ao 60
			[1]={{1,111},{2,111}},
			[3]={{1,1},{20,75}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,20}}} -- Tiªu hao néi lùc
	},

	bingxin_qianying={ -- B¨ng T©m Tr¸i ¶nh - Hç trî chñ ®éng 20
		lifereplenish_v={{{1,130},{20,700}},{{1,8},{2,8}}}, -- Phôc håi sinh lùc mçi nöa gi©y
		skill_cost_v={{{1,21},{20,40}}} -- Tiªu hao néi lùc
	},

	yuda_lihua={ -- Vò §¶ Lª Hoa - §ao 30
		physicsenhance_p={{{1,10},{20,140}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng B¨ng T©m TuyÕt Liªn - TÇng 2 B¨ng Tung V« ¶nh - §ao 90
			[1]={{1,382},{2,382}},
			[3]={{1,15},{20,100}}
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,100}},
			[3]={{1,10},{20,250}}
		},
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,30}}} -- Tiªu hao néi lùc
	},

	xueying={ -- TuyÕt ¶nh
  		allres_p={{{1,1},{20,20}},{{1,18*120},{30,18*180}}}, -- Kh¸ng tÊt c¶ %
		attackspeed_v={{{1,12},{20,65},{23,73},{25,90},{28,99},{42,111},{43,119},{44,122}},{{1,18*120},{20,18*180}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
		castspeed_v={{{1,12},{20,65},{23,73},{25,90},{28,99},{42,111},{43,119},{44,122}},{{1,18*120},{20,18*180}}}, -- Tèc ®é ®¸nh - néi c«ng %
		fastwalkrun_p={{{1,17},{20,55}},{{1,18*120},{20,18*180}}}, -- Tèc ®é di chuyÓn %
		skill_cost_v={{{1,40},{20,140}}} -- Tiªu hao néi lùc
	},

	taxue_wuhen={}, -- §¹p TuyÕt V« Ng©n - Hç trî chñ ®éng 50

	muye_liuxing={ -- Môc D· L­u Tinh - §ao 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,30},{20,271}}}, -- S¸t th­¬ng vËt lý %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,20},{20,246}},
			[3]={{1,20},{20,426}}
		},
		addskilldamage1={ -- % Kü n¨ng B¨ng Tung V« ¶nh - §ao 90
			[1]={{1,336},{2,336}},
			[3]={{1,1},{20,100}}
		},
		skill_attackradius={{{1,448},{20,480},{21,480}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,30},{20,40}}} -- Tiªu hao néi lùc
	},

	fuyun_sanxue={ -- Phï V©n T¸n TuyÕt - Song ®ao 30
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,40},{20,675}},
			[3]={{1,40},{20,675}}
		},
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng Phong TuyÕt B¨ng Thiªn -- TÇng 2 B¨ng T©m Tiªn Tö - Song ®ao 90
			[1]={{1,338},{2,338}},
			[3]={{1,1},{20,300}}
		},
		skill_attackradius={{{1,384},{20,416}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,50},{20,50}}} -- Tiªu hao néi lùc
	},

	bihai_chaosheng={ -- BÝch H¶i TriÒu Sinh - Song ®ao 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsdamage_v={ -- S¸t th­¬ng vËt lý
			[1]={{1,20},{20,500}},
			[3]={{1,20},{20,500}},
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,43},{20,704}},
			[3]={{1,43},{20,1214}}
		},
		addskilldamage1={ -- % Kü n¨ng B¨ng T©m Tiªn Tö - Song ®ao 90
			[1]={{1,337},{2,337}},
			[3]={{1,2},{20,300}}
		},
		addskilldamage2={ -- % Kü n¨ng Phong TuyÕt B¨ng Thiªn -- TÇng 2 B¨ng T©m Tiªn Tö - Song ®ao 90
			[1]={{1,338},{2,338}},
			[3]={{1,2},{20,300}}
		},
		skill_cost_v={{{1,65},{20,65}}} -- Tiªu hao néi lùc
	},

	binggu_xuexin={ -- B¨ng Cèt TuyÕt T©m - TrÊn ph¸i 60
		addcoldmagic_v={{{1,60},{30,315}},{{1,-1},{2,-1}}}, -- B¨ng s¸t - néi c«ng
		addcolddamage_v={{{1,30},{30,275}},{{1,-1},{2,-1}}}, -- B¨ng s¸t - ngo¹i c«ng
		addphysicsmagic_v={{{1,30},{30,275}},{{1,-1},{2,-1}}}, -- S¸t th­¬ng vËt lý - néi c«ng
		deadlystrikeenhance_p={{{1,5},{30,45,Conic}},{{1,-1},{2,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		coldenhance_p={{{1,8},{30,80}},{{1,-1},{2,-1}}}, -- Thêi gian tr× ho·n %
		lifemax_p={{{1,3},{30,50}},{{1,18*120},{30,18*360}}}, -- Sinh lùc tèi ®a %
	},

	bingzong_wuying={ -- B¨ng Tung V« ¶nh - §ao 90
		physicsenhance_p={{{1,15},{15,80},{20,130}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{15,100},{20,180}},
			[3]={{1,50},{15,100},{20,180}}
		},
		missle_speed_v={{{1,20},{20,24},{21,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,40},{20,60}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2: B¨ng T©m TuyÕt Liªn
		skill_collideevent={ -- Kü n¨ng tÇng 2: B¨ng T©m TuyÕt Liªn
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,382},{20,382}}
		},
		skill_showevent={{{1,0},{10,0},{10,4},{20,4}}}, -- Kü n¨ng tÇng 2: B¨ng T©m TuyÕt Liªn
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_misslenum_v={{{1,1},{5,1},{20,5},{29,5},{30,6},{31,6}}}, -- Sè l­îng Missle
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(8000,1.25,1,1,1)},
				{2,SkillExpFunc(8000,1.15,2,1,1)},
				{3,SkillExpFunc(8000,1.16,3,1,1)},
				{4,SkillExpFunc(8000,1.17,4,1,1)},
				{5,SkillExpFunc(8000,1.18,5,1,1.5)},
				{6,SkillExpFunc(8000,1.19,6,1,1.5)},
				{7,SkillExpFunc(8000,1.20,7,1,1.5)},
				{8,SkillExpFunc(8000,1.21,8,1,1.5)},
				{9,SkillExpFunc(8000,1.22,9,1,1.5)},
				{10,SkillExpFunc(8000,1.23,10,1,2)},
				{11,SkillExpFunc(8000,1.24,11,1,2)},
				{12,SkillExpFunc(8000,1.23,12,1,2)},
				{13,SkillExpFunc(8000,1.22,13,1,2)},
				{14,SkillExpFunc(8000,1.21,14,1,2)},
				{15,SkillExpFunc(8000,1.20,15,1,3)},
				{16,SkillExpFunc(8000,1.19,16,1,3)},
				{17,SkillExpFunc(8000,1.18,17,1,3)},
				{18,SkillExpFunc(8000,1.17,18,1,3)},
				{19,SkillExpFunc(8000,1.16,19,1,3)},
				{20,SkillExpFunc(8000,1.15,20,1,4)},
			}
		},
	},

	bingxin_yuling={ -- B¨ng T©m Ngäc L¨ng - TÇng 2 B¨ng Tung V« ¶nh - §ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,15},{20,115}}}, -- S¸t th­¬ng vËt lý %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,440}},
			[3]={{1,10},{20,440}}
		},
		skill_eventskilllevel={{{1,1},{20,20}}}, -- B¨ng T©m TuyÕt Liªn - TÇng 2 B¨ng Tung V« ¶nh - §ao 90
		skill_collideevent={ -- B¨ng T©m TuyÕt Liªn - TÇng 2 B¨ng Tung V« ¶nh - §ao 90
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,382},{20,382}}
		},
		skill_showevent={{{1,0},{15,0},{15,4},{20,4}}}, -- B¨ng T©m TuyÕt Liªn - TÇng 2 B¨ng Tung V« ¶nh - §ao 90
	},

	daocuiyan150={ -- Kü n¨ng 150 - §ao
		physicsenhance_p={{{1,90},{15,600},{20,900},{23,1260},{26,1440}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		colddamage_v={
			[1]={{1,60},{15,850},{20,1050},{23,1290},{26,1410}},
			[3]={{1,300},{15,1200},{20,1655},{23,2201},{26,2474}}
		},
		missle_speed_v={{{1,24},{20,24},{21,24}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,48},{20,72},{23,79}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1064},{20,1064}}
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

	daocuiyan150_2={ -- TÇng 2 Kü n¨ng 150 - §ao
		physicsenhance_p={{{1,18},{15,120},{20,175},{23,241},{26,274}}},
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		colddamage_v={
			[1]={{1,12},{15,168},{20,210},{23,260},{26,285}},
			[3]={{1,60},{15,240},{20,331},{23,440},{26,494}}
		},
		missle_speed_v={{{1,28},{20,32},{21,32}}},
		skill_misslenum_v={{{1,1},{5,1},{20,5},{21,5}}},
	},

	bingxin_xuelian={ -- B¨ng T©m TuyÕt Liªn - TÇng 2 B¨ng Tung V« ¶nh - §ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,10},{20,100}}}, -- S¸t th­¬ng vËt lý %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,10},{20,200}},
			[3]={{1,10},{20,200}}
		},
	},

	bingxin_xianzi={ -- B¨ng T©m Tiªn Tö - Song ®ao 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsdamage_v={ -- S¸t th­¬ng vËt lý
			[1]={{1,5},{15,100},{20,358}},
			[3]={{1,5},{15,100},{20,358}},
		},
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,15},{15,240},{20,581}},
			[3]={{1,15},{15,240},{20,581}}
		},
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,45},{20,75}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_flyevent={ -- Kü n¨ng tÇng 3: Phong TuyÕt B¨ng Thiªn
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[2]={{1,3},{2,3}},
			[3]={{1,338},{20,338}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 2: Phï V©n T¸n TuyÕt
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,113},{20,113}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,3},{20,3}}}, -- Kü n¨ng tÇng 2-3
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(13000,1.25,1,1,1)},
				{2,SkillExpFunc(13000,1.15,2,1,1)},
				{3,SkillExpFunc(13000,1.16,3,1,1)},
				{4,SkillExpFunc(13000,1.17,4,1,1)},
				{5,SkillExpFunc(13000,1.18,5,1,1)},
				{6,SkillExpFunc(13000,1.19,6,1,1)},
				{7,SkillExpFunc(13000,1.20,7,1,1)},
				{8,SkillExpFunc(13000,1.21,8,1,1)},
				{9,SkillExpFunc(13000,1.22,9,1,1)},
				{10,SkillExpFunc(13000,1.23,10,1,1)},
				{11,SkillExpFunc(13000,1.24,11,1,1)},
				{12,SkillExpFunc(13000,1.23,12,1,1)},
				{13,SkillExpFunc(13000,1.22,13,1,1)},
				{14,SkillExpFunc(13000,1.21,14,1,1)},
				{15,SkillExpFunc(13000,1.20,15,1,1)},
				{16,SkillExpFunc(13000,1.19,16,1,1)},
				{17,SkillExpFunc(13000,1.18,17,1,1)},
				{18,SkillExpFunc(13000,1.17,18,1,1)},
				{19,SkillExpFunc(13000,1.16,19,1,1)},
				{20,SkillExpFunc(13000,1.15,20,1,1)},
			}
		},
	},

	fengxue_bingtian={ -- Phong TuyÕt B¨ng Thiªn - TÇng 2 B¨ng T©m Tiªn Tö - Song ®ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		colddamage_v={ -- B¨ng s¸t
			[1]={{1,45},{20,400}},
			[3]={{1,45},{20,400}}
		},
	},

	neicuiyan150={ -- Kü n¨ng 150 - Song ®ao
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		physicsdamage_v={
			[1]={{1,6},{15,120},{20,430},{23,802},{26,988}},
			[3]={{1,6},{15,120},{20,430},{23,802},{26,988}},
		},
		colddamage_v={
			[1]={{1,18},{15,290},{20,700},{23,1192},{26,1438}},
			[3]={{1,18},{15,290},{20,700},{23,1192},{26,1438}}
		},
		missle_speed_v={{{1,20},{20,24},{21,24}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,55},{20,90},{23,101}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_flyevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[2]={{1,2},{2,2}},
			[3]={{1,1093},{20,1093}}
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

	neicuiyan150_2={ -- TÇng 2 Kü n¨ng 150 - Song ®ao
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		colddamage_v={
			[1]={{1,55},{20,720},{23,930},{26,1035}},
			[3]={{1,55},{20,720},{23,930},{26,1035}}
		},
	},

	cuiyan120={ -- Kü N¨ng 120: Ngù TuyÕt Èn
		skill_cost_v={{{1,35},{20,80},{21,80}}}, -- Tiªu hao néi lùc
		hide={{{1,1},{20,1}},{{1,5*18},{15,25*18},{20,30*18},{21,30*18}}}, -- Èn th©n
		skill_mintimepercast_v={{{1,60*18},{15,45*18},{20,40*18},{21,40*18}}}, -- Thêi gian kh«i phôc chiªu thøc
		skill_mintimepercastonhorse_v={{{1,60*18},{15,45*18},{20,40*18},{21,40*18}}}, -- -- Thêi gian kh«i phôc chiªu thøc trªn ngùa
		skill_desc=
			function(level)
				return "Thêi gian kh«i phôc chiªu thøc: <color=orange>"..floor(Link(level,SKILLS.cuiyan120.skill_mintimepercast_v[1]) / 18).." gi©y<color>\n"
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