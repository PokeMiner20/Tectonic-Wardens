#===============================================================================
# For 4 rounds, doubles the Speed of all battlers on the user's side. (Tailwind)
#===============================================================================
class PokeBattle_Move_StartUserSideDoubleSpeed4 < PokeBattle_Move
    def initialize(battle, move)
        super
        @tailwindDuration = 4
    end

    def pbEffectGeneral(user)
        user.pbOwnSide.applyEffect(:Tailwind, @tailwindDuration)
    end

    def getEffectScore(user, _target)
        return getTailwindEffectScore(user, @tailwindDuration, self)
    end
end

# Empowered Tailwind
class PokeBattle_Move_EmpoweredTailwind < PokeBattle_Move_StartUserSideDoubleSpeed4
    include EmpoweredMove

    def pbEffectGeneral(user)
        user.pbOwnSide.applyEffect(:Tailwind, 4)
        @battle.eachSameSideBattler(user) do |b|
            b.applyEffect(:ExtraTurns, 1)
        end
        transformType(user, :FLYING)
    end
end

#===============================================================================
# For 6 rounds, doubles the Speed of all battlers on the user's side. (Sustained Wind)
#===============================================================================
class PokeBattle_Move_StartUserSideDoubleSpeed6 < PokeBattle_Move_StartUserSideDoubleSpeed4
    def initialize(battle, move)
        super
        @tailwindDuration = 6
    end
end

#===============================================================================
# For 5 rounds, increases gravity on the field. Pokémon cannot become airborne.
# (Gravity)
#===============================================================================
class PokeBattle_Move_118 < PokeBattle_Move
    def initialize(battle, move)
        super
        @gravityDuration = 5
    end

    def pbEffectGeneral(_user)
        @battle.field.applyEffect(:Gravity, @gravityDuration)
    end

    def getEffectScore(user, _target)
        return getGravityEffectScore(user, @gravityDuration)
    end
end

#===============================================================================
# Heals every active battler by 1/8th of their HP for the next 5 turns. (Floral Gramarye)
#===============================================================================
class PokeBattle_Move_StartAllBattlersHealEightOfMaxHPEachTurn5 < PokeBattle_Move
    def pbEffectGeneral(_user)
        @battle.field.applyEffect(:FloralGramarye, 5) unless @battle.field.effectActive?(:FloralGramarye)
    end

    def pbMoveFailed?(_user, _targets, show_message)
        return false if damagingMove?
        if @battle.field.effectActive?(:FloralGramarye)
            if show_message
                @battle.pbDisplay(_INTL("But it failed, since the field is already covered in flowers!"))
            end
            return true
        end
        return false
    end

    def getEffectScore(user, _target)
        return 100
    end
end



#===============================================================================
# Resets all stat steps at end of turn and at the end of the next four turns. (Grey Mist)
#===============================================================================
class PokeBattle_Move_StartResetAllBattlersStatStepsEachRound5 < PokeBattle_Move
    def pbEffectGeneral(_user)
        @battle.field.applyEffect(:GreyMist, 5) unless @battle.field.effectActive?(:GreyMist)
    end

    def pbMoveFailed?(_user, _targets, show_message)
        return false if damagingMove?
        if @battle.field.effectActive?(:GreyMist)
            if show_message
                @battle.pbDisplay(_INTL("But it failed, since the field is already shrouded in Grey Mist!"))
            end
            return true
        end
        return false
    end

    def getEffectScore(user, _target)
        return getGreyMistSettingEffectScore(user,5)
    end
end

# Empowered Grey Mist
class PokeBattle_Move_EmpoweredGreyMist < PokeBattle_Move_StartResetAllBattlersStatStepsEachRound5
    include EmpoweredMove

    def pbEffectGeneral(user)
        super

        itemName = GameData::Item.get(:BLACKSLUDGE).name
        @battle.pbDisplay(_INTL("{1} crafts itself a {2}!", user.pbThis, itemName))
        user.giveItem(:BLACKSLUDGE)

        transformType(user, :POISON)
    end
end