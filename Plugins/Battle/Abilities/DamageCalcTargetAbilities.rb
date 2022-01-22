BattleHandlers::DamageCalcTargetAbility.add(:SHIELDWALL,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if Effectiveness.hyper_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 0.5
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:HEADSTRONG,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if user.battle.field.terrain == :Psychic
      mults[:defense_multiplier] *= 1.5
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:STOUT,
  proc { |ability,user,target,move,mults,baseDmg,type|
    w = user.battle.pbWeather
    mults[:final_damage_multiplier] *= 0.80 if w!=:None
  }
)


BattleHandlers::DamageCalcTargetAbility.add(:SENTRY,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:final_damage_multiplier] *= 0.75 if target.effects[PBEffects::Sentry] == true
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:DESERTARMOR,
  proc { |ability,user,target,move,mults,baseDmg,type|
    w = user.battle.pbWeather
    if w==:Sandstorm && move.physicalMove?
      mults[:defense_multiplier] *= 2
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:REALIST,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if type == :DRAGON || type == :FAIRY
      mults[:base_damage_multiplier] /= 2
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:TOUGH,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if type == :FIGHTING || type == :ROCK
      mults[:base_damage_multiplier] /= 2
    end
  }
)


BattleHandlers::DamageCalcTargetAbility.add(:TRAPPER,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if user.battle.pbIsTrapped?(user.index)
      mults[:final_damage_multiplier] *= 0.75
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:PARANOID,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:final_damage_multiplier] *= 2 if move.calcType == :PSYCHIC
    mults[:final_damage_multiplier] /= 2 if move.specialMove?
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:FORTIFIED,
  proc { |ability,user,target,move,mults,baseDmg,type|
	if !user.movedThisRound?
		mults[:final_damage_multiplier] *= 0.80
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:SANDSHROUD,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:final_damage_multiplier] *= 0.75 if user.battle.pbWeather==:Sandstorm
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:SNOWSHROUD,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:final_damage_multiplier] *= 0.75 if user.battle.pbWeather==:Hail
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:BROODING,
  proc { |ability,user,target,move,mults,baseDmg,type|
	dragonCount = 0
	user.battle.eachInTeamFromBattlerIndex(target.index) do |pkmn,i|
		dragonCount += 1 if pkmn.pbHasType?(:DRAGON)
	end
	mults[:final_damage_multiplier] /= (1.0 + dragonCount * 0.05) 
  }
)