BattleHandlers::DamageCalcTargetItem.add(:BABIRIBERRY,
    proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
        pbBattleTypeWeakingBerry(item, :STEEL, type, target, mults, false, aiChecking)
    }
)

BattleHandlers::DamageCalcTargetItem.add(:CHARTIBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :ROCK, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:CHILANBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :NORMAL, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:CHOPLEBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :FIGHTING, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:COBABERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :FLYING, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:COLBURBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :DARK, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:HABANBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :DRAGON, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:KASIBBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :GHOST, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:KEBIABERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :POISON, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:OCCABERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :FIRE, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:PASSHOBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :WATER, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:PAYAPABERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :PSYCHIC, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:RINDOBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :GRASS, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:ROSELIBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :FAIRY, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:SHUCABERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :GROUND, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:TANGABERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :BUG, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:WACANBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :ELECTRIC, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:YACHEBERRY,
  proc { |item, _user, target, _move, mults, _baseDmg, type, aiChecking|
      pbBattleTypeWeakingBerry(item, :ICE, type, target, mults, false, aiChecking)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:EVIOLITE,
  proc { |item, _user, target, _move, mults, _baseDmg, _type|
      # NOTE: Eviolite cares about whether the Pokémon itself can evolve, which
      #       means it also cares about the Pokémon's form. Some forms cannot
      #       evolve even if the species generally can, and such forms are not
      #       affected by Eviolite.
      mults[:defense_multiplier] *= 1.5 unless target.pokemon.species_data.get_evolutions(true).empty?
  }
)