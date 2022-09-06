class PokeBattle_Battle
  # Used for causing weather by a move or by an ability.
  def pbStartWeather(user,newWeather,duration=-1,showAnim=true)
    resetExisting = @field.weather == newWeather
    endWeather() if !resetExisting

    # Set the new weather and duration
    @field.weather = newWeather
    if duration>0 && user && user.itemActive?
      duration = BattleHandlers.triggerWeatherExtenderItem(user.item,
        @field.weather,duration,user,self)
    end

    # If we're resetting an existing weather, don't set the duration to lower than it was before
    if resetExisting
      if duration > @field.weatherDuration
        @field.weatherDuration = duration
      end
    else
      @field.weatherDuration = duration
    end

    # Show animation, if desired
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if showAnim && weather_data   

    if resetExisting
      displayResetWeatherMessage()
    else
      displayFreshWeatherMessage()
      # Check for end of primordial weather, and weather-triggered form changes
      eachBattler { |b| b.pbCheckFormOnWeatherChange }
      pbEndPrimordialWeather
    end
    pbDisplay(_INTL("It'll last for {1} more turns!",@field.weatherDuration - 1))
    pbHideAbilitySplash(user) if user
  end

  def displayResetWeatherMessage()
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The harsh sunlight continues!"))
    when :Rain        then pbDisplay(_INTL("The rain shows no sign of stopping!"))
    when :Sandstorm   then pbDisplay(_INTL("The sandstorm returns to full strength!"))
    when :Hail        then pbDisplay(_INTL("The hail keeps coming!"))
    when :ShadowSky   then pbDisplay(_INTL("The darkened sky darkens even further!"))
    when :AcidRain    then pbDisplay(_INTL("The acid rain won't quit!"))
    when :Swarm       then pbDisplay(_INTL("The bugs insatiable, and keep swarming!"))
    end
  end
  
  def displayFreshWeatherMessage()
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The sunlight turned harsh!"))
    when :Rain        then pbDisplay(_INTL("It started to rain!"))
    when :Sandstorm   then pbDisplay(_INTL("A sandstorm brewed!"))
    when :Hail        then pbDisplay(_INTL("It started to hail!"))
    when :HarshSun    then pbDisplay(_INTL("The sunlight turned extremely harsh!"))
    when :HeavyRain   then pbDisplay(_INTL("A heavy rain began to fall!"))
    when :StrongWinds then pbDisplay(_INTL("Mysterious strong winds are protecting Flying-type Pokémon!"))
    when :ShadowSky   then pbDisplay(_INTL("A shadow sky appeared!"))
    when :AcidRain    then pbDisplay(_INTL("Acidic rain began to fall!"))
    when :Swarm       then pbDisplay(_INTL("A swarm of bugs gathers!"))
    end
  end

  def endWeather()
    return if @field.weather == :None
    case @field.weather
      when :Sun         then pbDisplay(_INTL("The sunlight faded."))
      when :Rain        then pbDisplay(_INTL("The rain stopped."))
      when :Sandstorm   then pbDisplay(_INTL("The sandstorm subsided."))
      when :Hail        then pbDisplay(_INTL("The hail stopped."))
      when :ShadowSky   then pbDisplay(_INTL("The shadow sky faded."))
      when :AcidRain    then pbDisplay(_INTL("The acid rain stopped."))
      when :Swarm       then pbDisplay(_INTL("The swarm dissipates."))
      when :HeavyRain   then pbDisplay(_INTL("The heavy rain has lifted!"))
      when :HarshSun    then pbDisplay(_INTL("The harsh sunlight faded!"))
      when :StrongWinds then pbDisplay(_INTL("The mysterious air current has dissipated!"))
    end
    @field.weather 			= :None
    @field.weatherDuration  = 0
  end

  def pbStartTerrain(user,newTerrain,fixedDuration=true)
    if @field.terrain == newTerrain
      pbHideAbilitySplash(user) if user
      return
    end
    old_terrain = @field.terrain
    @field.terrain = newTerrain
    duration = (fixedDuration) ? 5 : -1
    if duration>0 && user && user.itemActive?
      duration = BattleHandlers.triggerTerrainExtenderItem(user.item,newTerrain,duration,user,self)
    end
    @field.terrainDuration = duration
    terrain_data = GameData::BattleTerrain.try_get(@field.terrain)
    pbCommonAnimation(terrain_data.animation) if terrain_data
    case @field.terrain
    when :Electric
      pbDisplay(_INTL("An electric current runs across the battlefield!"))
      pbDisplay(_INTL("Pokemon cannot fall asleep, be flustered or be mystified!"))
    when :Grassy
      pbDisplay(_INTL("Grass grew to cover the battlefield!"))
      pbDisplay(_INTL("All Pokemon are healed each turn!"))
    when :Misty
      pbDisplay(_INTL("Fae mist swirled about the battlefield!"))
      pbDisplay(_INTL("Pokemon cannot be burned or poisoned!"))
    when :Psychic
      pbDisplay(_INTL("The battlefield got weird!"))
      pbDisplay(_INTL("Priority moves are prevented!"))
    end
    pbHideAbilitySplash(user) if user
    # Check for terrain seeds that boost stats in a terrain
    eachBattler { |b| b.pbItemTerrainStatBoostCheck }
    
    # Trigger dialogue for each opponent
    if @opponent
      @opponent.each_with_index do |trainer_speaking,idxTrainer|
        @scene.showTrainerDialogue(idxTrainer) { |policy,dialogue|
          PokeBattle_AI.triggerTerrainChangeDialogue(policy,old_terrain,newTerrain,trainer_speaking,dialogue)
        }
      end
    end
  end 
  
  def pbChangeField(user,fieldEffect,modifier)
	  return
	  @field.effects[PBEffects:fieldEffect] = modifier
  end
end

GameData::BattleWeather.register({
  :id        => :AcidRain,
  :name      => _INTL("Acid Rain"),
  :animation => "ShadowSky"
})

GameData::BattleWeather.register({
  :id        => :Swarm,
  :name      => _INTL("Swarm"),
  :animation => "StrongWinds"
})

class PokeBattle_Battler
    def takesAcidRainDamage?
        return false if !takesIndirectDamage?
        return false if pbHasType?(:POISON) || pbHasType?(:DARK)
        return false if inTwoTurnAttack?("0CA","0CB")   # Dig, Dive
        return false if hasActiveAbility?([:OVERCOAT])
        return false if hasActiveItem?(:SAFETYGOGGLES)
        return true
      end
end