Config = scriptConfig("Blitzcrank", "Blitzcrank:")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
KSConfig = scriptConfig("KS", "Killsteal:")
KSConfig.addParam("KSQ", "Killsteal with Q", SCRIPT_PARAM_ONOFF, false)
KSConfig.addParam("KSR", "Killsteal with R", SCRIPT_PARAM_ONOFF, false)
HarassConfig = scriptConfig("Harass", "Harass:")
HarassConfig.addParam("HarassQ", "Harass Q (C)", SCRIPT_PARAM_ONOFF, true)
HarassConfig.addParam("HarassE", "Harass E (C)", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig = scriptConfig("Drawings", "Drawings:")
DrawingsConfig.addParam("DrawQ","Draw Q", SCRIPT_PARAM_ONOFF, true)
DrawingsConfig.addParam("DrawR","Draw R", SCRIPT_PARAM_ONOFF, true)
-- this is the menu you can change Config. to what you want :'), true mean ON by Default, false mean Off

-- load IAC without plugins
myIAC = IAC()

-- this gets executed every frame
OnLoop(function(myHero)
-- this is the Drawings Function at line 77
Drawings()
-- this is the Killsteal Function at line 88
Killsteal()
        -- if we dont press spacebar we do nothing
        if IWalkConfig.Combo then
              -- grab best target in 1000 range
	      local target = GetTarget(1000, DAMAGE_MAGIC)
	        -- if the target is valid and (still) in 1000 range
	        if ValidTarget(target, 1000) then
	              	
	              	-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
		        local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),1800,250,GetCastRange(myHero,_Q),70,true,true)
		        -- if Q is ready and Hitchance = 1 and target is still valid at Q range and Use Q is on in menu then
                        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target, GetCastRange(myHero,_Q)) and Config.Q then
                        -- CastSkillShot at the predicted Pos : QPred
                        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	                end
                          
                        if CanUseSpell(myHero, _W) == READY and not IsInDistance(target, 150) and IsInDistance(target, 700) and Config.W then
                        CastSpell(_W)
		        end
			
                        if CanUseSpell(myHero, _E) == READY and ValidTarget(target, 250) and IsInDistance(target, 250) and Config.E then
                        CastSpell(_E)
		        end
		              
		        if CanUseSpell(myHero, _R) == READY and ValidTarget(target, GetCastRange(myHero,_R)) and IsInDistance(target, 550) and Config.R then
                        CastSpell(_R)
	                end
	                      
                end
	end	
	-- if we dont press C we do nothing
	if IWalkConfig.Harass then
	     local target = GetTarget(1000, DAMAGE_MAGIC)
		              
		if ValidTarget(target, 1000) then
		
		        if (GetCurrentMana(myHero)/GetMaxMana(myHero)) > 0.4 then
			        local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),1800,250,GetCastRange(myHero,_Q),70,true,true)
                                if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(target,GetCastRange(myHero,_Q)) and HarassConfig.HarassQ then 
                                CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				elseif CanUseSpell(myHero, _E) == READY and ValidTarget(target, 250) and IsInDistance(target, 250) and HarassConfig.HarassE then
				CastSpell(_E)
				end
                        end
		end
	end
end)

OnLoop(function(myHero)

	
end)

function Killsteal()
        for i,enemy in pairs(GetEnemyHeroes()) do
	    local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),1800,250,GetCastRange(myHero,_Q),70,true,true)
  	    if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(enemy,GetCastRange(myHero,_Q)) and KSConfig.KSQ and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (55*GetCastLevel(myHero,_Q)+25+GetBonusAP(myHero))) then 
            CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
            elseif CanUseSpell(myHero, _R) == READY and ValidTarget(enemy,GetCastRange(myHero,_R)) and KSConfig.KSR and GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, (125*GetCastLevel(myHero,_R)+125+GetBonusAP(myHero))) then
            CastSpell(_R)
	    end
	end
end

function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and DrawingsConfig.DrawQ then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),3,100,0xff00ff00) end
if CanUseSpell(myHero, _R) == READY and DrawingsConfig.DrawR then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),3,100,0xff00ff00) end
end
