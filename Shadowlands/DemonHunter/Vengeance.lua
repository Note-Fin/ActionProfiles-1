--#########################################
--##### TRIP'S VENGEANCE DEMON HUNTER #####
--#########################################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DEMONHUNTER_VENGEANCE] = {
    -- Racial
    ArcaneTorrent					= Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury						= Action.Create({ Type = "Spell", ID = 20572      }),
    Fireblood						= Action.Create({ Type = "Spell", ID = 265221     }),
    AncestralCall					= Action.Create({ Type = "Spell", ID = 274738     }),
    Berserking						= Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse						= Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm						= Action.Create({ Type = "Spell", ID = 107079     }),
    Haymaker						= Action.Create({ Type = "Spell", ID = 287712     }), 
    WarStomp						= Action.Create({ Type = "Spell", ID = 20549     }),
    BullRush						= Action.Create({ Type = "Spell", ID = 255654     }),  
    GiftofNaaru						= Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld						= Action.Create({ Type = "Spell", ID = 58984    }), -- Used for HoA
    Stoneform						= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks						= Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken				= Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist					= Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself				= Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it

	-- Demon Hunter General
    ConsumeMagic					= Action.Create({ Type = "Spell", ID = 278326	}),
    Disrupt							= Action.Create({ Type = "Spell", ID = 183752	}),
    DisruptGreen					= Action.Create({ Type = "SpellSingleColor", ID = 183752, Color = "GREEN", Desc = "[2] Kick", Hidden = true, QueueForbidden = true	}),	
    ImmolationAura					= Action.Create({ Type = "Spell", ID = 258920	}),
    Imprison						= Action.Create({ Type = "Spell", ID = 217832	}),
    Metamorphosis					= Action.Create({ Type = "Spell", ID = 191427	}),
    MetamorphosisBuff				= Action.Create({ Type = "Spell", ID = 162264	}),
	SpectralSight					= Action.Create({ Type = "Spell", ID = 188501	}),
    ThrowGlaive						= Action.Create({ Type = "Spell", ID = 185123 	}),
	Torment							= Action.Create({ Type = "Spell", ID = 185245	}),
	ChaosBrand						= Action.Create({ Type = "Spell", ID = 255260, Hidden = true	}),
	DemonicWards					= Action.Create({ Type = "Spell", ID = 278386, Hidden = true	}),
	ShatteredSouls					= Action.Create({ Type = "Spell", ID = 178940, Hidden = true	}),
	DemonSoul						= Action.Create({ Type = "Spell", ID = 163073, Hidden = true	}),
	
	-- Vengeance Specific
    DemonSpikes						= Action.Create({ Type = "Spell", ID = 344866	}),
	DemonSpikesBuff					= Action.Create({ Type = "Spell", ID = 203819	}),
	FieryBrand						= Action.Create({ Type = "Spell", ID = 344867	}),
	FieryBrandDebuff				= Action.Create({ Type = "Spell", ID = 207771, Hidden = true	}),
	InfernalStrike					= Action.Create({ Type = "Spell", ID = 344865	}),
	Shear							= Action.Create({ Type = "Spell", ID = 344859	}),
	SigilofFlame					= Action.Create({ Type = "Spell", ID = 204596	}),
	SigilofMisery					= Action.Create({ Type = "Spell", ID = 207684	}),
	SigilofSilence					= Action.Create({ Type = "Spell", ID = 202137	}),
	SoulCleave						= Action.Create({ Type = "Spell", ID = 344862	}),
	FelDevastation					= Action.Create({ Type = "Spell", ID = 212084	}),
	MasteryFelBlood					= Action.Create({ Type = "Spell", ID = 203747, Hidden = true	}),
	RevelinPain						= Action.Create({ Type = "Spell", ID = 343014, Hidden = true	}),	
	ThickSkin						= Action.Create({ Type = "Spell", ID = 320380, Hidden = true	}),
	SoulFragments					= Action.Create({ Type = "Spell", ID = 203981, Hidden = true	}),
	
	-- Normal Talents
    AbyssalStrike					= Action.Create({ Type = "Spell", ID = 207550, Hidden = true	}),
    AgonizingFlames					= Action.Create({ Type = "Spell", ID = 207548, Hidden = true	}),
    Felblade						= Action.Create({ Type = "Spell", ID = 232893	}),	
    FeastofSouls					= Action.Create({ Type = "Spell", ID = 207697, Hidden = true	}),	
    Fallout							= Action.Create({ Type = "Spell", ID = 227174, Hidden = true	}),	
    BurningAlive					= Action.Create({ Type = "Spell", ID = 207739, Hidden = true	}),	
    InfernalArmor					= Action.Create({ Type = "Spell", ID = 320331, Hidden = true	}),	
    CharredFlesh					= Action.Create({ Type = "Spell", ID = 336639, Hidden = true	}),	
    SpiritBomb						= Action.Create({ Type = "Spell", ID = 247454	}),
    SoulRending						= Action.Create({ Type = "Spell", ID = 217996, Hidden = true	}),	
    FeedtheDemon					= Action.Create({ Type = "Spell", ID = 218612, Hidden = true	}),
    Fracture						= Action.Create({ Type = "Spell", ID = 263642	}),
    ConcentratedSigils				= Action.Create({ Type = "Spell", ID = 207666, Hidden = true	}),
    QuickenedSigils					= Action.Create({ Type = "Spell", ID = 209281, Hidden = true	}),
    SigilofChains					= Action.Create({ Type = "Spell", ID = 202138	}),
    VoidReaver						= Action.Create({ Type = "Spell", ID = 268175, Hidden = true	}),	
    Demonic							= Action.Create({ Type = "Spell", ID = 321453, Hidden = true	}),
    SoulBarrier						= Action.Create({ Type = "Spell", ID = 263648	}),
    LastResort						= Action.Create({ Type = "Spell", ID = 209258, Hidden = true	}),
    RuinousBulwark					= Action.Create({ Type = "Spell", ID = 326853, Hidden = true	}),
	BulkExtraction					= Action.Create({ Type = "Spell", ID = 320341	}),	

	-- PvP Talents
    CleansedByFlame					= Action.Create({ Type = "Spell", ID = 205625, Hidden = true	}),
    EverlastingHunt					= Action.Create({ Type = "Spell", ID = 205656, Hidden = true	}),
    JaggedSpikes					= Action.Create({ Type = "Spell", ID = 205627, Hidden = true	}),
    IllidansGrasp					= Action.Create({ Type = "Spell", ID = 205630	}),	
    SigilMastery					= Action.Create({ Type = "Spell", ID = 211489, Hidden = true	}),
    Tormentor						= Action.Create({ Type = "Spell", ID = 207029	}),	
    DemonicTrample					= Action.Create({ Type = "Spell", ID = 205629	}),	
    ReverseMagic					= Action.Create({ Type = "Spell", ID = 205604	}),	
    Detainment						= Action.Create({ Type = "Spell", ID = 205596, Hidden = true	}),	

	-- Covenant Abilities
    ElysianDecree					= Action.Create({ Type = "Spell", ID = 306830	}),
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    SinfulBrand						= Action.Create({ Type = "Spell", ID = 317009	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    FoddertotheFlame				= Action.Create({ Type = "Spell", ID = 329554	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    TheHunt							= Action.Create({ Type = "Spell", ID = 323639	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits
    SoulFurnace						= Action.Create({ Type = "Spell", ID = 339423, Hidden = true	}),
    DemonMuzzle						= Action.Create({ Type = "Spell", ID = 339587, Hidden = true	}),	
    RoaringFire						= Action.Create({ Type = "Spell", ID = 339644, Hidden = true	}),		
    ExposedWound					= Action.Create({ Type = "Spell", ID = 339229, Hidden = true	}),	
    RepeatDecree					= Action.Create({ Type = "Spell", ID = 339895, Hidden = true	}),	
    IncreasedScrutiny				= Action.Create({ Type = "Spell", ID = 340028, Hidden = true	}),
    BroodingPool					= Action.Create({ Type = "Spell", ID = 340063, Hidden = true	}),	
    UnnaturalMalice					= Action.Create({ Type = "Spell", ID = 344358, Hidden = true	}),
    FelDefender						= Action.Create({ Type = "Spell", ID = 338671, Hidden = true	}),	
    ShatteredRestoration			= Action.Create({ Type = "Spell", ID = 338793, Hidden = true	}),
    ViscousInk						= Action.Create({ Type = "Spell", ID = 338682, Hidden = true	}),
    DemonicParole					= Action.Create({ Type = "Spell", ID = 339048, Hidden = true	}),
    FelfireHaste					= Action.Create({ Type = "Spell", ID = 338799, Hidden = true	}),
    LostinDarkness					= Action.Create({ Type = "Spell", ID = 339149, Hidden = true	}),
    RavenousConsumption				= Action.Create({ Type = "Spell", ID = 338835, Hidden = true	}),	
	
	-- Legendaries
	-- General Legendaries
    CollectiveAnguish				= Action.Create({ Type = "Spell", ID = 337504, Hidden = true	}),
    DarkestHour						= Action.Create({ Type = "Spell", ID = 337539, Hidden = true	}),	
    DarkglareBoon					= Action.Create({ Type = "Spell", ID = 337534, Hidden = true	}),
    FelBombardment					= Action.Create({ Type = "Spell", ID = 337775, Hidden = true	}),
	--Vengeance Legendaries
    FelFlameFortification			= Action.Create({ Type = "Spell", ID = 337545, Hidden = true	}),
    FierySoul						= Action.Create({ Type = "Spell", ID = 337547, Hidden = true	}),
    RazelikhsDefilement				= Action.Create({ Type = "Spell", ID = 337544, Hidden = true	}),	
    SpiritoftheDarknessFlame		= Action.Create({ Type = "Spell", ID = 337541, Hidden = true	}),		

	--Anima Powers - to add later...
	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury	= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralAgility			= Action.Create({ Type = "Potion", ID = 171270, QueueForbidden = true }),
    PotionofSpectralStamina			= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms		= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows			= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire				= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation			= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),  	

    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
}

-- To create essences use next code:
A:CreateEssencesFor(ACTION_CONST_DEMONHUNTER_VENGEANCE)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_DEMONHUNTER_VENGEANCE], { __index = Action })


local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
------------------------------------------
-------------- COMMON PREAPL -------------
------------------------------------------
local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    AuraTaunt                               = {A.Torment.ID},
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

--Register Toaster
Toaster:Register("TripToast", function(toast, ...)
	local title, message, spellID = ...
	toast:SetTitle(title or "nil")
	toast:SetText(message or "nil")
	if spellID then 
		if type(spellID) ~= "number" then 
			error(tostring(spellID) .. " (spellID) is not a number for TripToast!")
			toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
		else 
			toast:SetIconTexture((GetSpellTexture(spellID)))
		end 
	else 
		toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
	end 
	toast:SetUrgencyLevel("normal") 
end)

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Disrupt:IsReadyByPassCastGCD(unit) or not A.Disrupt:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)
    if A.GetToggle(2, "TasteInterruptList") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, "TasteBFAContent", true, countInterruptGCD(unit))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end
    local EnemiesCasting = MultiUnits:GetByRangeCasting(30, 5, true, "TargetMouseover")
    
    if castRemainsTime >= A.GetLatency() then    
        
        -- Sigil of Chains (Snare)
        if useCC and A.SigilofChains:IsReady("player") and A.SigilofChains:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):GetRange() > 5 then 
            return A.SigilofChains              
        end 
        
        -- Sigil of Misery (Disorient)
        if useCC and A.SigilofMisery:IsReady("player") and EnemiesCasting > 1 and A.SigilofMisery:AbsentImun(unit, Temp.TotalAndCC, true) then 
            return A.SigilofMisery              
        end 
        
        -- Sigil of Silence (Silence)
        if useKick and (not A.Disrupt:IsReady(unit) or EnemiesCasting > 1) and A.SigilofSilence:IsReady("player") and A.SigilofSilence:AbsentImun(unit, Temp.TotalAndCC, true) then 
            return A.SigilofSilence              
        end 
        
        -- Imprison    
        if useCC and A.Imprison:IsReady(unit) and not A.Disrupt:IsReady(unit) then        
            return A.Imprison              
        end 
        
        -- Disrupt
        if useKick and A.Disrupt:IsReady(unit) and A.Disrupt:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
            return A.Disrupt
        end     
        
        if useRacial and A.QuakingPalm:AutoRacial(unit) then 
            return A.QuakingPalm
        end 
        
        if useRacial and A.Haymaker:AutoRacial(unit) then 
            return A.Haymaker
        end 
        
        if useRacial and A.WarStomp:AutoRacial(unit) then 
            return A.WarStomp
        end 
        
        if useRacial and A.BullRush:AutoRacial(unit) then 
            return A.BullRush
        end 
    end
end

-- Soul Fragments function taking into consideration aura lag
local function UpdateSoulFragments()
    SoulFragments = Unit("player"):HasBuffsStacks(A.SoulFragments.ID, true)
    
    -- Casting Spirit Bomb or Soul Cleave immediately updates the buff
    if Unit("player"):GetSpellLastCast(A.SpiritBomb.ID, true) < A.GetGCD()
    or Unit("player"):GetSpellLastCast(A.SoulCleave.ID, true) < A.GetGCD() then
        SoulFragmentsAdjusted = 0
        return;
    end
    
    -- Check if we have cast Fracture or Shear within the last GCD and haven't "snapshot" yet
    if SoulFragmentsAdjusted == 0 then
        if A.Fracture:IsSpellLearned() then
            if Unit("player"):GetSpellLastCast(A.Fracture.ID, true) < A.GetGCD() and A.Fracture:GetSpellTimeSinceLastCast() ~= LastSoulFragmentAdjustment then
                SoulFragmentsAdjusted = math.min(SoulFragments + 2, 5)
                LastSoulFragmentAdjustment = A.Fracture:GetSpellTimeSinceLastCast()
            end
        else
            if A.Shear:GetSpellTimeSinceLastCast() < A.GetGCD() and A.Fracture.Shear ~= LastSoulFragmentAdjustment then
                SoulFragmentsAdjusted = math.min(SoulFragments + 1, 5)
                LastSoulFragmentAdjustment = A.Shear:GetSpellTimeSinceLastCast()
            end
        end
    else
        -- If we have a soul fragement "snapshot", see if we should invalidate it based on time
        if A.Fracture:IsSpellLearned() then
            if A.Fracture:GetSpellTimeSinceLastCast() >= A.GetGCD() then
                SoulFragmentsAdjusted = 0
            end
        else
            if A.Shear:GetSpellTimeSinceLastCast() >= A.GetGCD() then
                SoulFragmentsAdjusted = 0
            end
        end
    end
    
    -- If we have a higher Soul Fragment "snapshot", use it instead
    if SoulFragmentsAdjusted > SoulFragments then
        SoulFragments = SoulFragmentsAdjusted
    elseif SoulFragmentsAdjusted > 0 then
        -- Otherwise, the "snapshot" is invalid, so reset it if it has a value
        -- Relevant in cases where we use a generator two GCDs in a row
        SoulFragmentsAdjusted = 0
    end
end

-- Melee Is In Range w/ Movement Handlers
local function UpdateIsInMeleeRange()
    if A.Felblade:GetSpellTimeSinceLastCast() < A.GetGCD()
    or A.InfernalStrike:GetSpellTimeSinceLastCast() < A.GetGCD() then
        IsInMeleeRange = true;
        IsInAoERange = true;
        return;
    end
    
    local IsInMeleeRange = Unit("target"):GetRange() <= 5
    local IsInAoERange = IsInMeleeRange or MultiUnits:GetByRange(8, 5, 10) > 0;
end

-- Current HPS > Incoming damage
local function IsInDanger(unit)
    return Unit("player"):GetHPS() < Unit("player"):GetDMG()
end

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
    local ActiveMitigationNeeded = Player:ActiveMitigationNeeded()
    local IsTanking = Unit("player"):IsTanking("target", 8) or Unit("player"):IsTankingAoE(8)
    UpdateSoulFragments()
    UpdateIsInMeleeRange()
    local SoulFragments = Unit("player"):HasBuffsStacks(A.SoulFragments.ID, true)
	local PotionTrue = Action.GetToggle(1, "Potion")
	local MetaHP = Action.GetToggle(2, "MetamorphosisHP")
	local FelDevDMG = Action.GetToggle(2, "FelDevastationDMG")
	local FelDevHP = Action.GetToggle(2, "FelDevHP")
    
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
        -- vars
        -- Return boolean        
        local IsInDanger = IsInDanger(unit)
        local HPLosePerSecond = Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax()
        
		local function CovenantCall()
			
			--actions.cooldown+=/sinful_brand,if=!dot.sinful_brand.ticking
			if A.SinfulBrand:IsReady(unit) and Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0 and not Player:PrevGCD(1, A.Metamorphosis) then
				return A.SinfulBrand:Show(icon)
			end	
			
			--actions.cooldown+=/the_hunt
			if A.TheHunt:IsReady(unit) then
				return A.TheHunt:Show(icon)
			end	

			--Fleshcraft
			if A.Fleshcraft:IsReady(player) and Player:IsStayingTime() > 0.5 and Unit("player"):CombatTime() > 0 and (Unit("player"):IsExecuted() or (Unit("player"):HealthPercent() <= 40 and Unit("player"):TimeToDie() < 8)) then 
			A.Toaster:SpawnByTimer("TripToast", 0, "Fleshcraft!", "Using Fleshcraft defensively! Don't move!", A.Fleshcraft.ID)			
				return self.Fleshcraft:Show(icon)
			end 
			
			--actions.cooldown+=/fodder_to_the_flame
			if A.FoddertotheFlame:IsReady(unit) then
			A.Toaster:SpawnByTimer("TripToast", 0, "Fodder to the Flame!", "You've spawned a demon! Kill it!", A.FoddertotheFlame.ID)			
				return A.FoddertotheFlame:Show(icon)
			end	
			
			--actions.cooldown+=/elysian_decree
			if A.ElysianDecree:IsReady(player) and MultiUnits:GetByRange(5, 2) >= 2 and Unit(unit):TimeToDie() >= 5 then
				return A.ElysianDecree:Show(icon)
			end	

			--actions.cooldown+=/elysian_decree
			if A.ElysianDecree:IsReady(player) and Unit(unit):GetRange() <= 5 and Unit(unit):IsBoss() then
				return A.ElysianDecree:Show(icon)
			end					
		
		end

	
			--Damage Rotation
		local function DamageRotation()

			if A.Felblade:IsReady(unit) and Player:FuryDeficit() >= 40 then
				return A.Felblade:Show(icon)
			end	
		
			--Infernal Strike if about to cap charges, range check for casting @player
			if A.InfernalStrike:IsReady("player") and (A.LastPlayerCastID ~= A.InfernalStrike.ID) and A.InfernalStrike:GetSpellCharges() > 1 and Unit("target"):GetRange() <= 6 then 
				return A.InfernalStrike:Show(icon)
			end
			
			--Fiery Brand on cooldown
			if A.FieryBrand:IsReady(unit) then 
				return A.FieryBrand:Show(icon)
			end	
		
			--Spirit Bomb if four or more souls and fury cap incoming
			if A.SpiritBomb:IsReady(unit) and SoulFragments >= 4 and Player:Fury() then
				return A.SpiritBomb:Show(icon)
			end
			
			--Fel Devastation on cooldown
			if A.FelDevastation:IsReady("player") and Unit("target"):GetRange() <= 15 and FelDevDMG then
				return A.SpectralSight:Show(icon)
			end

			--Fracture if need fury/souls
			if A.Fracture:IsReady(unit) and SoulFragments <= 4 and Player:Fury() <= 75 then
				return A.Fracture:Show(icon)
			end	

			--Immolation Aura if souls not capped
			if A.ImmolationAura:IsReady(unit) and SoulFragments <= 4 and Player:Fury() <= 80 then
				return A.ImmolationAura:Show(icon)
			end

			--Soul Cleave to dump fury
			if A.SoulCleave:IsReady(unit) and Player:Fury() >= 80 then
				return A.SoulCleave:Show(icon)
			end

			--Sigil of Flame (try not to overlap with Sigil from Abyssal Strike talent)
			if A.SigilofFlame:IsReady("player") and not (A.AbyssalStrike:IsSpellLearned() and A.InfernalStrike:GetSpellTimeSinceLastCast() < 4) then
				return A.SigilofFlame:Show(icon)
			end

			--Shear
			if A.Shear:IsReady(unit) and not A.Fracture:IsSpellLearned() then
				return A.Shear:Show(icon)
			end

			--Throw Glaive
			if A.ThrowGlaive:IsReady(unit) and inCombat then
				return A.ThrowGlaive:Show(icon)
			end	
		
		end 
	
		local function DefenseRotation()
		
			if A.DemonSpikes:IsReady(unit) and Unit("player"):HasBuffs(A.DemonSpikesBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.Metamorphosis.ID, true) == 0 and (A.LastPlayerCastID ~= A.DemonSpikes.ID) then
				return A.DemonSpikes:Show(icon)
			end
			
			if A.SoulBarrier:IsReady(unit) and ((A.SpiritBomb:IsSpellLearned() and SoulFragments < 3) or (not A.SpiritBomb:IsSpellLearned() and SoulFragments >= 5)) then
				return A.SoulBarrier:Show(icon)
			end

			--Fel Devastation on cooldown
			if A.FelDevastation:IsReady("player") and Unit("target"):GetRange() <= 15 and Unit(player):HealthPercent() <= FelDevHP then
				return A.SpectralSight:Show(icon)
			end			
			
			if A.Metamorphosis:IsReady(unit) and A.BurstIsON(unit) and Unit("player"):HasBuffs(A.Metamorphosis.ID, true) == 0 and Unit(player):HealthPercent() <= MetaHP then
				return A.Metamorphosis:Show(icon)
			end	

            if A.PotionofHardenedShadows:IsReady(unit) and AutoPotionSelect == "HardenedShadowsPot" and PotionTrue and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0 and
			(
				IsInDanger 
				or                 
				-- HP lose per sec >= 40
				Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 40 
				or 
				Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.40 
				or 
				-- TTD 
				Unit("player"):TimeToDieX(15) < 3 
			)  			
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Ouch!", "Using Defensive Potion!", A.PotionofHardenedShadows.ID)  
                return A.PotionofHardenedShadows:Show(icon)
            end
			
            if A.PotionofSpectralStamina:IsReady(unit) and AutoPotionSelect == "SpectralStaminaPot" and PotionTrue and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0 and
			(
				IsInDanger 
				or                 
				-- HP lose per sec >= 40
				Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 40 
				or 
				Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.40 
				or 
				-- TTD 
				Unit("player"):TimeToDieX(15) < 3 
			)  			
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Ouch!", "Using Defensive Potion!", A.PotionofSpectralStamina.ID)  
                return A.PotionofSpectralStamina:Show(icon)
            end			
			
		end
			
			
		local function Utilities()
		
			-- Interrupt
			local Interrupt = Interrupts(unit)
			if Interrupt then 
				return Interrupt:Show(icon)
			end
			
			-- Purge
			-- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
			-- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
			if A.ConsumeMagic:IsReady(unit) and Action.AuraIsValid(unit, "UsePurge", "PurgeHigh") then
				return A.ConsumeMagic:Show(icon)
			end    
			
			-- Taunt 
			if A.GetToggle(2, "AutoTaunt") 
			and combatTime > 0     
			then 
				-- if not fully aggroed or we are not current target then use taunt
				if A.Torment:IsReady(unit, true, nil, nil, nil) and not Unit(unit):IsBoss() and not Unit(unit):IsDummy() and Unit(unit):GetRange() <= 30 and ( Unit("targettarget"):InfoGUID() ~= Unit("player"):InfoGUID() ) then 
					return A.Torment:Show(icon)
					-- else if all good on current target, switch to another one we know we dont currently tank
				else
					local Growl_Nameplates = MultiUnits:GetActiveUnitPlates()
					if Torment_Nameplates then  
						for Torment_UnitID in pairs(Torment_Nameplates) do             
							if not UnitIsUnit("target", Torment_UnitID) and A.Torment:IsReady(Torment_UnitID, true, nil, nil, nil) and not Unit(Torment_UnitID):IsDummy() and not Unit(Torment_UnitID):IsBoss() and Unit(Torment_UnitID):GetRange() <= 30 and not Unit(Torment_UnitID):InLOS() and Unit("player"):ThreatSituation(Torment_UnitID) ~= 3 then 
								return A:Show(icon, ACTION_CONST_AUTOTARGET)
							end         
						end 
					end
				end
			end 
			
			-- Non SIMC Custom Trinket1
			if A.Trinket1:IsReady(unit) and Trinket1IsAllowed then        
				return A.Trinket1:Show(icon)        
			end
			
			-- Non SIMC Custom Trinket2
			if A.Trinket2:IsReady(unit) and Trinket2IsAllowed then        
				return A.Trinket2:Show(icon)    
			end 
		
		end 
	
		if DefenseRotation(unit) and inCombat then
			return true
		end

		if Utilities(unit) and inCombat then
			return true
		end

		if CovenantCall(unit) and inCombat and A.GetToggle(1, "Covenant") and Unit("target"):TimeToDie() > 8 then
			return true
		end	
		
		if DamageRotation(unit) and inCombat then
			return true
		end		
			
	end 
    
    -- End on EnemyRotation()
    
    -- Defensive
    --local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unit = "mouseover"
        if EnemyRotation(unit) then 
            return true 
        end 
    end 
    
    -- Target  
    if A.IsUnitEnemy("target") then 
        unit = "target"
        if EnemyRotation(unit) then 
            return true
        end 
        
    end
end
-- Finished

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end
-- [5] Trinket Rotation
-- No specialization trinket actions 
-- Passive 
--[[local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", 3355) > UnitCooldown:GetMaxDuration("arena", 3355) - 2 and
    UnitCooldown:IsSpellInFly("arena", 3355) and 
    Unit("player"):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 
local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then 
            -- Reflect Casting BreakAble CC
            if A.NetherWard:IsReady() and A.NetherWard:IsSpellLearned() and Action.ShouldReflect(unit) and EnemyTeam():IsCastingBreakAble(0.25) then 
                return A.NetherWard:Show(icon)
            end 
        end
    end 
end 
local function PartyRotation(unit)
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

      -- SingeMagic
    if A.SingeMagic:IsCastable() and A.SingeMagic:AbsentImun(unit, Temp.TotalAndMag) and IsSchoolFree() and Action.AuraIsValid(unit, "UseDispel", "Magic") and not Unit(unit):InLOS() then
        return A.SingeMagic:Show(icon)
    end
end 

A[6] = function(icon)
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end 
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    return ArenaRotation(icon, "arena3")
end]]--

