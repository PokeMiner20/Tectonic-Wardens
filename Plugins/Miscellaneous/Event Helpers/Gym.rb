BADGE_COUNT_VARIABLE = 27
SURFBOARD_PHONECALL_GLOBAL = 61
CATACOMBS_PHONECALL_GLOBAL = 62

def earnBadge(badgeNum)
	badgeNames = [
		"Loyalty",
		"Perseverance",
		"Patience",
		"Reverence",
		"Solidarity",
		"Clarity",
		"Generosity",
		"Mercy"
	]
	name = badgeNames[badgeNum-1]
	pbMessage(_INTL("\\me[Badge get]You've earned the {1} Badge.",name))
	$Trainer.badges[badgeNum-1]=true
	$game_switches[3+badgeNum]=true # "Defeated Gym X" switch
	pbWait(120)
	
	# Increase the level cap
	totalBadges = 0
	$Trainer.badges.each do |hasBadge|
		totalBadges += 1 if hasBadge
	end
	levelCapsPerBadgeCount = [15,20,25,30,40,45,50,60,70]
	pbSetLevelCap(levelCapsPerBadgeCount[totalBadges])
	
	# 
	$game_variables[BADGE_COUNT_VARIABLE] = totalBadges
	
	if totalBadges == 4
		$PokemonGlobal.shouldProcSurfboardCall = true
	elsif totalBadges == 6
		$PokemonGlobal.shouldProcCatacombsCall = true
	end
	
	refreshMapEvents()
end

class PokemonGlobalMetadata
	attr_accessor :shouldProcSurfboardCall
	attr_accessor :shouldProcCatacombsCall
end

Events.onMapChange += proc { |_sender, e|
	if playerIsOutdoors?()
		if $PokemonGlobal.shouldProcSurfboardCall
			$game_switches[SURFBOARD_PHONECALL_GLOBAL] = true
			$PokemonGlobal.shouldProcSurfboardCall = false
		end
		if $PokemonGlobal.shouldProcCatacombsCall
			$game_switches[CATACOMBS_PHONECALL_GLOBAL] = true
			$PokemonGlobal.shouldProcCatacombsCall = false
		end
	end
}

def showGymChoices(notSureLabel="NotSure",basicTeamLabel="BasicTeam",fullTeamLabel="FullTeam",amuletMatters = true)
	cmdNotSure = -1
	cmdBasicTeam = -1
	cmdFullTeam = -1
	commands = []
	commands[cmdNotSure = commands.length]  = _INTL("I'm not sure")
	commands[cmdBasicTeam = commands.length]  = _INTL("Basic Team")
	commands[cmdFullTeam = commands.length]  = (amuletMatters && $PokemonGlobal.tarot_amulet_active) ? _INTL("Full Team (Cursed)") : _INTL("Full Team")
	cmd = pbShowCommands(nil,commands)
	if cmdNotSure > -1 && cmd == cmdNotSure
		goToLabel(notSureLabel)
	elsif cmdBasicTeam > -1 && cmd == cmdBasicTeam
		goToLabel(basicTeamLabel)
	elsif cmdFullTeam > -1 && cmd == cmdFullTeam
		goToLabel(fullTeamLabel)
	end
end

def showGymChoicesDoubles(notSureLabel="NotSure",basicTeamLabel="BasicTeam",fullTeamLabel="FullTeam",amuletMatters = true)
	cmdNotSure = -1
	cmdBasicTeam = -1
	cmdFullTeam = -1
	commands = []
	commands[cmdNotSure = commands.length]  = _INTL("I'm not sure")
	commands[cmdBasicTeam = commands.length]  = _INTL("Basic Doubles Team")
	commands[cmdFullTeam = commands.length]  = (amuletMatters && $PokemonGlobal.tarot_amulet_active) ? _INTL("Full Doubles Team (Cursed)") : _INTL("Full Doubles Team")
	cmd = pbShowCommands(nil,commands)
	if cmdNotSure > -1 && cmd == cmdNotSure
		goToLabel(notSureLabel)
	elsif cmdBasicTeam > -1 && cmd == cmdBasicTeam
		goToLabel(basicTeamLabel)
	elsif cmdFullTeam > -1 && cmd == cmdFullTeam
		goToLabel(fullTeamLabel)
	end
end

def showGymChoicesBenceZoe(notSureLabel="NotSure",basicTeamLabel="BasicTeam",doublesTeamLabel="DoublesTeam",amuletMatters = true)
	cmdNotSure = -1
	cmdBasicTeam = -1
	cmdDoublesTeam = -1
	commands = []
	commands[cmdNotSure = commands.length]  = _INTL("I'm not sure")
	commands[cmdBasicTeam = commands.length]  = (amuletMatters && $PokemonGlobal.tarot_amulet_active) ? _INTL("Your Full Team (CURSED)") : _INTL("Just You")
	commands[cmdDoublesTeam = commands.length]  = _INTL("Both of you (Advanced)")
	cmd = pbShowCommands(nil,commands)
	if cmdNotSure > -1 && cmd == cmdNotSure
		goToLabel(notSureLabel)
	elsif cmdBasicTeam > -1 && cmd == cmdBasicTeam
		goToLabel(basicTeamLabel)
	elsif cmdDoublesTeam > -1 && cmd == cmdDoublesTeam
		goToLabel(doublesTeamLabel)
	end
end

def receivedGymRewardYet?(index)
	if $game_variables[78] == 0
		$game_variables[78] = [false] * 8
	end
	
	return $game_variables[78][index]
end

def receiveGymReward(badgeNum)
	index = badgeNum-1
	case index
	when 0,1
		pbReceiveItem(:FULLRESTORE)
		pbReceiveItem(:MAXREPEL)
		pbReceiveItem(:ULTRABALL)
		pbReceiveItem(:MAXREVIVE)
	else
		echo("Gym item #{index} not yet defined!\n")
	end
	
	$game_variables[78][index] = true # Mark the item as having been received
end

def healAndGiveRewardIfNotYetGiven(badgeNum)
	index = badgeNum-1
	leaderDialogue =
		["I'll heal up your Pokémon and get out of your way.",
		"Let me tend to your Pokémon while you bask in your victory."][index] || ""
	pbMessage(leaderDialogue) if !leaderDialogue.blank?
	healPartyWithDelay()
end

def hasFirstFourBadges?()
	return $game_switches[4] && $game_switches[5] && $game_switches[6] && $game_switches[7]
end

def endGymChoice()
	pbTrainerEnd
	command_end
end