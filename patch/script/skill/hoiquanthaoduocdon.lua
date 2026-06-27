SKILLS={
	chunniu = {
		seriesdamage_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		firedamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		poisondamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		physicsdamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		colddamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		lightingdamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
	},
	
	chunniuzidan = {
		seriesdamage_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		firedamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		poisondamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		physicsdamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		colddamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		lightingdamage_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
	},
	
	niumowang2_2 = {
		lifemax_v = {
			{{1,99999},{20,99999}},
			{{1,10*18},{2,20*18}}
		},
		lifereplenish_v = {
			{{1,50},{20,50}},
			{{1,10*18},{2,20*18}}
		},
		manareplenish_v = {
			{{1,50},{20,50}},
			{{1,10*18},{2,20*18}}
		},
		fasthitrecover_v = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		freezetimereduce_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		poisontimereduce_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		stuntimereduce_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		allres_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		allresmax_p = {
			{{1,9999},{20,9999}},
			{{1,10*18},{2,20*18}}
		},
		
		fastwalkrun_p = {
			{{1,300},{20,300}},
			{{1,10*18},{2,20*18}}
		},
	},
}

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