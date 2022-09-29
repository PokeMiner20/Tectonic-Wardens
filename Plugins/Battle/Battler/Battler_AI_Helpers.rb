class PokeBattle_Battler
	def hasPhysicalAttack?
		eachMove do |m|
			next if !m.physicalMove?(m.type)
			return true
			break
		end
		return false
	end

	def hasSpecialAttack?
		eachMove do |m|
			next if !m.specialMove?(m.type)
			return true
			break
		end
		return false
	end

	def hasDamagingAttack?
		eachMove do |m|
			next if !m.damagingMove?
			return true
			break
		end
		return false
	end

	def hasAlly?
		eachAlly do |b|
			return true
			break
		end
		return false
	end

     # A helper method that diverts to an AI-based check or a true calculation check as appropriate
     def shouldAbilityApply?(check_ability, checkingForAI)
		if checkingForAI
            return hasActiveAbilityAI?(check_ability)
        else
            return hasActiveAbility?(check_ability)
        end
	end

    # An ability check method that is fooled by Illusion
    # May in the future be extended to having the AI be ignorant about the player's abilities until they are revealed
	def hasActiveAbilityAI?(check_ability, ignore_fainted = false)
		return false if @effects[PBEffects::Illusion] && pbOwnedByPlayer?
		return hasActiveAbility?(check_ability, ignore_fainted)
	end

	# Returns the active types of this Pokémon. The array should not include the
	# same type more than once, and should not include any invalid type numbers (e.g. -1).
	# is fooled by Illusion
	def pbTypesAI(withType3=false)
		if @effects[PBEffects::Illusion] && pbOwnedByPlayer?
			ret = [@effects[PBEffects::Illusion].type1]
			ret.push(@effects[PBEffects::Illusion].type2) if @effects[PBEffects::Illusion].type2 != @effects[PBEffects::Illusion].type1
		else
			ret = [@type1]
			ret.push(@type2) if @type2!=@type1
		end
		# Burn Up erases the Fire-type.
		ret.delete(:FIRE) if @effects[PBEffects::BurnUp]
		# Roost erases the Flying-type. If there are no types left, adds the Normal-
		# type.
		if @effects[PBEffects::Roost]
			ret.delete(:FLYING)
			ret.push(:NORMAL) if ret.length == 0
		end
		# Add the third type specially.
		if withType3 && @effects[PBEffects::Type3]
			ret.push(@effects[PBEffects::Type3]) if !ret.include?(@effects[PBEffects::Type3])
		end
		return ret
	end

	def shouldTypeApply?(type,checkingForAI)
		if checkingForAI
			return pbHasTypeAI?(type)
		else
			return pbHasType?(type)
		end
	end

	def pbHasTypeAI?(type)
		return false if !type
		activeTypes = pbTypesAI(true)
		return activeTypes.include?(GameData::Type.get(type).id)
	end

	def ownersPolicies
		return [] if pbOwnedByPlayer?
		return @battle.pbGetOwnerFromBattlerIndex(@index).policies
	end
end