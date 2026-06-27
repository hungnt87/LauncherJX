function SkillExpFunc(Exp0,a,Level,Time,Range)
	return floor(Exp0*(a^(Level-1))*Time*Range/2) -- Tèc ®é luyÖn Kü N¨ng 90 (MÆc ®Þnh /2)
end

----------------------------------------------------------------------------------------------------
--										  Kü n¨ng Ngò §éc										  --
----------------------------------------------------------------------------------------------------
SKILLS={
	dusha_zhang={ -- §éc Sa Ch­ëng - Ch­ëng 10
		poisondamage_v={{{1,20},{20,80}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng ¢m Phong Thùc Cèt - Ch­ëng 90
			[1]={{1,353},{2,353}},
			[3]={{1,2},{20,80}}
		},
		addskilldamage2={ -- Kü n¨ng Thiªn C­¬ng §Þa S¸t - Ch­ëng 60
			[1]={{1,71},{2,71}},
			[3]={{1,1},{20,50}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,10}}} -- Tiªu hao néi lùc
	},

	wudu_daofa={ -- Ngò §éc §ao Ph¸p - Hç trî §ao 10
		addphysicsdamage_p={{{1,20},{20,360},{21,370}},{{1,-1},{20,-1}},{{1,1},{2,1}}}, -- S¸t th­¬ng vËt lý - ngo¹i c«ng %
		addpoisondamage_v={{{1,1},{20,40}},{{1,-1},{2,-1}},{{1,10},{2,10}}}, -- §éc s¸t - ngo¹i c«ng
		deadlystrikeenhance_p={{{1,6},{20,40}},{{1,-1},{2,-1}}} -- T¨ng tÊn c«ng chÝ m¹ng %
	},

	wudu_zhangfa={ -- Ngò §éc Ch­ëng Ph¸p - Hç trî Ch­ëng 10
		addpoisonmagic_v={{{1,15},{20,85}},{{1,-1},{2,-1}},{{1,10},{2,10}}}, -- §éc s¸t - néi c«ng
	},

	binglan_xuanjing={ -- B¨ng Lam HuyÒn Tinh - Bïa 30
		coldres_p={{{1,-9},{20,-49}},{{1,18*20},{20,18*90}}}, -- Kh¸ng b¨ng
		skill_cost_v={{{1,10},{20,60}}} -- Tiªu hao néi lùc
	},

	xuedao_dusha={ -- HuyÕt §ao §éc S¸t - §ao 10
		physicsenhance_p={{{1,15},{20,65}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,1},{20,10}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,4},{20,11}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		addskilldamage1={ -- % Kü n¨ng HuyÒn ¢m Tr¶m - §ao 90
			[1]={{1,355},{2,355}},
			[3]={{1,1},{20,75}}
		},
		addskilldamage2={ -- % Kü n¨ng Chu C¸p Thanh Minh - §ao 60
			[1]={{1,74},{2,74}},
			[3]={{1,1},{20,65}}
		},
		missle_speed_v={{{1,20},{20,24}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,320},{20,384}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,20},{20,20}}} -- Tiªu hao néi lùc
	},

	zanan_yaojing={ -- T¹p Nan D­îc Kinh - Hç trî bÞ ®éng 20
		poisonres_p={{{1,9},{20,39}},{{1,-1},{2,-1}}} -- Kh¸ng ®éc
	},

	jiutian_kuanglei={ -- T¹p Nan D­îc Kinh - Bïa 20
		lightingres_p={{{1,-9},{20,-49}},{{1,18*20},{20,18*90}}}, -- Kh¸ng l«i
		skill_cost_v={{{1,10},{20,60}}} -- Tiªu hao néi lùc
	},

	youming_kulou={ -- U Minh Kh« L©u - Ch­ëng 30
		poisondamage_v={{{1,30},{20,100}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		addskilldamage1={ -- % Kü n¨ng ¢m Phong Thùc Cèt - Ch­ëng 90
			[1]={{1,353},{2,353}},
			[3]={{1,2},{20,100}}
		},
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,40},{20,40}}} -- Tiªu hao néi lùc
	},

	wuxing_gu={ -- V« H×nh §éc 30
		fastwalkrun_p={{{1,0},{20,0}},{{1,18},{20,18}}}, -- Tèc ®é di chuyÓn
		poisondamage_v={ -- §éc s¸t
			[1]={{1,10},{20,50}},
			[2]={{1,20},{20,20}},
			[3]={{1,25},{2,25}}
		}	
	},

	chiyan_shitian={ -- XÝch DiÖm Thùc Thiªn - Bïa 20
		fireres_p={{{1,-9},{20,-49}},{{1,18*20},{20,18*90}}}, -- Kh¸ng háa
		skill_cost_v={{{1,10},{20,60}}} -- Tiªu hao néi lùc
	},
	
	chuanxin_duci={ -- Xuyªn T©m §éc ThÝch - Bïa 50
		poisonres_p={{{1,-29},{20,-49}},{{1,18*20},{20,18*90}}}, -- Kh¸ng ®éc
		skill_cost_v={{{1,10},{20,60}}} -- Tiªu hao néi lùc
	},

	wangu_shixin={ -- V¹n §éc Thùc T©m - Bïa 40
		poisontimereduce_p={{{1,-100},{20,-300}},{{1,18*45},{20,18*120}}}, -- Thêi gian tróng ®éc
		skill_cost_v={{{1,40},{20,40}}} -- Tiªu hao néi lùc
	},

	tiangang_disha={ -- Thiªn C­¬ng §Þa S¸t - Ch­ëng 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,50},{20,200}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		addskilldamage1={ -- % Kü n¨ng Thiªn C­¬ng §éc Thñ - TÇng 2 ¢m Phong Thùc Cèt - Ch­ëng 90
			[1]={{1,354},{2,354}},
			[3]={{1,2},{20,200}}
		},
		skill_attackradius={{{1,448},{20,480}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,60},{20,60}}} -- Tiªu hao néi lùc
	},

	zhuha_qingming={ -- Chu C¸p Thanh Minh - §ao 60
		seriesdamage_p={{{1,10},{20,50},{21,52}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,200},{20,500}}}, -- S¸t th­¬ng vËt lý %
		poisondamage_v={{{1,16},{20,53}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		addskilldamage1={ -- % Kü n¨ng HuyÒn ¢m Tr¶m - §ao 90
			[1]={{1,355},{2,355}},
			[3]={{1,1},{20,100}}
		},
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,17},{20,55}}} -- Tiªu hao néi lùc
	},

	wudu_qijing={ -- Ngò §éc Kú Kinh - TrÊn ph¸i 60
		addpoisonmagic_v={{{1,5},{30,100}},{{1,-1},{20,-1}},{{1,11},{2,11}}}, -- §éc s¸t - néi c«ng
		addpoisondamage_v={{{1,5},{30,100}},{{1,-1},{20,-1}},{{1,11},{2,11}}}, -- §éc s¸t - ngo¹i c«ng
		poisonenhance_p={{{1,12},{30,40},{33,43},{35,51},{38,54}},{{1,-1},{2,-1}}}, -- Thêi gian ®éc ph¸t %
		deadlystrikeenhance_p={{{1,4},{30,45}},{{1,-1},{2,-1}}}, -- T¨ng tÊn c«ng chÝ m¹ng %
		castspeed_v={{{1,10},{30,30},{31,40}},{{1,-1},{30,-1}}}, -- Tèc ®é ®¸nh - néi c«ng %
		attackspeed_v={{{1,20},{30,40},{31,40}},{{1,-1},{30,-1}}}, -- Tèc ®é ®¸nh - ngo¹i c«ng %
	},

	baidu_chuanxin={ -- B¸ch §éc Xuyªn T©m - §ao 30
		physicsenhance_p={{{1,10},{20,95}}}, -- S¸t th­¬ng vËt lý %
		seriesdamage_p={{{1,5},{20,30}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,4},{20,20}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		addskilldamage1={ -- % Kü n¨ng Tinh Kh«ng Ph¸ - TÇng 2 HuyÒn ¢m Tr¶m - §ao 90
			[1]={{1,383},{2,383}},
			[3]={{1,1},{20,90}}
		},
		missle_speed_v={{{1,24},{20,28}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,384},{20,448}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,10},{20,32}}} -- Tiªu hao néi lùc
	},

	yinfeng_shigu={ -- ¢m Phong Thùc Cèt - Ch­ëng 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,20},{15,50},{20,121}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		skill_attackradius={{{1,448},{20,480},{21,480},{25,512},{26,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,30},{20,80}}}, -- Tiªu hao néi lùc
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_vanishedevent={ -- Kü n¨ng tÇng 2: Thiªn C­¬ng §éc Thñ
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,354},{20,354}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 3: Truy Phong §éc C¸t
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,388},{20,388}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,9},{20,9}}}, -- Kü n¨ng tÇng 2-3
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(3540,1.15,1,1,5)},
				{2,SkillExpFunc(3540,1.15,2,1,5)},
				{3,SkillExpFunc(3540,1.16,3,1,5)},
				{4,SkillExpFunc(3540,1.17,4,1,5)},
				{5,SkillExpFunc(3540,1.18,5,1,5)},
				{6,SkillExpFunc(3540,1.19,6,1,5)},
				{7,SkillExpFunc(3540,1.20,7,1,5)},
				{8,SkillExpFunc(3540,1.21,8,1,5)},
				{9,SkillExpFunc(3540,1.22,9,1,5)},
				{10,SkillExpFunc(3540,1.23,10,1,5)},
				{11,SkillExpFunc(3540,1.24,11,1,5)},
				{12,SkillExpFunc(3540,1.23,12,1,5)},
				{13,SkillExpFunc(3540,1.22,13,1,5)},
				{14,SkillExpFunc(3540,1.21,14,1,5)},
				{15,SkillExpFunc(3540,1.20,15,1,5)},
				{16,SkillExpFunc(3540,1.19,16,1,5)},
				{17,SkillExpFunc(3540,1.18,17,1,5)},
				{18,SkillExpFunc(3540,1.17,18,1,5)},
				{19,SkillExpFunc(3540,1.16,19,1,5)},
				{20,SkillExpFunc(3540,1.15,20,1,5)},
			}
		},
	},

	zhuifeng_duji={ -- Truy Phong §éc C¸t - TÇng 3 ¢m Phong Thùc Cèt - Ch­ëng 90
		poisondamage_v={{{1,1},{20,20}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
	},
	
	zhangwudu150={ -- Kü n¨ng 150 - Ch­ëng
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		poisondamage_v={{{1,25},{15,100},{20,215},{23,353},{26,422}},{{1,60},{20,60}},{{1,10},{20,10}}},
		skill_attackradius={{{1,448},{20,480},{21,480}}},
		skill_cost_v={{{1,35},{20,100},{23,120}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
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

	zhangwudu150_2={ -- TÇng 2 kü n¨ng 150 - Ch­ëng
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		poisondamage_v={{{1,1},{20,25}},{{1,60},{20,60}},{{1,10},{20,10}}},
	},

	tiangang_dushou={ -- Thiªn C­¬ng §éc Thñ - TÇng 2 ¢m Phong Thùc Cèt - Ch­ëng 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}},
		poisondamage_v={{{1,1},{20,30}},{{1,80},{20,60}},{{1,10},{20,30}}},
	},

	xuanyin_zhan={ -- HuyÒn ¢m Tr¶m - §ao 90
		seriesdamage_p={{{1,20},{15,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		physicsenhance_p={{{1,15},{15,80},{20,240}}}, -- S¸t th­¬ng vËt lý %
		poisondamage_v={{{1,20},{15,60},{20,90}},{{1,60},{20,60}},{{1,10},{20,10}}}, -- §éc s¸t
		missle_speed_v={{{1,28},{20,32},{21,32}}}, -- Tèc ®é xuÊt chiªu khÝ c«ng
		skill_attackradius={{{1,448},{20,512},{21,512}}}, -- Ph¹m vi hiÖu qu¶
		skill_cost_v={{{1,30},{20,60}}}, -- Tiªu hao néi lùc
		addskillexp1={{{1,0},{2,0}},{{1,1},{20,1}},{{1,0},{2,0}}}, -- Kinh nghiÖm luyÖn kü n¨ng
		skill_skillexp_v={ -- Kinh nghiÖm luyÖn kü n¨ng
			{
				{1,SkillExpFunc(5000,1.15,1,1,3)},
				{2,SkillExpFunc(5000,1.15,2,1,3)},
				{3,SkillExpFunc(5000,1.16,3,1,3)},
				{4,SkillExpFunc(5000,1.17,4,1,3)},
				{5,SkillExpFunc(5000,1.18,5,1,3)},
				{6,SkillExpFunc(5000,1.19,6,1,3)},
				{7,SkillExpFunc(5000,1.20,7,1,3)},
				{8,SkillExpFunc(5000,1.21,8,1,3)},
				{9,SkillExpFunc(5000,1.22,9,1,3)},
				{10,SkillExpFunc(5000,1.23,10,1,3)},
				{11,SkillExpFunc(5000,1.24,11,1,3)},
				{12,SkillExpFunc(5000,1.23,12,1,3)},
				{13,SkillExpFunc(5000,1.22,13,1,3)},
				{14,SkillExpFunc(5000,1.21,14,1,3)},
				{15,SkillExpFunc(5000,1.20,15,1,3)},
				{16,SkillExpFunc(5000,1.19,16,1,3)},
				{17,SkillExpFunc(5000,1.18,17,1,3)},
				{18,SkillExpFunc(5000,1.17,18,1,3)},
				{19,SkillExpFunc(5000,1.16,19,1,3)},
				{20,SkillExpFunc(5000,1.15,20,1,3)},
			}
		},
		skill_eventskilllevel={{{1,1},{20,20}}}, -- Kü n¨ng tÇng 2-3
		skill_collideevent={ -- Kü n¨ng tÇng 2: Tinh Kh«ng Ph¸
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,383},{20,383}}
		},
		skill_startevent={ -- Kü n¨ng tÇng 3: Hån ¶nh Tïng Sanh
			[1]={{1,0},{15,0},{15,1},{20,1}},
			[3]={{1,1095},{20,1095}}
		},
		skill_showevent={{{1,0},{10,0},{10,1},{15,1},{15,5},{20,5}}}, -- Kü n¨ng tÇng 2-3
	},

	xingkong_po={ -- Tinh Kh«ng Ph¸ - TÇng 2 HuyÒn ¢m Tr¶m - §ao 90
		seriesdamage_p={{{1,20},{20,60},{21,62}}}, -- Ngò hµnh t­¬ng kh¾c %
		poisondamage_v={{{1,1},{20,30}},{{1,60},{20,60}},{{1,10},{20,20}}}, -- §éc s¸t
	},

	daowudu150={ -- Kü n¨ng 150 - §ao
		seriesdamage_p={{{1,40},{15,40},{20,80},{21,82}}},
		physicsenhance_p={{{1,18},{15,95},{20,208},{23,343},{26,411}}},
		poisondamage_v={{{1,24},{15,72},{20,144},{23,230},{26,273}},{{1,60},{20,60}},{{1,10},{20,10}}},
		missle_speed_v={{{1,28},{20,30},{21,30}}},
		skill_attackradius={{{1,448},{20,512},{21,512}}},
		skill_cost_v={{{1,36},{20,72},{23,83}}},
		skill_eventskilllevel={{{1,1},{20,20}}},
		skill_collideevent={
			[1]={{1,0},{10,0},{10,1},{20,1}},
			[3]={{1,1095},{20,1095}}
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

	daowudu150_2={ -- TÇng 2 kü n¨ng 150 - §ao
		seriesdamage_p={{{1,40},{20,80},{21,82}}},
		poisondamage_v={{{1,1},{20,12},{23,15}},{{1,60},{20,60}},{{1,10},{20,10}}},
	},

	duanjin_fugu={ -- §o¹n C©n Hñ Cèt - Bïa 90
		allres_p={{{1,-1},{20,-40}},{{1,18*20},{20,18*90}}}, -- Kh¸ng tÊt c¶ %
		skill_cost_v={{{1,60},{20,120}}} -- Tiªu hao néi lùc
	},

	chuanyi_pojia={ -- Xuyªn Y Ph¸ Gi¸p
		physicsres_p={{{1,-9},{20,-49}},{{1,18*20},{20,18*90}}}, -- Phßng thñ vËt lý %
		skill_cost_v={{{1,10},{20,60}}} -- Tiªu hao néi lùc
	},

	wudu120={ -- Kü N¨ng 120: HÊp Tinh YÓm
		autoattackskill={{{1,719*256 + 1},{20,719*256 + 20},{21,719*256 + 21}},{{1,-1},{20,-1}},{{1,10*18*256 + 1},{15,10*18*256 + 12},{20,10*18*256 + 15},{21,10*18*256 + 15}}},
		skill_desc=
			function(level)
				return "X¸c suÊt <color=orange>"..floor(Link(level,SKILLS.wudu120.autoattackskill[3]) - 10*18*256).."%<color> khiÕn cho ®èi th­¬ng bÞ ®éc s¸t\n"..
				"§ång thêi lµm gi¶m <color=orange>"..floor(Link(level,SKILLS.wudu120zuzhou.poison2decmana_p[1])).."%<color> néi lùc ®èi ph­¬ng"..
				" trong <color=orange>"..floor(Link(level,SKILLS.wudu120zuzhou.poison2decmana_p[2]) / 18).." gi©y<color>\n"..
				" <color=orange>"..floor((Link(level,SKILLS.wudu120.autoattackskill[3]) / (18*256))).." gi©y<color> sau míi cã thÓ thi triÓn tiÕp"
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

	wudu120zuzhou={ -- HÊp Tinh YÓm QuyÕt Chó
		poison2decmana_p={{{1,30},{15,80},{20,85},{21,85}},{{1,3*18},{15,5*18},{20,6*18},{21,6*18}}}, -- H¹ ®éc ®èi ph­¬ng, ®ång thêi lµm gi¶m néi lùc
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