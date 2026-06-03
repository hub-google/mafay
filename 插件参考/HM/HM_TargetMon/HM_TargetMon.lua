--
-- º£÷©²å¼þ£ºÌØÊâBUFF¡¢¼¼ÄÜ CD ¼à¿Ø
--

HM_TargetMon = {
	bSkillMon = true,		-- Ä¿±ê¼¼ÄÜ CD ¼à¿Ø
	bSkillRight = true,		-- ¼¼ÄÜÅÅÁÐÓÒ¶ÔÆë
	bTargetBuffEx = true,	-- Ä¿±êÌØÊâBUFF
	bTargetRight = true,	-- Ä¿±ê BUFF ÓÒ¶ÔÆë
	bSelfBuffEx = true,		-- ×ÔÉíÌØÊâBUFF
	bSelfRight = true,		-- ×ÔÉíBUFF ÓÒ¶ÔÆë
	bBoxEvent2 = false,		-- Í¼±êÊó±êÊÂ¼þ
	nSize = 55,					-- BOX ´óÐ¡
	tSkillList = {},			-- ×Ô¶¨Òå¼à¿Ø¼¼ÄÜ  	[dwForce] => { [name] => N (s) }
	tBuffList = {},			-- ×Ô¶¨Òå¼à¿ØBUFF	[nType] => { [name] => true|false }
	tNSBuffEx = {},			-- ÅÅ³ý¼à¿Ø×Ô¼º
	tNTBuffEx = {},			-- ÅÅ³ý¼à¿ØÄ¿±ê
	tAnchor = {},				-- Î»ÖÃ
}

-- customdata
HM.RegisterCustomData("HM_TargetMon")

---------------------------------------------------------------------
-- ±¾µØº¯ÊýºÍ±äÁ¿
---------------------------------------------------------------------
local _HM_TargetMon = {
	tCD = {},
}

-- get skill name by id
local function _s(dwSkillID)
	local szName, _ = HM.GetSkillName(dwSkillID)
	return szName
end

-- get buff name by id
local function _b(dwBuffID, dwLevel)
	local szName, _ = HM.GetBuffName(dwBuffID, dwLevel)
	return szName
end

-- skill list (by force, < 0 disable )
_HM_TargetMon.tSkillList4 = {
	{		-- ÉÙÁÖ
		[_s(236)--[[Ä¦Ú­ÎÞÁ¿]]] = 25,
		[_s(242)--[[×½Ó°Ê½]]] = 20,
		[_s(240)--[[ÇÀÖéÊ½]]] = 25,
		[_s(249)--[[ÎåÔÌ½Ô¿Õ]]] = 14,
		[_s(252)--[[´óÊ¨×Óºð]]] = 25,
		[_s(257)--[[¶Í¹Ç¾÷]]] = 35,
		[_s(261)--[[ÎÞÏà¾÷]]] = 60,
		[_s(498)--[[Ç§½ï×¹]]] = 25,
		[_s(258) --[[ÉáÉí¾ö]]] = 60,
		[_s(260) --[[ÇÜÁú¾ö]]] = 60,
	},  {	-- Íò»¨
		[_s(182)--[[ÓñÊ¯¾ã·Ù]]] = 17,
		[_s(100)--[[ÐÇÂ¥ÔÂÓ°]]] = 18, --Ä¬ÈÏ×îµÍ
		[_s(132)--[[´ºÄà»¤»¨]]] = 36,
		[_s(186)--[[Ü½ÈØ²¢µÙ]]] = 20,
		[_s(183)--[[ØÊÒõÖ¸]]] = 10,
		[_s(2663)--[[Ìý·ç´µÑ©]]] = 65,
		[_s(136)--[[Ë®ÔÂÎÞ¼ä]]] = 60,
		[_s(228)--[[Ì«ÒõÖ¸]]] = 17,
		[_s(14963)--[[ÕÛÒ¶Áý»¨]]] = 80,
		[_s(14965)--[[ÄÏ·çÍÂÔÂ]]] = 110,
		[_s(2645)--[[ÂÒÈ÷ÇàºÉ]]] = 75, --Ä¬ÈÏ×îµÍ
	}, {	-- Ìì²ß
		[_s(422) --[[Ð¥Èç»¢]]] = 90,
		[_s(412) --[[¼²Èç·ç]]] = 42,
		[_s(413) --[[ÊØÈçÉ½]]] = 110,
		[_s(433) --[[ÈÎ³Û³Ò]]] = 40,
		[_s(15158) --[[ÆÆÖØÎ§]]] = 40,
		[_s(418) --[[Í»]]] = 17,
		[_s(2628) --[[Ô¨]]] = 30,
	}, {	-- ´¿Ñô
		[_s(2681)--[[×ÏÆø¶«À´]]] = 60, --²»ºÃ¸Ä°¡´óÐÖµÜ
		[_s(363)--[[ÍÌÈÕÔÂ]]] = 10,
		[_s(588)--[[ÈË½£ºÏÒ»]]] = 14,
		[_s(310)--[[½£·É¾ªÌì]]] = 20,
		[_s(366)--[[´óµÀÎÞÊõ]]] = 20,
		[_s(370)--[[°ËØÔ¶´Ðþ]]] = 20,
		[_s(372)--[[×ªÇ¬À¤]]] = 120,
		[_s(371)--[[ÕòÉ½ºÓ]]] = 240,
		[_s(307)--[[½£³åÒõÑô]]] = 30,
		[_s(358)--[[ÉúÌ«¼«]]] = 10,
		[_s(355)--[[Æ¾ÐéÓù·ç]]] = 30,
		[_s(302)--[[Îå·½ÐÐ¾¡]]] = 15,
		[_s(303)--[[Èý²Å»¯Éú]]] = 20,
		[_s(305)--[[¾Å×ª¹éÒ»]]] = 15,
		[_s(2699)--[[°Ë»Ä¹éÔª]]] = 14,
		[_s(346)--[[ÌÝÔÆ×Ý]]] = 30,
		[_s(312)--[[×øÍüÎÞÎÒ]]] = 18,
		[_s(15187) --[[ÐÐÌìµÀ]]] = 60,
	},  {	-- ÆßÐã
		[_s(544)--[[µÛæîÁúÏè]]] = 40,
		[_s(546)--[[½£Ó°ÁôºÛ]]] = 15,
		[_s(547)--[[½£ÐÄÍ¨Ã÷]]] = 30,
		[_s(550)--[[ÈµÌ¤Ö¦]]] = 55,
		[_s(574)--[[µûÅª×ã]]] = 75,
		[_s(557)--[[ÌìµØµÍ°º]]] = 75,
		[_s(552)--[[ÁÚÀïÇú]]] = 180,
		[_s(569)--[[ÍõÄ¸»ÓñÇ]]] = 12,
		[_s(555)--[[·çÐäµÍ°º]]] = 33,
		[_s(558)--[[À×öªÕðÅ­]]] = 90,
		[_s(568)--[[·±Òô¼±½Ú]]] = 84,
		[_s(18579)--[[Ë®é¿»¨Ó¯]]] = 40,
	},  {	-- Îå¶¾
		[_s(2212)--[[°Ù×ã]]] = 12,
		[_s(2218)--[[»Ã¹Æ]]] = 60,
		[_s(2228)--[[»¯µû]]] = 30,
		[_s(2226)--[[¹Æ³æÏ×¼À]]] = 30,
		[_s(2230)--[[Å®æ´²¹Ìì]]] = 54,
		[_s(2227)--[[¹Æ³æ¿ñ±©]]] = 120,
		[_s(2957)--[[Ê¥ÊÖÖ¯Ìì]]] = 18,
		[_s(2235)--[[Ç§µûÍÂÈð]]] = 60,
		[_s(3702) --[[ÐþË®¹Æ]]] = 40,
		[_s(15121) --[[ÊÉÐÄ¹Æ]]] = 70,
		[_L["Call pet"]] = 30,
	},  {	-- ÌÆÃÅ
		[_s(3110) --[[¹í¸«Éñ¹¤]]] = 100,
		[_s(3114) --[[¾ªºèÓÎÁú]]] = 45,
		[_s(3094) --[[ÐÄÎÞÅÔæð]]] = 90,
		[_s(3103) --[[·ÉÐÇ¶ÝÒþ]]] = 40,
		[_s(3112) --[[¸¡¹âÂÓÓ°]]] = 120,
		[_s(18672) --[[°ÙÀï×·»ê]]] = 25,
	},  {	-- ²Ø½£
		[_s(1589) --[[ÃÎÈª»¢ÅÜ]]] = 24,
		[_s(1645) --[[·çÀ´ÎâÉ½]]] = 120,
		[_s(18333) --[[²ãÔÆ·ç³µ]]] = 90,
		[_s(1610) --[[Ï¼Á÷±¦Ê¯]]] = 45,
		[_s(1668) --[[ÔÆÏªËÉ]]] = 50,
		[_s(1666) --[[ÈªÄýÔÂ]]] = 40,
		[_s(1656) --[[Ð¥ÈÕ]]] = 12,
		[_s(1663) --[[ÝºÃùÁø]]] = 90,
	},  {	-- Ø¤°ï
		-- [_s(5265)--[[¼ûÁúÔÚÌï]]] = 23,
		[_s(5262)--[[ÁúÔ¾ÓÚÔ¨]]] = 8,
		[_s(5257)--[[ÊñÈ®·ÍÈÕ]]] = 45,
		[_s(5259)--[[°ô´ò¹·Í·]]] = 20,
		[_s(5267)--[[ÁúÐ¥¾ÅÌì]]] = 36,
		[_s(5269)--[[ÑÌÓêÐÐ]]] = 40,
		[_s(5270)--[[Ð¦×í¿ñ]]] = 90,
		-- [_s(5272)--[[×íåÐÒ£]]] = 60,
	},  {	-- Ã÷½Ì
		[_s(3977)--[[Á÷¹âÇôÓ°]]] = 12,
		[_s(3975)--[[²ÀÎ·°µÐÌ]]] = 34,
		[_s(3973)--[[Ì°Ä§Ìå]]] = 45,
		[_s(3974)--[[°µ³¾ÃÖÉ¢]]] = 45,
		[_s(3978)--[[ÉúÃðÓè¶á]]] = 120,
		[_s(4910)--[[ÎÞÃ÷»êËø]]] = 25,
		[_s(3969)--[[¹âÃ÷Ïà]]] = 90,
		[_s(3968)--[[ÈçÒâ·¨]]] = 60,
		[_s(3971)--[[¼«ÀÖÒý]]] = 45,
		[_s(3970)--[[»Ã¹â²½]]] = 30,
		[_s(18629) --[[Ú¤ÔÂ¶ÉÐÄ]]] = 45,
		[_s(3973) --[[Ì°Ä§Ìå]]] = 51,
	},
	-- ½­ºþ
	[0] = {
		[_s(9003)--[[õæÔÆÖðÔÂ]]] = 30,
		[_s(9002)--[[·öÒ¡Ö±ÉÏ]]] = 30,
	},
	-- ²ÔÔÆ
	[21] = {
		[_s(13042) --[[ÎÞ¾å]]] = 30,
		[_s(13040) --[[ÑªÅ­]]] = 25,
		[_s(13070) --[[¶Ü±Ú]]] = 90,
		[_s(13067) --[[¶ÜÁ¢]]] = 30,
		[_s(15196) --[[ÑïìºÉ³³¡]]] = 210,
	},
	-- ³¤¸è
	[22] = {
		[_s(14073)--[[Ð¦°Á¹âÒõ]]] = 60,
		[_s(14074)--[[½­ÖðÔÂÌì]]] = 60,
		[_s(14075)--[[ÔÆÉú½áº£]]] = 60,
		[_s(14154)--[[Þ’ÃÎÖð¹â]]] = 60,
		[_s(14076)--[[ÇàÏö·ÉÓð]]] = 30, --Ä¬ÈÏ×îµÍ
		[_s(14081)--[[¹ÂÓ°»¯Ë«]]] = 105, --Ä¬ÈÏ×îµÍ
		[_s(14082)--[[ÊèÓ°ºáÐ±]]] = 20,
		[_s(14083)--[[Çå¾øÓ°¸è]]] = 60,
		[_s(14093)--[[³åÇïÚ¤]]] = 15,
		[_s(14095)--[[ÇåÒô³¤Ð¥]]] = 25,
		[_s(15068)--[[ÇÙÒô¹²Ãù]]] = 90,
		[_s(14084) --[[±­Ë®]]] = 180,
	},
	-- °Ôµ¶
	[23] = {
		[_s(16608)--[[É¢Á÷Ï¼]]] = 30,
		[_s(16598)--[[À××ß·çÇÐ]]] = 16,
		[_s(16460)--[[Ì¤ÑçÑïÆì]]] = 20,
		[_s(16479)--[[¸î¾ÝÇØ¹¬]]] = 20,
		[_s(16620)--[[·âÔ¨ÕðÉ·]]] = 30,
		[_s(16870)--[[ÇÜÁúÁùÕ¶]]] = 10,
		[_s(16459)--[[ÁÙÔ¨µ¸ºÓ]]] = 30,
		[_s(16621)--[[¼á±ÚÇåÒ°]]] = 30,
		[_s(16455)--[[³þºÓºº½ç]]] = 35,
		[_s(16454)--[[Î÷³þ±¯¸è]]] = 50,
	},
	--ÁèÑ©¸ó
	[25] = {
		[_s(22358) --[[Õ¶ÎÞ³£]]] = 37,
		[_s(22360) --[[¹í²½]]] = 35,
		[_s(22417) --[[Ê®·½Ðþ»ú]]] = 70,
		[_s(22614) --[[¹Â·çìªÌ¤]]] = 40,
	},
	--ÅîÀ³
	[24] = {
		[_s(20281) --[[¼²µçß³Óð]]] = 70,
		[_s(19984) --[[Ô¦ÓðÆ¸·ç]]] = 37,
		[_s(20245) --[[¶¨²¨íÆÀ½]]] = 17,
		[_s(19828) --[[¸¡ÓÎÌìµØ]]] = 20,
		[_s(20065) --[[Ïè¼«±ÌÂä]]] = 30,
	},
	--ÑÜÌì
	[211] = {
		[_s(25142) --[[¾ÞÃÅ±±Âä]]] = 35,
		[_s(24380) --[[·´±Õ¾ª»ê]]] = 32,
		[_s(24385) --[[ºèÃÉÌì½û]]] = 60,
		[_s(24374) --[[Ì¤ÐÇÐÐ]]] = 30,
	},
	--Ò©×Ú
	[212] = {
		[_s(27578) --[[Õ´ÒÂÎ´·Á]]] = 20,
		[_s(27642) --[[ÁèÈ»Ìì·ç]]] = 38,
		[_s(27536) --[[¾ªºèÂÓË®]]] = 30,
		[_s(27582) --[[ÇÒ´ýÊ±ÐÝ]]] = 47,
		[_s(27674) --[[ÖðÔÆº®Èï]]] = 64,
		[_s(27897) --[[ÂÌÒ°ÂûÉú]]] = 30,
		[_s(27669) --[[Çà´¨åªÁ«]]] = 50,
		[_s(27667) --[[×ÏÒ¶³Áðâ]]] = 36,
	}
}

-- add new force
for k, v in pairs(g_tStrings.tForceTitle) do
	if k > 10 and not _HM_TargetMon.tSkillList4[k] then
		_HM_TargetMon.tSkillList4[k] = {}
	end
end

-- ³äÄÜ¼¼ÄÜ
_HM_TargetMon.tChongNeng = {
	[_s(418)--[[Í»]]] = 2,
	[_s(13067)--[[¶ÜÁ¢]]] = 3,
	[_s(13040)--[[ÑªÅ­]]] = 3,
	[_s(15070)--[[×ªÂäÆßÐÇ]]] = 3,
	[_s(14082)--[[ÊèÓ°ºáÐ±]]] = 3,
	[_s(14074)--[[½­ÖðÔÂÌì]]] = 2,
	[_s(2681)--[[×ÏÆø¶«À´]]] = 3, -- ×ÏÆø¶«À´3¶Î³äÄÜ
	[_s(242)--[[×½Ó°Ê½]]] = 2,
	[_s(3977)--[[Á÷¹âÇôÓ°]]] = 2,
	[_s(1656)--[[Ð¥ÈÕ]]] = 2, -- Ð¥ÈÕ2¶Î³äÄÜ
	[_s(433) --[[ÈÎ³Û³Ò]]] = 2,
	[_s(3103) --[[·ÉÐÇ¶ÝÓ°]]] = 2,
	[_s(3975) --[[²ÀÎ·°µÐÌ]]] = 2,
	[_s(3973) --[[Ì°Ä§Ìå]]] = 2,
	[_s(550) --[[ÈµÌ¤Ö¦]]] = 2,
	[_s(574) --[[µûÅª×ã]]] = 2,
	[_s(569) --[[ÍõÄ¸]]] = 2,
}

-- Í¸Ö§¼¼ÄÜ
_HM_TargetMon.tTouZhi = {
	[_s(16608)--[[É¢Á÷Ï¼]]] = 3,
	[_s(16598)--[[À××ß·çÇÐ]]] = 3,
	[_s(16460)--[[Ì¤ÑçÑïÆì]]] = 3,
	[_s(16479)--[[¸î¾ÝÇØ¹¬]]] = 3,
	[_s(16620)--[[·âÔ¨ÕðÉ·]]] = 3,
	[_s(27556)--[[´¨ÎÚÉäØè]]] = 2,
}

--buff list (by type)
_HM_TargetMon.tBuffList4 = {
	{
		szType = _L["Invincible"],	-- 1
		tName = {
			_b(377)--[[ÕòÉ½ºÓ]], _b(961)--[[Ì«Ðé]], _b(772)--[[»ØÉñ]], _b(3425)--[[¹í¸«Éñ¹¤]], _b(360)--[[Óù]],
			_b(6182)--[[Ú¤Ôó]], _b(9934)--[[ÄÏ·çÍÂÔÂ]], _b(11151)--[[É¢Á÷Ï¼]], _b(20128)--[[ÖðÔÆº®Èï]], _b(21276)--[[ÖðÔÆº®Èï]],
		},
	}, {
		szType = _L["Silence"],	-- 2
		tName = {
			_b(726)--[[½£·É¾ªÌì]], _b(692)--[[³ÁÄ¬]], _b(712)--[[À¼´ÝÓñÕÛ]],	-- À¼´ÝÓñÕÛ2£º712
			_b(4053)--[[²ÀÎ·°µÐÌ]], _b(8450)--[[À×ÔÆ]], _b(9378)--[[¾®ÒÇ]],
			_b(10283)--[[ÓàÒô]], _b(11171)--[[·çÇÐ]],
		},
	}, {
		szType = _L["Uncontrollable"],	--3
		tName = {
			_b(411)--[[ÐÇÂ¥ÔÂÓ°]], _b(1186)--[[ÕÛ¹Ç]], _b(2847)--[[ËØñÆ]], _b(855)--[[Á¦°Î]],
			_b(2756)--[[×ÝÇáÆï]], _b(2781)--[[×ªÇ¬À¤]], _b(3279)--[[ÉúËÀÖ®½»]], _b(1856)--[[²»¹¤]], _b(1676)--[[ÓñÈªÓãÔ¾]], -- ×ªÇ¬À¤2£º2781
			_b(1686)--[[ÃÎÈª»¢ÅÜ]], _b(2840)--[[¹Æ³æ¿ñ±©]], _b(2544)--[[·çòÚÏ×¼À]], _b(3822)--[[±ÌµûÏ×¼À]], _b(4245)--[[Ê¥Ìå]],
			_b(4421)--[[Áé»Ô]], _b(4468)--[[³¬È»]], _b(6373)--[[³öÔ¨]], _b(6361)--[[·É½«]], _b(6314)--[[ÁãÂä]], _b(6292)--[[ÍÌÈÕÔÂ]],
			_b(6247)--[[ÃÔÐÄ¹Æ]], _b(6192)--[[ÆÐÌáÉí]], _b(6131)--[[ÇàÑô]], _b(5995)--[[Ð¦×í¿ñ]], _b(6459)--[[ÑÌÓêÐÐ]],
			_b(6015)--[[ÁúÔ¾ÓÚÔ¨]], _b(6369)--[[¾ÆÖÐÏÉ]], _b(6087)--[[Á÷»ð·ÉÐÇ]], _b(5754)--[[°ÔÌå]], _b(5950)--[[¹Æ³æÏ×¼À]],
			_b(3275)--[[¾øÂ×ÒÝÈº]], _b(8247)--[[ÎÞ¾å]], _b(8265)--[[¶ÜÇ½]], _b(8293)--[[Ç§ÏÕ]], _b(8458)--[[Ë®ÔÂÎÞ¼ä]],
			_b(8449)--[[½Ù»¯]], _b(8483)--[[¶ÜÒã]], _b(8716)--[[º´ÎÀ]], _b(9059)--[[ÇàµÙ]], _b(9068)--[[¾»¹û]], _b(9999)--[[µ·ÒÂ]],
			_b(6284)--[[Ê¥·¨¹âÃ÷]], _b(677)--[[ÈµÌ¤Ö¦]], _b(9855)--[[ÒôÔÏ]], _b(9342)--[[Ê¯¼äÒâ]], _b(9294)--[[¹ÂÓ°]],
			_b(9848)--[[Ì½Ã·]], _b(10245)--[[ÆÆÖØÎ§]], _b(11361)--[[³¾Éí]], _b(11385)--[[Î÷³þ±¯¸è]], _b(11319)--[[ÁÙÔ¨µ¸ºÓ]],
			_b(18105)--[[ Ê¨Ð¥ ]], _b(14273)--[[ Ãî·¨ ]], _b(16348)--[[ ¶þÒµ ]], _b(11808)--[[ ÐÇÒÆ ]],
			_b(17888)--[[ Á¦ÆÆÍò¾ù ]], _b(204)--[[ ·É¶Ý ]], _b(20072)--[[ÁèÈ»Ìì·ç]], _b(20698)--[[¶ÉÈô]], _b(20199)--[[ÂÌÒ°ÂûÉú]], _b(20666)--[[ÇÒ´ýÊ±ÐÝ]],
		},
	}, {
		szType = _L["Halt"],	-- 4
		tName = {
			_b(415)--[[Ñ£ÔÎ]], _b(533)--[[ÖÂÃ¤]], _b(567)--[[ÎåÔÌ½Ô¿Õ]], _b(572)--[[´óÊ¨×Óºð]], _b(682)--[[À×öªÕðÅ­]],
			_b(548)--[[Í»]], _b(2275)--[[¶Ï»ê´Ì]], _b(740)--[[ÖÐ×¢]], _b(1721)--[[×íÔÂ]], _b(1904)--[[º×¹é¹ÂÉ½]], _b(1927)--[[±ÌÍõ]],
			_b(2489)--[[Ð«ÐÄÃÔÐÄ]], _b(2780)--[[½£³åÒõÑô]], _b(3223)--[[À×Õð×Ó]], _b(3224)--[[ÃÔÉñ¶¤]], _b(727)--[[±À]],
			_b(1938)--[[·å²åÔÆ¾°]], _b(4029)--[[ÈÕ½Ù]], _b(4871)--[[ÎÞÃ÷»êËø]], _b(4875)--[[ÕòÄ§]], _b(6276)--[[»Ã¹â²½]],
			_b(6128)--[[»¢êÚ]], _b(6107)--[[åó»÷]], _b(5876)--[[ÉÆ»¤]], _b(6365)--[[¾»ÊÀÆÆÄ§»÷]], _b(6380)--[[×íåÐÒ£]],
			_b(2755)--[[±±¶·]], _b(1902)--[[Î£Â¥]], _b(2877)--[[ÈÕÓ°]], _b(4438)--[[·üÒ¹¡¤ÔÎ]],
			_b(8329)--[[º³µØ]], _b(8455)--[[¶ÜÒã]], _b(8570)--[[¶ÜÃÍ]], _b(11453)--[[²Ã¹Ç]],
		},
	}, {
		szType = _L["Entrap"],	-- 5
		tName = {
			_b(1937)--[[Èý²Å»¯Éú]], _b(679)--[[Ó°ºÛ]], _b(706)--[[Ö¹Ë®]], _b(4038)--[[Ëø×ã]], _b(2289)--[[Îå·½ÐÐ¾¡]],
			_b(2492)--[[°Ù×ãÃÔÐÄ]], _b(2547)--[[ÌìÖëÏ×¼À]], _b(1931)--[[ÍÂ¹ÊÄÉÐÂ]], _b(6364)--[[ÖÍ]], _b(4758)--[[½û¸¿]],
			_b(5809)--[[Ì«ÒÒ]], _b(5764)--[[°Ù×ã]], _b(5694)--[[Ì«ÒõÖ¸]], _b(5793)--[[Ëé±ù]], _b(4436)--[[·üÒ¹¡¤²ø]],
			_b(3359)--[[Ìú×¦]], _b(8251)--[[ÂäÑã]], _b(8327)--[[¶Ï½î]], _b(3216)--[[×êÐÄ´Ì¹Ç]], _b(9569)--[[½£¡¤Óð]],
			_b(9730)--[[ÖÓÁÖØ¹Ðã]], _b(10282)--[[ÇÙÒô]],
		},
	}, {
		szType = _L["Freeze"],	-- 6
		tName = {
			-- ´óµÀÎÞÊõ¿ÉÄÜ¸ÄÎª£º6082
			-- _b(998)--[[Ì«ÒõÖ¸]],
			_b(678)--[[°ø»¨ËæÁø]], _b(686)--[[µÛæîÁúÏè]], _b(554)--[[´óµÀÎÞÊõ]], _b(556)--[[ÆßÐÇ¹°Èð]], _b(675)--[[Ü½ÈØ²¢µÙ]],
			_b(737)--[[Íê¹Ç]], _b(1229)--[[ÆÆÊÆ]], _b(1247)--[[Í¬¹é]], _b(4451)--[[¶¨Éí]], _b(1857)--[[ËÉÌÎ]],
			_b(1936)--[[ç­´½ÖéÐä]], _b(2555)--[[Ë¿Ç£]], _b(6317)--[[½ðÕë]], _b(6108)--[[Ìì¾øµØÃð]], _b(6091)--[[ÃÔÓ°]],
			_b(2311)--[[»Ã¹Æ]], _b(4437)--[[·üÒ¹¡¤¶¨]],
		},
	}, {
		szType = _L["Breakout"],	-- 7
		tName = {
			_b(200)--[[¼²Èç·ç]], _b(9909)--[[ÖïÐ°ÕòÄ§]], _b(2719)--[[ÇàºÉ]], _b(2757)--[[×ÏÆø¶«À´]], _b(538)--[[·±Òô¼±½Ú]], _b(1378)--[[ÈõË®]],
			_b(3468)--[[ÐÄÎÞÅÔæð]], _b(3859)--[[ÏãÊèÓ°]], _b(2726)--[[ÂÒÈ÷]], _b(5994)--[[¾ÆÖÐÏÉ]], _b(2779)--[[Ô¨]],
			_b(1728)--[[ÝºÃù]], _b(3316)--[[ÑïÍþ]], _b(2543)--[[ÁéÉßÏ×¼À]], _b(9906)--[[¹áÄ¾Á÷Äê]], _b(11456)--[[Êè¿ñ]],
			_b(11216)--[[ÖØ¼¤]],
		},
	}, {
		szType = _L["Reduce-injury"],	-- 8
		tName = {
			-- ´ºÄà¿ÉÄÜÒÑ¸ÄÎª£º6264 ÁË£¬µ«Ã»ÖØÃû²»Ó°Ïì
			_b(367)--[[ÊØÈçÉ½]], _b(384)--[[×ªÇ¬À¤]], _b(399)--[[ÎÞÏà¾÷]], _b(122)--[[´ºÄà»¤»¨]], _b(3068)--[[ÎíÌå]],
			_b(1802)--[[ÓùÌì]], _b(684)--[[ÌìµØµÍ°º]], _b(4439)--[[Ì°Ä§Ìå]], _b(6315)--[[ÁãÂä]], _b(2077)--[[Õý¹Ç]],
			_b(6240)--[[ÐþË®¹Æ]], _b(5996)--[[Ð¦×í¿ñ]], _b(5810)--[[ÄÔ»§]], _b(6200)--[[ÁúÐ¥¾ÅÌì]], _b(6636)--[[Ê¥ÊÖÖ¯Ìì]],
			_b(6262)--[[½ðÎÝ]], _b(2849)--[[µûÏ·Ë®]], _b(3315)--[[»¤Ìå]], _b(8279)--[[¶Ü±Ú]], _b(8300)--[[¶ÜÇ½]],
			_b(8427)--[[ÈÙ»Ô]], _b(8291)--[[¶Ü»¤]], _b(8495)--[[º´ÎÀ]], _b(2983)--[[ÎÞÎÒ]], _b(10014)--[[¾ø¸è]],
			_b(10051)--[[±­Ë®ÁôÓ°]], _b(10107)--[[Õð°Ë·½]], _b(9334)--[[Ã·»¨ÈýÅª]], _b(11344)--[[ÆÆ¸ª³ÁÖÛ]], _b(20075)--[[Ç§Ö¦·ü²Ø]],
		},
	}, {
		szType = _L["Dodge"],	-- 9
		tName = {
			_b(3214)--[[¾ªºèÓÎÁú]], _b(2065)--[[ÔÆÆÜËÉ]], _b(5668)--[[·ç´µºÉ]], _b(6434)--[[×íåÐÒ£]],
			_b(6299)--[[Óù·ç¶øÐÐ]], _b(6174)--[[Á½Éú]],
		},
	}, {
		szType = _L["Uncontrollable2"],	-- 10
		tName = {
			_b(374)--[[ÉúÌ«¼«]], _b(1903)--[[Ð¥ÈÕ]],
		},	-- ÉúÌ«¼«2£º374
	}, {
		szType = _L["Reduce-heal"],	-- 11
		tName = {
			_b(2774)--[[Åùö¨]], _b(3195)--[[´©ÐÄåó]], _b(3538)--[[´©ÐÄ]], _b(574)--[[ÎÞÏà]], _b(576)--[[ºãºÓ½ÙÉ³]],
			_b(2496)--[[°Ù×ã¿Ý²Ð]], _b(2502)--[[Ð«ÕÝ]], _b(4030)--[[ÔÂ½Ù]], _b(6155)--[[ÉñÁú½µÊÀ]], _b(8487)--[[¶Ü»÷]],
			_b(9514)--[[³þ¼Ã]], _b(11199)--[[ÍÌ³þ]],
		},
	}, {
		szType = _L["Slower"],	-- 12
		tName = {
			-- ½£Ö÷ÌìµØ¿ÉÄÜ¸ÄÎª£º6072
			-- _b(733)--[[Ì«ÒÒ]],
			_b(4928)--[[¼õËÙ]], _b(549)--[[´©]], _b(450)--[[ÐþÒ»]], _b(523)--[[²½³Ù]], _b(2274)--[[²ø×ã]], _b(560)--[[ÉúÌ«¼«]],
			_b(563)--[[±§²ÐÊ½]], _b(584)--[[ÉÙÑôÖ¸]], _b(1553)--[[½£Ö÷ÌìµØ]], _b(1720)--[[¾ªÌÎ]],
			_b(2297)--[[Ç§Ë¿]], _b(3484)--[[±ù·â]], _b(3226)--[[¶¾ÝðÞ¼]], _b(4054)--[[Òµº£×ï¸¿]], _b(6275)--[[»ðÎè³¤¿Õ]],
			_b(6259)--[[Ñ©ÖÐÐÐ]], _b(6191)--[[ÒµÁ¦]], _b(6162)--[[É½Õó]], _b(6130)--[[Âñ¹Ç]], _b(6078)--[[±©ÓêÀæ»¨Õë]],
			_b(3466)--[[ë¾×ã]], _b(4435)--[[·üÒ¹¡¤»º]], _b(8299)--[[¶ÜÇ½]], _b(8398)--[[¾íÔÆ]], _b(8492)--[[ÄÑÐÐ]],
			_b(9170)--[[½û¸¿]], _b(10001)--[[ºäÀ×]], _b(9507)--[[½£¡¤¹¬]], _b(9217)--[[·çÈëËÉ]], _b(11168)--[[·ü³¾]],
			_b(11245)--[[»÷¶¦]],
		},
	}, {
		szType = _L["Others"],	-- 13
		tName = {
			_b(678)--[[°ø»¨ËæÁø]], _b(3929)--[[Áú»ê]], _b(198)--[[ÐìÈçÁÖ]], _b(203)--[[Ð¥Èç»¢]],
			_b(3858)--[[ÉùÈ¤]], _b(994)--[[µ¹µØ]], _b(3399)--[[ÎÞÉù]], _b(3276)--[[×·ÃüÎÞÉù]], _b(4028)--[[Ê¥ÔÂÓÓ]],
			_b(6354)--[[Ðé»Ø]], _b(6346)--[[·ç¹ýÎÞºÛ]], _b(6350)--[[ÁÙ·ç]], _b(6266)--[[ÐÐÆøÑª]], _b(6224)--[[èÉÆü]],
			_b(6172)--[[Ó¥Ä¿]], _b(6143)--[[ÈªÄýÔÂ]], _b(6121)--[[·ç»¢]], _b(6122)--[[ÄÁÔÆ]], _b(6425)--[[ÌìµØ¸ù]],
			_b(6085)--[[Ó°½Ý]], _b(5970)--[[·æÕë]], _b(5875)--[[ÉÆ»¤]], _b(5789)--[[·±Òô¼±½Ú]], _b(5666)--[[ÎíÍâ½­É½]],
			_b(999)--[[Óê¼¯]], _b(6074)--[[¶ñ¹·À¹Â·]], _b(376)--[[³åÒõÑô]], _b(4937)--[[ÈÕÔÂÁé»ê]], _b(4937,2)--[[ÈÕÔÂÍ¬»Ô]],
			_b(2315)--[[Å®æ´²¹Ìì]], _b(2795)--[[ÂÞºº½ðÉí]], _b(2778)--[[Ô¨]], _b(3215)--[[¾£Ìì¼¬µØ]], _b(8438)--[[¶ÜÁ¢]],
			_b(6256)--[[ÎÖÍÁ]], _b(2542)--[[Óñó¸Ï×¼À]],  _b(2920)--[[¼±Çú]], _b(748)--[[µþÈÐ]], _b(6223)--[[»î¼À]],
			_b(8451)--[[¿ñ¾ø]], _b(8391)--[[¶Ü·É]], _b(126)--[[ºÁÕë]], _b(8378)--[[»ºÉî]], _b(9175)--[[Ï¢ÁÆ]],
			_b(9909)--[[ÈÕÔÂÆë¹â]], _b(10015)--[[Çå¸è]], _b(10121)--[[Ó³ÈÕ]], _b(9962)--[[Æ½óÆ]], _b(9263)--[[½­ÖðÔÂÌì]],
			_b(4462)--[[³¬È»ÎïÍâ]], _b(9271)--[[Þ’¹â]], _b(9277)--[[Þ’ÃÎ]], _b(8491)--[[·Å¸è]], _b(10212)--[[ÑïìºÉ³³¡]],
			_b(9395)--[[·çÈëËÉ]], _b(10278)--[[ÃÎÎ´ÐÑ]], _b(11109)--[[Ð¥ß¸]], _b(1722,1)--[[½£Ãù]], _b(20052)--[[ÄæÂÒ]],
		},
	}, {
		szType = _L["Silence2"],	-- 14
		tName = {
			_b(445)--[[ÇÀÖéÊ½]], _b(690)--[[½£ÐÄÍ¨Ã÷]], _b(2182)--[[°ËØÔ¶´Ðþ]], _b(2838)--[[½£ÆÆÐé¿Õ]],
			_b(3227)--[[Ã·»¨Õë]], _b(2807)--[[ÆàÇÐ]], _b(2490)--[[ó¸Ð¥ÃÔÐÄ]], _b(585)--[[ØÊÒõÖ¸]],
			_b(9214)--[[ÇåÒô³¤Ð¥]],
		},
	}, {
		szType = _L["Orange-weapon"],	-- 15
		tName = {
			_b(1914)--[[²ÔÁú]], _b(1921)--[[Çà¾ý]], _b(6471)--[[Ç§Ò¶³¤Éú]],
			-- _b(1918)--[[...]],
			_b(1911,1)--[[Ëé»ê]], _b(1911,2)--[[·Ùº£]], _b(1911,3)--[[»ðÁúÁ¤Èª]], _b(1911,4)--[[×ÏÁú¼ÅµØ]],
			_b(1912,1)--[[´Ý³Ç]], _b(1912,2)--[[³õ³¾]], _b(1912,3)--[[ËÝÁ÷]], _b(1912,4)--[[ÍÌºç]],
			_b(1913,1)--[[±ÌÂä]], _b(1913,2)--[[¶Ï¹í]], _b(1913,3)--[[Âä·ï]], _b(1913,4)--[[Ä«µß]],
			_b(1915,1)--[[ÍÌÎâ]], _b(1915,2)--[[òÔÓ°]], _b(1915,3)--[[Ñ©Ãû]], _b(1915,4)--[[ÖÜÁ÷ÐÇÎ»]],
			_b(1916,1)--[[ÓñÇåÐþÃ÷]], _b(1916,2)--[[ÁôÇé]], _b(1916,3)--[[³àÏöºìÁ«]], _b(1916,4)--[[Ô¨Î¢Ö¸Ðþ]],
			_b(1917,1)--[[ÓÄÔÂ¡¤ÂÒ»¨]], _b(1917,2)--[[³àÁ·À¶Òí]], _b(1917,3)--[[¸É½«¡¤ÄªÐ°]], _b(1917,4)--[[º®Éù¡¤¼ÅÓ°]],
			_b(1919,1)--[[ÁúÄ¾½ðÌÙ]], _b(1919,2)--[[°×¹ÇËéÔÆ]], _b(1919,3)--[[È¼Ä¾]], _b(1919,4)--[[¸¡ÐÄ¡¤½Ù]],
			_b(1920,1)--[[°×ÒÂ·ÙÌì]], _b(1920,2)--[[Î÷Ìì]], _b(1920,3)--[[Á«ÐÄ¹Û·ð]], _b(1920,4)--[[Á«»ª¡¤Ôµ]],
			_b(1922,1)--[[Ö¯Ñ×¶Ï³¾]], _b(1922,2)--[[±ÌÍõ]], _b(1922,3)--[[Ì«°¢]], _b(1922,4)--[[ÈõË®]],
			_b(3028,1)--[[Ô¡»Ë]], _b(3028,2)--[[ÇàÚ¤]], _b(3028,3)--[[Ì«ÉÏÍüÇé]], _b(3028,4)--[[ç­Óñ²¦ÔÆ]],
			_b(3487,1)--[[µØÔ¨³ÁÐÇ]], _b(3487,2)--[[ð°ÏèÌì]], _b(3487,3)--[[·ïÎ²Ìì»ú]], _b(3487,4)--[[ËéÆÁ³ÁÐÇ]],
			_b(3488,1)--[[¿×È¸Óð]], _b(3488,2)--[[º¬É³ÉäÓ°]], _b(3488,3)--[[´ÝÉ½åó]], _b(3488,4)--[[Ôì»¯Òì¹ì]],
			_b(4930,1)--[[»ð»ê]], _b(4930,2)--[[±¯Ä§¼¢»ð]], _b(4930,3)--[[Ã÷ÍõÕòÓü]], _b(4930,4)--[[²ÐÔÂ¾ªÌì]],
			_b(4931,1)--[[Áú»Ú]], _b(4931,2)--[[¸¡³ÁÕÕÓ°]], _b(4931,3)--[[·ÙÈýÊÀ]], _b(4931,4)--[[Ö´ÊÖ]],
			_b(6466,1)--[[ºøÖÐÇ¬À¤]], _b(6466,2)--[[ËªÔÂÃ÷]], _b(6466,3)--[[ÖËÓüÐ°Áú]], _b(6646,4)--[[ÑÄ·ç³°Óê]],
			_b(8474,1)--[[ÑªÔÆ]], _b(8474,2)--[[Ì«³õÉçð¢]], _b(8474,3)--[[Õ÷Ìì]], _b(8474,4)--[[ÌâÁú”í]],
			_b(8474,5)--[[Ç§Øð]], _b(8474,6)--[[¾ÉÊÈ]], _b(8474,7)--[[ÖìÐù»³È¸]], _b(8474,8)--[[ÐÞÂÞ¹íÃæ]],
			_b(10192,1)--[[ÇàÓñÁ÷]], _b(10192,4)--[[¶´ÏÉÒý]], _b(10193,1)--[[Ó¯È±]], _b(10193,4)--[[ÎÄ¼§Àá]],
			_b(11376,1)--[[ÓêÑÒ½ðÁ«]], _b(11376,2)--[[Ñ©Å­]], _b(11376,3)--[[Ñª±¯]], _b(11376,4)--[[ÐÂÍ¤ºî]],
		},
	}, {
		szType = _L["BanSprint"],	-- 16
		tName = {
			_b(562,1)--[[ÍÌÈÕÔÂ]], _b(562,4)--[[Ç§Ë¿ÃÔÐÄ]], _b(562,5)--[[ÃÔ»Ã]], _b(562,7)--[[Éí·¦]], _b(562,8)--[[ÖÍÓ°]], _b(562,9)--[[çéÏÒ]],
			_b(1939)--[[ÔÆ¾°]], _b(6074)--[[¶ñ¹·À¹Â·]], _b(4497)--[[»ÃÏà]], _b(535)--[[°ë²½µß]], _b(562,15)--[[²½²Ð]],
			_b(10246)--[[ÖØÎ§]], _b(562,21)--[[ÐÐÔó]],
		},
	}
}

-- reset cd
_HM_TargetMon.tSkillReset = {
	[_s(552)--[[ÁÚÀïÇú]]] = { _s(557)--[[ÌìµØµÍ°º]], _s(550)--[[ÈµÌ¤Ö¦]], _s(574)--[[µûÅª×ã]], _s(548)--[[Áú³ØÀÖ]] },
	[_s(425)--[[Óù±¼Í»]]] = { _s(428)--[[¶Ï»ê´Ì]], _s(433)--[[ÈÎ³Û³Ò]], _s(426)--[[ÆÆ¼áÕó]], _s(479)--[[ÁÑ²Ôñ·]] },
	--[_s(346)--[[ÌÝÔÆ×Ý]]] = { _s(9003)--[[õæÔÆÖðÔÂ]] },
	--[_s(2645)--[[ÂÒÈ÷ÇàºÉ]]] = { _s(182)--[[ÓñÊ¯¾ã·Ù]] },
	[_s(372)--[[×ªÇ¬À¤]]] = { _s(358)--[[ÉúÌ«¼«]], _s(361)--[[ÁèÌ«Ðé]], _s(357)--[[»¯ÈýÇå]], _s(363)--[[ÍÌÈÕÔÂ]] },
	[_s(1651)--[[¶Ï³±]]] = { _s(1593)--[[ÔÆ·ÉÓñ»Ê]] },
	[_s(3978)--[[ÉúÃðÓè¶á]]] = { _s(3974)--[[°µ³¾ÃÖÉ¢]], _s(3975)--[[²ÀÎ·°µÐÌ]], _s(4910)--[[ÎÞÃ÷»êËø]], _s(3977)--[[Á÷¹âÇôÓ°]], _s(3976)--[[Òµº£×ï¸¿]], _s(3979)--[[ÇýÒ¹¶Ï³î]] },
	[_s(14081)--[[¹ÂÓ°»¯Ë«]]] = { _s(14073)--[[Ð¦°Á¹âÒõ]], _s(14074)--[[½­ÖðÔÂÌì]], _s(14075)--[[ÔÆÉú½áº£]], _s(14154)--[[Þ’ÃÎÖð¹â]] },
	[_s(14626)--[[ÎÞ¾Ì]]] = { _s(5267)--[[ÁúÐ¥¾ÅÌì]] },
	[_s(14841)--[[Ê¯»¢]]] = { _s(13070)--[[¶Ü±Ú]] },
	--[_s(153)--[[´øÂö¡¤¹âÃ÷]]] = { _s(413)--[[ÊØÈçÉ½]], _s(313)--[[èº¹âÑø»Þ]], _s(1645)--[[·çÀ´ÎâÉ½]], _s(3114)--[[¾ªºèÓÎÁú]] },
	--[_s(1959)--[[ÈÎÂö¡¤ÉñãÚ]]] = { _s(131)--[[±ÌË®ÌÏÌì]], _s(555)--[[·çÐäµÍ°º]], _s(2235)--[[Ç§µûÍÂÈð]] },
	--[_s(167)--[[³åÂö¡¤ÓÄÃÅ]]] = { _s(371)--[[ÕòÉ½ºÓ]], _s(573)--[[ÂúÌÃÊÆ]], _s(136)--[[Ë®ÔÂÎÞ¼ä]], _s(257)--[[¶Í¹Ç¾÷]], _s(3094)--[[ÐÄÎÞÅÔæð]], _L["Call pet"], _s(3969)--[[¹âÃ÷Ïà]] },
}

-- special repeat-name buff
_HM_TargetMon.tFixedBuffEx = {
	[_L("Invincible_%s", _b(6182)--[[Ú¤Ôó]])] = 6182,
	[_L("Silence_%s", _b(712)--[[À¼´ÝÓñÕÛ]])] = 712,
	[_L("Silence_%s", _b(11171)--[[·çÇÐ]])] = 11171,
	[_L("Halt_%s", _b(2780)--[[½£³åÒõÑô]])] = 2780,
	[_L("Halt_%s", _b(5876)--[[ÉÆ»¤]])] = 5876,
	[_L("Halt_%s", _b(8455)--[[¶ÜÒã]])] = 8455,
	[_L("Entrap_%s", _b(1931)--[[ÍÂ¹ÊÄÉÐÂ]])] = 1931,
	[_L("Entrap_%s", _b(5809)--[[Ì«ÒÒ]])] = 5809,
	[_L("Entrap_%s", _b(5764)--[[°Ù×ã]])] = 5764,
	[_L("Entrap_%s", _b(5793)--[[Ëé±ù]])] = 5793,
	[_L("Entrap_%s", _b(8327)--[[¶Ï½î]])] = 8327,
	[_L("Entrap_%s", _b(9730)--[[ÖÓÁÖØ¹Ðã]])] = 9730,
	[_L("Entrap_%s", _b(8251)--[[ÂäÑã]])] = 8251,
	[_L("Slower_%s", _b(4758)--[[½û¸¿]])] = 4758,
	[_L("Slower_%s", _b(11245)--[[»÷¶¦]])] = 11245,
	[_L("Freeze_%s", _b(685)--[[°ø»¨ËæÁø]])] = 685,
	[_L("Freeze_%s", _b(1936)--[[ç­´½ÖéÐä]])] = 1936,
	[_L("Freeze_%s", _b(2113)--[[ÈªÄýÔÂ]])] = 2113,
	[_L("Freeze_%s", _b(6108)--[[Ìì¾øµØÃð]])] = 6108,
	[_L("Uncontrollable2_%s", _b(374)--[[ÉúÌ«¼«]])] = 374,
	[_L("Uncontrollable_%s", _b(730)--[[·ç¸®]])] = 730,
	[_L("Uncontrollable_%s", _b(2781)--[[×ªÇ¬À¤]])] = 2781,
	[_L("Uncontrollable_%s", _b(6314)--[[ÁãÂä]])] = 6314,
	[_L("Uncontrollable_%s", _b(6292)--[[ÍÌÈÕÔÂ]])] = 6292,
	[_L("Uncontrollable_%s", _b(6247)--[[ÃÔÐÄ¹Æ]])] = 6247,
	[_L("Uncontrollable_%s", _b(5995)--[[Ð¦×í¿ñ]])] = 5995,
	[_L("Uncontrollable_%s", _b(6369)--[[¾ÆÖÐÏÉ]])] = 6369,
	[_L("Uncontrollable_%s", _b(6015)--[[ÁúÔ¾ÓÚÔ¨]])] = 6015,
	[_L("Uncontrollable_%s", _b(5754)--[[°ÔÌå]])] = 5754,
	[_L("Uncontrollable_%s", _b(5950)--[[¹Æ³æÏ×¼À]])] = 5950,
	[_L("Uncontrollable_%s", _b(8265)--[[¶ÜÇ½]])] = 8265,
	[_L("Uncontrollable_%s", _b(8449)--[[½Ù»¯]])] = 8449,
	[_L("Uncontrollable_%s", _b(8458)--[[Ë®ÔÂÎÞ¼ä]])] = 8458,
	[_L("Uncontrollable_%s", _b(8483)--[[¶ÜÒã]])] = 8483,
	[_L("Uncontrollable_%s", _b(8716)--[[º´ÎÀ]])] = 8716,
	[_L("Uncontrollable_%s", _b(9294)--[[¹ÂÓ°]])] = 9294,
	[_L("Uncontrollable_%s", _b(9848)--[[Ì½Ã·]])] = 9848,
	[_L("Uncontrollable_%s", _b(9068)--[[¾»¹û]])] = 9068,
	[_L("Uncontrollable_%s", _b(6192)--[[ÆÐÌáÉí]])] = 6192,
	[_L("Uncontrollable_%s", _b(11385)--[[Î÷³þ±¯¸è]])] = 11385,
	[_L("Breakout_%s", _b(5994)--[[¾ÆÖÐÏÉ]])] = 5994,
	[_L("Breakout_%s", _b(2779)--[[Ô¨]])] = 2779,
	[_L("Slower_%s", _b(560)--[[ÉúÌ«¼«]])] = 560,
	[_L("Slower_%s", _b(733)--[[Ì«ÒÒ]])] = 733,
	[_L("Slower_%s", _b(3484)--[[±ù·â]])] = 3484,
	[_L("Slower_%s", _b(6162)--[[É½Õó]])] = 6162,
	[_L("Slower_%s", _b(6078)--[[±©ÓêÀæ»¨Õë]])] = 6078,
	[_L("Slower_%s", _b(8299)--[[¶ÜÇ½]])] = 8299,
	[_L("Slower_%s", _b(9170)--[[½û¸¿]])] = 9170,
	[_L("Slower_%s", _b(9217)--[[·çÈëËÉ]])] = 9217,
	[_L("Halt_%s", _b(548)--[[Í»]])] = 548,
	[_L("Halt_%s", _b(8329)--[[º³µØ]])] = 8329,
	[_L("Dodge_%s", _b(5668)--[[·ç´µºÉ]])] = 5668,
	[_L("Dodge_%s", _b(6174)--[[Á½Éú]])] = 6174,
	[_L("Dodge_%s", _b(6299)--[[Óù·ç¶øÐÐ]])] = 6299,
	[_L("Reduce-dealing_%s", _b(3195)--[[´©ÐÄåó]])] = 3195,
	[_L("Reduce-injury_%s", _b(384)--[[×ªÇ¬À¤]])] = 384,
	[_L("Reduce-injury_%s", _b(4439)--[[Ì°Ä§Ìå]])] = 4439,
	[_L("Reduce-injury_%s", _b(6315)--[[ÁãÂä]])] = 6315,
	[_L("Reduce-injury_%s", _b(6240)--[[ÐþË®¹Æ]])] = 6240,
	[_L("Reduce-injury_%s", _b(5996)--[[Ð¦×í¿ñ]])] = 5996,
	[_L("Reduce-injury_%s", _b(5810)--[[ÄÔ»§]])] = 5810,
	[_L("Reduce-injury_%s", _b(8279)--[[¶Ü±Ú]])] = 8279,
	[_L("Reduce-injury_%s", _b(8300)--[[¶ÜÇ½]])] = 8300,	-- or 8650
	[_L("Reduce-injury_%s", _b(8495)--[[º´ÎÀ]])] = 8495,
	[_L("Reduce-injury_%s", _b(10051)--[[±­Ë®ÁôÓ°]])] = 10051,
	[_L("Reduce-injury_%s", _b(9334)--[[Ã·»¨ÈýÅª]])] = 9334,
	[_L("Reduce-injury_%s", _b(1802)--[[ÓùÌì]])] = 1802,
	[_L("Reduce-injury_%s", _b(11344)--[[ÆÆ¸ª³ÁÖÛ]])] = 11344,
	[_L("BanSprint_%s", _b(562, 1)--[[ÍÌÈÕÔÂ]])] = 562,
	[_L("BanSprint_%s", _b(562, 9)--[[çéÏÒ]])] = 562,
	[_L("BanSprint_%s", _b(562, 15)--[[²½²Ð]])] = 562,
	[_L("BanSprint_%s", _b(6074)--[[¶ñ¹·À¹Â·]])] = 6074,
	[_L("Others_%s", _b(6354)--[[Ðé»Ø]])] = 6354,
	[_L("Others_%s", _b(6266)--[[ÐÐÆøÑª]])] = 6266,
	[_L("Others_%s", _b(5970)--[[·æÕë]])] = 5970,
	[_L("Others_%s", _b(5875)--[[ÉÆ»¤]])] = 5875,
	[_L("Others_%s", _b(5789)--[[·±Òô¼±½Ú]])] = 5789,
	[_L("Others_%s", _b(6425)--[[ÌìµØ¸ù]])] = 6425,
	[_L("Others_%s", _b(2778)--[[Ô¨]])] = 2778,
	[_L("Others_%s", _b(6256)--[[ÎÖÍÁ]])] = 6256,
	[_L("Others_%s", _b(9395)--[[·çÈëËÉ]])] = 9395,
		[_L("Others_%s", _b(1722,1)--[[½£Ãù]])] = 1722,
}

-- special skill alias
_HM_TargetMon.tFixedSkill = {
	[_s(2965)--[[±ÌµûÒý]]] = _L["Call pet"],
	[_s(2221)--[[Ê¥Ð«Òý]]] = _L["Call pet"],
	[_s(2222)--[[Óñó¸Òý]]] = _L["Call pet"],
	[_s(2223)--[[ÁéÉßÒý]]] = _L["Call pet"],
	[_s(2224)--[[·çòÚÒý]]] = _L["Call pet"],
	[_s(2225)--[[ÌìÖëÒý]]] = _L["Call pet"],
}


-- load buffex cache
_HM_TargetMon.LoadBuffEx = function()
	local aCache = {}
	local aType = {}
	for k, v in ipairs(_HM_TargetMon.tBuffList4) do
		aType[k] = v.szType
		for _, vv in ipairs(v.tName) do
			local kkk = _HM_TargetMon.tFixedBuffEx[v.szType .. "_" .. vv] or vv
			aCache[kkk] = { v.szType, k }
			if kkk == 8300 then
				aCache[8650] = { v.szType, k }
			end
		end
	end
	-- override by customdata
	for k, v in pairs(HM_TargetMon.tBuffList) do
		for kk, vv in pairs(v) do
			local szType = aType[k]
			local kkk = _HM_TargetMon.tFixedBuffEx[szType .. "_" .. kk] or kk
			if vv == true then
				aCache[kkk] = { szType, k }
			else
				aCache[kkk] = nil
			end
		end
	end
	_HM_TargetMon.tBuffCache = aCache
end

-- load  monskill cache
_HM_TargetMon.LoadSkillMon = function()
	local aCache = {}
	for _, v in pairs(_HM_TargetMon.tSkillList4) do
		for kk, vv in pairs(v) do
			aCache[kk] = vv
		end
	end
	-- override by customdata
	for _, v in pairs(HM_TargetMon.tSkillList) do
		for kk, vv in pairs(v) do
			if vv > 0 then
				aCache[kk] = vv
			else
				aCache[kk] = nil
			end
		end
	end
	_HM_TargetMon.tSkillCache = aCache
end

-- get buffex type, type index
_HM_TargetMon.GetBuffExType = function(dwBuffID, dwLevel, tNo)
	if not _HM_TargetMon.tBuffCache then
		_HM_TargetMon.LoadBuffEx()
	end
	if not tNo or not tNo[dwBuffID] then
		local rec = _HM_TargetMon.tBuffCache[dwBuffID]
		if not rec and type(dwBuffID) == "number" then
			local szName = HM.GetBuffName(dwBuffID, dwLevel)
			if szName and szName ~= "" and (not tNo or not tNo[szName]) then
				rec = _HM_TargetMon.tBuffCache[szName]
			end
		end
		if rec then
			return rec[1], rec[2]
		end
	end
end

-- get buffex list
_HM_TargetMon.GetBuffExList = function(aBuff, tNo)
	local mBuff, nFrame = {}, GetLogicFrameCount()
	for _, v in ipairs(aBuff) do
		if v.nEndFrame > nFrame and Table_BuffIsVisible(v.dwID, v.nLevel) then
			local szType, nType = _HM_TargetMon.GetBuffExType(v.dwID, v.nLevel, tNo)
			if szType then
				table.insert(mBuff, { buff = v, szType = szType, nType = nType })
			end
		end
	end
	if #mBuff > 1 then
		table.sort(mBuff, function(a, b) return a.nType < b.nType end)
	end
	return mBuff
end

-- get skillmon cooldown
_HM_TargetMon.GetSkillMonCD = function(szName)
	if not _HM_TargetMon.tSkillCache then
		_HM_TargetMon.LoadSkillMon()
	end
	return _HM_TargetMon.tSkillCache[szName]
end

-- purge: [dwCaster] => { { nEnd, nTotal, dwIconID, szName }, ... }
_HM_TargetMon.PurgeData = function()
	local nExpire , nFrame = 960, GetLogicFrameCount()
	if not _HM_TargetMon.nPurgeFrame then
		_HM_TargetMon.nPurgeFrame = nFrame
	elseif (nFrame - _HM_TargetMon.nPurgeFrame) > nExpire then
		_HM_TargetMon.nPurgeFrame = nFrame
		for k, v in pairs(_HM_TargetMon.tCD) do
			for kk, vv in ipairs(v) do
				if vv.nEnd < nFrame then
					table.remove(v, kk)
				end
			end
			if table.getn(v) == 0 then
				_HM_TargetMon.tCD[k] = nil
			end
		end
	end
end

-- get mon cd for player
_HM_TargetMon.GetPlayerCD = function(dwPlayer)
	local aCD, nFrame = {}, GetLogicFrameCount()
	if _HM_TargetMon.tCD[dwPlayer] then
		aCD = _HM_TargetMon.tCD[dwPlayer]
		for k, v in ipairs(aCD) do
			if v.nEnd < nFrame then
				table.remove(aCD, k)
			end
		end
	end
	return aCD
end

-- get forcetitle
_HM_TargetMon.GetForceTitle = function(nForce)
	if nForce > 0 and g_tStrings.tForceTitle[nForce] then
		return g_tStrings.tForceTitle[nForce]
	end
	return g_tStrings.tForceTitle[0]
end

-- get skill belong force
_HM_TargetMon.GetSkillForce = function(szName)
	local nCount = g_tTable.Skill:GetRowCount()
	for i = 1, nCount do
		local tLine = g_tTable.Skill:GetRow(i)
		if tLine.bShow and tLine.dwIconID ~= 13 and tLine.szName == szName then
			local skill = GetSkill(tLine.dwSkillID, 1)
			if skill then
				local szSchool = Table_GetSkillSchoolName(skill.dwBelongSchool)
				for k, v in pairs(g_tStrings.tForceTitle) do
					if k > 0 and v == szSchool then
						return k
					end
				end
				return 0
			end
		end
	end
end

-- edit skill
_HM_TargetMon.EditSkill = function(nForce, szName)
	local frm = _HM_TargetMon.sFrame
	if not frm then
		-- input
		frm = HM.UI.CreateFrame("HM_TARMON_SKILL", { close = false, w = 381, h = 270 })
		frm:Append("Text", { txt = _L["Skill name"], x = 0, y = 0, font = 27 })
		frm:Append("WndEdit", "Edit_Name", { x = 0, y = 28, limit = 100, w = 290, h = 25 } )
		frm:Append("Text", { txt = _L["Skill CD (unit: sec)"], x = 0, y = 60, font = 27 })
		frm:Append("WndEdit", "Edit_Time", { x = 0, y = 88, limit = 100, w = 290, h = 25 } )
		-- buttons
		frm:Append("WndButton", "Btn_Save", { txt = _L["Save"], x = 45, y = 140 }):Click(function()
			local szName = frm:Fetch("Edit_Name"):Text()
			local nTime = tonumber(frm:Fetch("Edit_Time"):Text())
			if szName == "" then
				HM.Alert(_L["Skill name can not be empty"])
			elseif not nTime then
				HM.Alert(_L["Invalid value of skill CD"])
			else
				local nForce = frm.nForce or _HM_TargetMon.GetSkillForce(szName)
				if not nForce then
					HM.Alert(_L("Invalid skill name [%s]", szName))
				else
					if not HM_TargetMon.tSkillList[nForce] then
						HM_TargetMon.tSkillList[nForce] = {}
					end
					HM_TargetMon.tSkillList[nForce][szName] = nTime
					if not frm.nForce then
						HM.Sysmsg(_L("Added skill CD monitor [%s-%s]", _HM_TargetMon.GetForceTitle(nForce), szName))
					end
					frm:Toggle(false)
					_HM_TargetMon.tSkillCache = nil
				end
			end
		end)
		frm:Append("WndButton", "Btn_Cancel", { txt = _L["Cancel"], x = 145, y = 140 }):Click(function() frm:Toggle(false) end)
		_HM_TargetMon.sFrame = frm
	end
	-- show frm
	frm.nForce = nForce
	if not nForce then
		frm:Title(_L["Add skill CD"])
		frm:Fetch("Edit_Name"):Text(""):Enable(true)
		frm:Fetch("Edit_Time"):Text("")
	else
		local tS = HM_TargetMon.tSkillList[nForce] or {}
		frm:Title(_L["Edit skill CD"])
		frm:Fetch("Edit_Name"):Text(szName):Enable(false)
		frm:Fetch("Edit_Time"):Text(tostring(math.abs(tS[szName] or _HM_TargetMon.tSkillList4[nForce][szName])))
	end
	frm:Toggle(true)
end

-- get skill setting menu
_HM_TargetMon.GetSkillMenu = function()
	local m0 = {
		{ szOption = _L["* New *"], fnAction = _HM_TargetMon.EditSkill },
		{
			szOption = _L["* Reset *"],
			fnAction = function()
				HM_TargetMon.tSkillList = {}
				_HM_TargetMon.tSkillCache = nil
			end
		},
		{ bDevide = true, }
	}
	-- default data
	for k, v in pairs(_HM_TargetMon.tSkillList4) do
		local m1 = { szOption = _HM_TargetMon.GetForceTitle(k) }
		local tS = HM_TargetMon.tSkillList[k] or {}
		local aS = {}
		for kk, vv in pairs(tS) do
			if vv > 0 then
				aS[kk] = vv
			end
		end
		for kk, vv in pairs(v) do
			if not tS[kk] then
				aS[kk] = vv
			end
		end
		if not IsEmpty(aS) then
			for kk, vv in pairs(aS) do
				table.insert(m1, {
					szOption = kk .. " (" .. math.abs(vv) .. ")",
					bCheck = true, bChecked = vv > 0,
					fnAction = function() v[kk] = 0 - vv end,
					{ szOption = _L["Edit"], fnAction = function() _HM_TargetMon.EditSkill(k, kk) end },
					{ szOption = _L["Remove"], fnAction = function()
						if not HM_TargetMon.tSkillList[k] then
							HM_TargetMon.tSkillList[k] = {}
						end
						HM_TargetMon.tSkillList[k][kk] = 0
						_HM_TargetMon.tSkillCache = nil
						HM.Sysmsg(_L("Removed skill CD monitor [%s-%s]", _HM_TargetMon.GetForceTitle(k), kk)) end },
				})
			end
			table.insert(m0, m1)
		end
	end
	return m0
end

-- edit buff
_HM_TargetMon.EditBuff = function()
	local frm = _HM_TargetMon.bFrame
	if not frm then
		-- input
		frm = HM.UI.CreateFrame("HM_TARMON_BUFF", { close = false, w = 381, h = 200 })
		local nX = frm:Append("Text", { txt = _L["Name"], x = 0, y = 20, font = 27 }):Pos_()
		nX = frm:Append("WndEdit", "Edit_Name", { x = nX + 5, y = 20, limit = 100, w = 160, h = 25 } ):Pos_()
		frm:Append("WndComboBox", "Combo_Type", { x = nX + 5, y = 20, w = 80, h = 25 } ):Menu( function()
			local m0 = {}
			for k, v in ipairs(_HM_TargetMon.tBuffList4) do
				table.insert(m0, { szOption = v.szType, fnAction = function()
					frm.nType = k
					frm:Fetch("Combo_Type"):Text(v.szType)
				end})
			end
			return m0
		end)
		-- buttons
		frm:Append("WndButton", "Btn_Save", { txt = _L["Save"], x = 45, y = 80 }):Click(function()
			local szName = frm:Fetch("Edit_Name"):Text()
			if szName == "" then
				HM.Alert(_L["Buff name can not be empty"])
			else
				local bExist = nil
				local tBuff = HM_TargetMon.tBuffList[frm.nType] or {}
				for k, v in pairs(tBuff) do
					if k == szName then
						bExist = v == true
						break
					end
				end
				if bExist == nil then
					local tBuff4 = _HM_TargetMon.tBuffList4[frm.nType]
					if tBuff4 then
						for _, v in ipairs(tBuff4.tName) do
							if v == szName then
								bExist = true
								break
							end
						end
					end
				end
				if bExist then
					return HM.Alert(_L["Buff name already exists"])
				end
				tBuff[szName] = true
				HM_TargetMon.tBuffList[frm.nType] = tBuff
				HM.Sysmsg(_L("Added buff monitor [%s-%s]", frm:Fetch("Combo_Type"):Text(), szName))
				frm:Toggle(false)
				_HM_TargetMon.tBuffCache = nil
			end
		end)
		frm:Append("WndButton", "Btn_Cancel", { txt = _L["Cancel"], x = 145, y = 80 }):Click(function() frm:Toggle(false) end)
		_HM_TargetMon.bFrame = frm
	end
	-- show frm
	frm.nType = table.getn(_HM_TargetMon.tBuffList4)
	frm:Fetch("Edit_Name"):Text("")
	frm:Fetch("Combo_Type"):Text(_HM_TargetMon.tBuffList4[frm.nType].szType)
	frm:Title(_L["Add buff monitor"])
	frm:Toggle(true)
end

-- get buff setting menu
_HM_TargetMon.GetBuffMenu = function()
	local m0 = {
		{ szOption = _L["* New *"], fnAction = _HM_TargetMon.EditBuff },
		{
			szOption = _L["* Reset *"],
			fnAction = function()
				HM_TargetMon.tBuffList = {}
				_HM_TargetMon.tBuffCache = nil
			end
		},
		{ bDevide = true, }
	}
	for k, v in ipairs(_HM_TargetMon.tBuffList4) do
		if not IsEmpty(v.tName) then
			local m1 = { szOption = v.szType }
			local tB = HM_TargetMon.tBuffList[k] or {}
			local aB = {}
			for kk, vv in pairs(tB) do
				if vv == true then
					table.insert(aB, kk)
				end
			end
			for _, vv in ipairs(v.tName) do
				if tB[vv] == nil then
					table.insert(aB, vv)
				end
			end
			for _, vv in ipairs(aB) do
				local vk = _HM_TargetMon.tFixedBuffEx[v.szType .. "_" .. vv] or vv
				table.insert(m1, { szOption = vv,
					{ szOption = _L["Monitor target"], bCheck = true, bChecked = not HM_TargetMon.tNTBuffEx[vk], fnAction = function()
						if HM_TargetMon.tNTBuffEx[vk] then
							HM_TargetMon.tNTBuffEx[vk] = nil
						else
							HM_TargetMon.tNTBuffEx[vk] = true
						end
					end }, { szOption = _L["Monitor myself"], bCheck = true, bChecked = not HM_TargetMon.tNSBuffEx[vk], fnAction = function()
						if HM_TargetMon.tNSBuffEx[vk] then
							HM_TargetMon.tNSBuffEx[vk] = nil
						else
							HM_TargetMon.tNSBuffEx[vk] = true
						end
					end }, { szOption = _L["Remove"], fnAction = function()
						if not HM_TargetMon.tBuffList[k] then
							HM_TargetMon.tBuffList[k] = {}
						end
						HM_TargetMon.tBuffList[k][vv] = false
						_HM_TargetMon.tBuffCache = nil
						HM.Sysmsg(_L("Removed buff monitor [%s_%s]", v.szType, vv))
					end },
				})
			end
			table.insert(m0, m1)
		end
	end
	return m0
end

---------------------------------------------------------------------
-- ´°¿Ú½çÃæ
---------------------------------------------------------------------
-- add box/text pair
_HM_TargetMon.GetBoxText = function(hBox, hText)
	local nCount = hBox:GetItemCount()
	if hBox.nIndex < nCount then
		nCount = hBox.nIndex
	else
		hBox:AppendItemFromString("<box> w=" .. HM_TargetMon.nSize .. " h=" .. HM_TargetMon.nSize .. " postype=7 eventid=768 </box>")
		hText:AppendItemFromString("<text> w=" .. HM_TargetMon.nSize .. " h=15 postype=7 halign=1 valign=1 </text>")
		if not HM_TargetMon.bBoxEvent2 then
			hBox:Lookup(nCount):ClearEvent()
		end
	end
	hBox.nIndex = nCount + 1
	return hBox:Lookup(nCount), hText:Lookup(nCount)
end

-- get time & font
_HM_TargetMon.GetLeftTime = function(nEndFrame, bFloat)
	local nSec = (nEndFrame - GetLogicFrameCount()) / 16
	if nSec < 100 then
		if bFloat and nSec < 3 then
			return string.format("%.1f\"", nSec), 204
		else
			return string.format("%d\"", nSec), 204
		end
	elseif nSec < 3600 then
		return string.format("%d'", nSec / 60), 203
	elseif nSec < 36000 then
		return string.format("%d", nSec / 3600), 203
	else
		return "", 203
	end
end

-- update skill box
_HM_TargetMon.UpdateSkillBox = function(data, box, txt)
	local nChongNeng = _HM_TargetMon.tChongNeng[data.szName]
	if not box.dwID then
		txt:SetFontScheme(15)
		box:SetOverTextFontScheme(0, 15)
		box:SetOverTextPosition(1, ITEM_POSITION.LEFT_TOP)
		box.OnItemMouseEnter = function()
			this:SetObjectMouseOver(1)
			local x, y = this:GetAbsPos()
			local w, h = this:GetSize()
			OutputSkillTip(this.dwID, this.dwLevel, { x, y, w, h })
		end
		box.OnItemMouseLeave = function()
			this:SetObjectMouseOver(0)
			HideTip()
		end
	end
	if box.dwID ~= data.dwSkillID or box.dwLevel ~= data.dwLevel then
		box.dwID = data.dwSkillID
		box.dwLevel = data.dwLevel
		box:SetObject(UI_OBJECT_SKILL, data.dwSkillID, data.dwLevel)
		box:SetObjectIcon(data.dwIconID)
		box:SetObjectCoolDown(1)
		if string.len(data.szName) > 6 and HM_TargetMon.nSize < 70  then
			txt:SetText(string.sub(data.szName, 1, 4))
		elseif string.len(data.szName) > 4 and HM_TargetMon.nSize < 45 then
			txt:SetText(string.sub(data.szName, 3, 6))
		else
			txt:SetText(data.szName)
		end
		if nChongNeng then
			-- ºÚÉ«ºÍºìÉ«µÄ±ß¿ò
			box:SetExtentLayer(2, "ui\\image\\Common\\Box.UITex", 2)
			box:SetExtentLayer(3, "ui\\image\\Common\\Box.UITex", 15)
			box:SetExtentImageType(3, IMAGE.REVERSE_TIMER_SHOW)
			box:SetExtentTimeStartAngle(3, math.pi * 135 / 180)
		else
			box:ClearExtentLayer(3)
			box:ClearExtentLayer(2)
			box:SetOverText(2, "")
		end
	end
	if nChongNeng then
		local nLogicFrame = GetLogicFrameCount()
		local nSec = _HM_TargetMon.GetSkillMonCD(data.szName)
		local nLeftSec = (data.nEnd - nLogicFrame) / 16
		if math.ceil(nLeftSec / nSec) == nChongNeng then -- ½øÈëCD×´Ì¬
			box:SetObjectCoolDown(1)
			box:SetCoolDownPercentage(1 - nLeftSec % nSec / nSec)
		else -- ·ñÔò½øÈë³äÄÜ×´Ì¬
			box:SetObjectCoolDown(0)
		end
		local szTime, nFont = _HM_TargetMon.GetLeftTime(data.nEnd - (math.floor(nLeftSec / nSec) * nSec * 16))
		box:SetOverText(1, szTime)
		box:SetOverTextFontScheme(1, nFont)
		box:SetOverText(2, nChongNeng - math.ceil(nLeftSec / nSec)  .. " ") -- ÕâÀïÊý×Ö¿¿×îÓÒÁË²»ºÃ¿´ ÅäºÏUI¼Ó¸ö¿Õ¸ñ
		box:SetOverTextFontScheme(2, 15)
		box:SetOverTextPosition(2, ITEM_POSITION.BOTTOM_RIGHT)
		box:SetExtentPercent(3, 1 - nLeftSec % nSec / nSec)
	else
		local szTime, nFont = _HM_TargetMon.GetLeftTime(data.nEnd)
		box:SetOverText(1, szTime)
		box:SetOverTextFontScheme(1, nFont)
		box:SetCoolDownPercentage(1 - (data.nEnd - GetLogicFrameCount()) / data.nTotal)
		-- nTouzhi
		local nTouzhi = _HM_TargetMon.tTouZhi[data.szName]
		if nTouzhi then
			box:SetOverText(2, nTouzhi - data.nUsed .. " ")
			box:SetOverTextFontScheme(2, 15)
			box:SetOverTextPosition(2, ITEM_POSITION.BOTTOM_RIGHT)
		end
	end
	box:Show()
	txt:Show()
end

-- update buff box
_HM_TargetMon.UpdateBuffBox = function(data, box, txt, szType)
	if not box.dwID then
		box:SetOverTextFontScheme(0, 15)
		box:SetOverTextPosition(1, ITEM_POSITION.LEFT_TOP)
		box.OnItemMouseEnter = function()
			this:SetObjectMouseOver(1)
			local dwOwner = this:GetParent().dwOwner
			local x, y = this:GetAbsPos()
			local w, h = this:GetSize()
			OutputBuffTip(dwOwner, this.dwID, this.nLevel, 1, false, 0, { x, y, w, h })
		end
		box.OnItemMouseLeave = function()
			this:SetObjectMouseOver(0)
			HideTip()
		end
	end
	if box.dwID ~= data.dwID or box.nLevel ~= data.nLevel then
		local szName, dwIconID = HM.GetBuffName(data.dwID, data.nLevel)
		box.dwID = data.dwID
		box:SetObject(UI_OBJECT_NOT_NEED_KNOWN, data.dwID)
		box:SetObjectIcon(dwIconID)
		if szType ~= _L["Others"] and szType ~= _L["Orange-weapon"] then
			szName = string.gsub(szType, "%d+$", "")
		end
		txt:SetText(szName)
		if box:GetParent().dwOwner == GetClientPlayer().dwID then
			if data.bCanCancel then
				txt:SetFontScheme(167)
			else
				txt:SetFontScheme(17)
			end
		else
			if data.bCanCancel then
				txt:SetFontScheme(16)
			else
				txt:SetFontScheme(159)
			end
		end
	end
	box.nLevel = data.nLevel
	if data.nStackNum > 1 then
		box:SetOverText(0, data.nStackNum)
	else
		box:SetOverText(0, "")
	end
	local szTime, nFont = _HM_TargetMon.GetLeftTime(data.nEndFrame, true)
	box:SetOverText(1, szTime)
	box:SetOverTextFontScheme(1, nFont)
	box:Show()
	txt:Show()
end

-- adjust size
_HM_TargetMon.AdjustSize = function(frame)
	local nW, nH = HM_TargetMon.nSize * 3, HM_TargetMon.nSize + 25
	local handle = frame:Lookup("", "")
	local hBox, hText = handle:Lookup("Handle_Box"), handle:Lookup("Handle_Text")
	frame:SetSize(nW, nH)
	handle:SetSize(nW, nH)
	hBox:SetSize(nW, HM_TargetMon.nSize)
	hText:SetSize(nW, 25)
	hText:SetRelPos(0, HM_TargetMon.nSize + 5)
	hBox:Clear()
	hText:Clear()
	handle:FormatAllItemPos()
end

-- anchor
_HM_TargetMon.UpdateAnchor = function(frame)
	local an = HM_TargetMon.tAnchor[frame.nIndex]
	if an then
		-- custom pos
		frame:SetPoint(an.s, 0, 0, an.r, an.x, an.y)
	else
		-- default pos
		local dir = Station.Lookup("Normal/HM_TargetDir")
		if dir then
			local x, y = dir:GetAbsPos()
			if frame.nIndex == 3 then
				local _, h = dir:GetSize()
				frame:SetAbsPos(x, y + h)
			else
				frame:SetAbsPos(x, y - (3 - frame.nIndex) * (HM_TargetMon.nSize + 25))
			end
		else
			frame:SetAbsPos(460, 220 + (frame.nIndex - 1) * (HM_TargetMon.nSize + 25))
		end
	end
	frame:CorrectPos()
end

-- create
_HM_TargetMon.OnFrameCreate = function()
	this:RegisterEvent("ON_ENTER_CUSTOM_UI_MODE")
	this:RegisterEvent("ON_LEAVE_CUSTOM_UI_MODE")
	this:RegisterEvent("UI_SCALED")
	_HM_TargetMon.AdjustSize(this)
	_HM_TargetMon.UpdateAnchor(this)
	if this.nIndex == 1 then
		UpdateCustomModeWindow(this, _L["HM skill CD"])
	elseif this.nIndex == 2 then
		UpdateCustomModeWindow(this, _L["HM target BUFF"])
	elseif this.nIndex == 3 then
		UpdateCustomModeWindow(this, _L["HM self BUFF"])
	end
end

-- breathe
_HM_TargetMon.OnFrameBreathe = function()
	-- base check
	local nFrame, me = GetLogicFrameCount(), GetClientPlayer()
	if not me or (nFrame % 3) ~= (this.nIndex - 1) then return end
	--if not me then return end
	local tar = GetTargetHandle(me.GetTarget())
	-- draw data
	local hBox, hText, bHide = this:Lookup("", "Handle_Box"), this:Lookup("", "Handle_Text"), true
	if this.nIndex == 1 then
		if tar and _HM_TargetMon.tCD[tar.dwID] then
			hBox.nIndex = 0
			for _, v in ipairs(_HM_TargetMon.tCD[tar.dwID]) do
				if v.nEnd > nFrame then
					local box, txt = _HM_TargetMon.GetBoxText(hBox, hText)
					_HM_TargetMon.UpdateSkillBox(v, box, txt)
					bHide = false
				end
			end
		end
	else
		local aBuff, tNo, bMine = nil, nil, false
		if this.nIndex == 2 and tar then	-- target buff
			aBuff = HM.GetAllBuff(tar)
			hBox.dwOwner = tar.dwID
			tNo = HM_TargetMon.tNTBuffEx
			bMine = not IsPlayer(tar.dwID)
		elseif this.nIndex == 3 then -- and (not tar or tar.dwID ~= me.dwID or not HM_TargetMon.bTargetBuffEx) then
			aBuff = HM.GetAllBuff(me)
			hBox.dwOwner = me.dwID
			tNo = HM_TargetMon.tNSBuffEx
		end
		if aBuff then
			local mBuff = _HM_TargetMon.GetBuffExList(aBuff, tNo)
			hBox.nIndex = 0
			if #mBuff > 0 then
				for _, v in ipairs(mBuff) do
					if not bMine or v.buff.dwSkillSrcID == me.dwID then
						local box, txt = _HM_TargetMon.GetBoxText(hBox, hText)
						_HM_TargetMon.UpdateBuffBox(v.buff, box, txt, v.szType)
					end
				end
			end
			bHide = hBox.nIndex == 0
		end
	end
	if bHide then
		hBox:Hide()
		hText:Hide()
	else
		for i = hBox:GetItemCount() - 1, hBox.nIndex, -1 do
			hBox:Lookup(i):Hide()
			hText:Lookup(i):Hide()
		end
		hBox:FormatAllItemPos()
		hText:FormatAllItemPos()
		hBox:Show()
		hText:Show()
		-- right align
		local handle = this:Lookup("", "")
		if (HM_TargetMon.bSkillRight and this.nIndex == 1)
			or (HM_TargetMon.bTargetRight and this.nIndex == 2)
			or (HM_TargetMon.bSelfRight and this.nIndex == 3)
		then
			local w1, _ = handle:GetSize()
			local w2 = hBox.nIndex * HM_TargetMon.nSize
			--local w2, _ = hBox:GetAllItemSize()
			hBox:SetRelPos(w1 - w2, 0)
			hText:SetRelPos(w1 - w2, HM_TargetMon.nSize + 5)
		else
			hBox:SetRelPos(0, 0)
			hText:SetRelPos(0, HM_TargetMon.nSize + 5)
		end
		handle:FormatAllItemPos()
	end
end

-- drag
_HM_TargetMon.OnFrameDragEnd = function()
	this:CorrectPos()
	HM_TargetMon.tAnchor[this.nIndex] = GetFrameAnchor(this)
end

-- event
_HM_TargetMon.OnEvent = function(event)
	if event == "ON_ENTER_CUSTOM_UI_MODE" or event == "ON_LEAVE_CUSTOM_UI_MODE" then
		UpdateCustomModeWindow(this)
	elseif event == "UI_SCALED" then
		_HM_TargetMon.UpdateAnchor(this)
	end
end

-- update frame
_HM_TargetMon.UpdateFrame = function(bEnable, nIndex)
	local frame = Station.Lookup("Normal/HM_TargetMon_" .. nIndex)
	if bEnable then
		if not frame then
			frame = Wnd.OpenWindow(HM.GetAddonInfo().szRootPath .. "HM_TargetMon/HM_TargetMon.ini", "HM_TargetMon_" .. nIndex)
			frame.nIndex = nIndex
			frame.OnFrameBreathe = _HM_TargetMon.OnFrameBreathe
			frame.OnFrameDragEnd = _HM_TargetMon.OnFrameDragEnd
			frame.OnEvent = _HM_TargetMon.OnEvent
			local _this = this
			this = frame
			_HM_TargetMon.OnFrameCreate()
			this = _this
		end
	elseif frame then
		Wnd.CloseWindow(frame)
	end
end

-- update frames
_HM_TargetMon.UpdateFrames = function()
	_HM_TargetMon.UpdateFrame(HM_TargetMon.bSkillMon, 1)
	_HM_TargetMon.UpdateFrame(HM_TargetMon.bTargetBuffEx, 2)
	_HM_TargetMon.UpdateFrame(HM_TargetMon.bSelfBuffEx, 3)
end

-- adjust all size
_HM_TargetMon.AdjustSizeAll = function()
	for i = 1, 3, 1 do
		local frame = Station.Lookup("Normal/HM_TargetMon_" .. i)
		if frame then
			_HM_TargetMon.AdjustSize(frame)
			_HM_TargetMon.UpdateAnchor(frame)
			UpdateCustomModeWindow(frame)
		end
	end
end

---------------------------------------------------------------------
-- ÊÂ¼þ´¦Àíº¯Êý
---------------------------------------------------------------------
_HM_TargetMon.OnSkillCast = function(dwCaster, dwSkillID, dwLevel, szEvent)
	if not HM_TargetMon.bSkillMon then
		return
	end
	-- get name
	local szName, dwIconID = HM.GetSkillName(dwSkillID, dwLevel)
	if not szName or szName == "" or dwIconID == 13 then
		return
	end
	-- for chongnen
	local nChongNeng = _HM_TargetMon.tChongNeng[szName] or _HM_TargetMon.tTouZhi[szName]
	if nChongNeng and szEvent == "DO_SKILL_CAST" then
		return
	end
	-- for channel skill (skip effect log)
	if HM.GetChannelSkillFrame(dwSkillID) and szEvent ~= "DO_SKILL_CAST" then
		return
	end
	_HM_TargetMon.PurgeData()
	if not HM_Jabber then
		HM.Debug3("#" .. dwCaster .. "#" .. szEvent .. " (" .. szName .. "#" .. dwSkillID .. ", Lv" .. dwLevel .. ")")
	end
	-- check reset
	local aReset = _HM_TargetMon.tSkillReset[szName] or {}
	for _, v in ipairs(aReset) do
		local aCD = _HM_TargetMon.tCD[dwCaster] or {}
		for kk, vv in ipairs(aCD) do
			if vv.szName == v then
				table.remove(aCD, kk)
			end
		end
	end
	-- check cd
	if _HM_TargetMon.tFixedSkill[szName] then
		szName = _HM_TargetMon.tFixedSkill[szName]
	end
	local nSec = _HM_TargetMon.GetSkillMonCD(szName)
	if nSec then
		local bAdd = true
		local nTotal = nSec * 16
		local nLogicFrameCount = GetLogicFrameCount()
		local nEnd = nLogicFrameCount + nTotal
		if not _HM_TargetMon.tCD[dwCaster] then
			_HM_TargetMon.tCD[dwCaster] = {}
		else
			for k, v in ipairs(_HM_TargetMon.tCD[dwCaster]) do
				if v.szName == szName then
					if nChongNeng then
						if v.nEnd > nLogicFrameCount then
							v.nEnd   = v.nEnd + nTotal
							v.nTotal = v.nTotal + nTotal
							v.nUsed = v.nUsed + 1
							bAdd = false
						end
					end
					if bAdd then
						table.remove(_HM_TargetMon.tCD[dwCaster], k)
					end
					break
				end
			end
		end
		if bAdd then
			table.insert(_HM_TargetMon.tCD[dwCaster], {
				nEnd = nEnd, nTotal = nTotal,
				dwSkillID = dwSkillID, dwLevel = dwLevel,
				dwIconID = dwIconID, szName = szName,
				nUsed = 1,
			})
		end
	end
end

---------------------------------------------------------------------
-- ÉèÖÃ½çÃæ
---------------------------------------------------------------------
_HM_TargetMon.PS = {}

-- init panel
_HM_TargetMon.PS.OnPanelActive = function(frame)
	local ui, nX = HM.UI(frame), 0
	-- skillmon
	ui:Append("Text", { txt = _L["Target skill"], font = 27 })
	nX = ui:Append("WndCheckBox", { txt = _L["Enable monitor target skill CD"], checked = HM_TargetMon.bSkillMon })
	:Pos(10, 28):Click(function(bChecked)
		HM_TargetMon.bSkillMon = bChecked
		_HM_TargetMon.UpdateFrame(bChecked, 1)
		if not bChecked then _HM_TargetMon.tCD = {} end
	end):Pos_()
	ui:Append("WndCheckBox", { txt = _L["Right aligment"], checked = HM_TargetMon.bSkillRight })
	:Pos(nX + 10, 28):Click(function(bChecked) HM_TargetMon.bSkillRight = bChecked end)
	ui:Append("WndComboBox", { txt = _L["Set monitor skill"], x = 10, y = 58 }):Menu(_HM_TargetMon.GetSkillMenu)
	-- buffex
	ui:Append("Text", { txt = _L["Important BUFF"], font = 27, x = 0, y = 94 })
	nX = ui:Append("WndCheckBox", { txt = _L["Monitor target important BUFF"], checked = HM_TargetMon.bTargetBuffEx })
	:Pos(10, 122):Click(function(bChecked)
		HM_TargetMon.bTargetBuffEx = bChecked
		_HM_TargetMon.UpdateFrame(bChecked, 2)
	end):Pos_()
	ui:Append("WndCheckBox", { txt = _L["Right aligment"], checked = HM_TargetMon.bTargetRight })
	:Pos(nX + 10, 122):Click(function(bChecked) HM_TargetMon.bTargetRight = bChecked end)
	ui:Append("WndCheckBox", { txt = _L["Monitor own important BUFF"], checked = HM_TargetMon.bSelfBuffEx })
	:Pos(10, 150):Click(function(bChecked)
		HM_TargetMon.bSelfBuffEx = bChecked
		_HM_TargetMon.UpdateFrame(bChecked, 3)
	end)
	ui:Append("WndCheckBox", { txt = _L["Right aligment"], checked = HM_TargetMon.bSelfRight })
	:Pos(nX + 10, 150):Click(function(bChecked) HM_TargetMon.bSelfRight = bChecked end)
	ui:Append("WndComboBox", { txt = _L["Set monitor buff"], x = 10, y = 178 }):Menu(_HM_TargetMon.GetBuffMenu)
	-- other
	ui:Append("Text", { txt = _L["Others"], font = 27, x = 0, y = 212 })
	nX = ui:Append("Text", { txt = _L["Adjust icon size of monitor buff/skill"], x = 10, y = 240 }):Pos_()
	ui:Append("WndComboBox", "Combo_Size", { x = nX + 5, y = 240, w = 60, h = 25 })
	:Text(tostring(HM_TargetMon.nSize)):Menu(function()
		local m0 = {}
		for i = 35, 80, 5 do
			table.insert(m0, { szOption = tostring(i), fnAction = function()
				HM_TargetMon.nSize = i
				HM.UI.Fetch(frame, "Combo_Size"):Text(tostring(i))
				_HM_TargetMon.AdjustSizeAll()
			end })
		end
		return m0
	end)
	ui:Append("WndCheckBox", { txt = _L["Show buff/skill tips when mouse enter the icon (affect to rotate lens)"], checked = HM_TargetMon.bBoxEvent2 })
	:Pos(10, 268):Click(function(bChecked)
		HM_TargetMon.bBoxEvent2 = bChecked
	end)
	-- tips
	ui:Append("Text", { txt = _L["Tips"], font = 27, x = 0, y = 304 })
	ui:Append("Text", { txt = _L["1. Press SHIFT-U to adjust the monitor position"], x = 10, y = 329 })
	ui:Append("Text", { txt = _L["2. As buff name often conflict, please tell me if you find wrong"], x = 10, y = 354 })
end

---------------------------------------------------------------------
-- ×¢²áÊÂ¼þ¡¢³õÊ¼»¯
---------------------------------------------------------------------
HM.RegisterEvent("PLAYER_ENTER_GAME", _HM_TargetMon.UpdateFrames)
HM.RegisterEvent("SYS_MSG", function()
	if arg0 == "UI_OME_SKILL_HIT_LOG" and arg3 == SKILL_EFFECT_TYPE.SKILL then
		_HM_TargetMon.OnSkillCast(arg1, arg4, arg5, arg0)
	elseif arg0 == "UI_OME_SKILL_EFFECT_LOG" and arg4 == SKILL_EFFECT_TYPE.SKILL then
		_HM_TargetMon.OnSkillCast(arg1, arg5, arg6, arg0)
	elseif (arg0 == "UI_OME_SKILL_BLOCK_LOG" or arg0 == "UI_OME_SKILL_SHIELD_LOG"
			or arg0 == "UI_OME_SKILL_MISS_LOG" or arg0 == "UI_OME_SKILL_DODGE_LOG")
		and arg3 == SKILL_EFFECT_TYPE.SKILL
	then
		_HM_TargetMon.OnSkillCast(arg1, arg4, arg5, arg0)
	end
end)
HM.RegisterEvent("DO_SKILL_CAST", function()
	_HM_TargetMon.OnSkillCast(arg0, arg1, arg2, "DO_SKILL_CAST")
end)

-- add to HM panel
HM.RegisterPanel(_L["Target BUFF/CD"], 332, _L["Target"], _HM_TargetMon.PS)

-- public api
HM_TargetMon.GetBuffExType = _HM_TargetMon.GetBuffExType
HM_TargetMon.GetBuffExList = _HM_TargetMon.GetBuffExList
HM_TargetMon.UpdateFrames = _HM_TargetMon.UpdateFrames
HM_TargetMon.GetLeftTime  = _HM_TargetMon.GetLeftTime
HM_TargetMon.GetPlayerCD = function(dwPlayer) return _HM_TargetMon.tCD[dwPlayer] or {} end
