extends VBoxContainer

signal reward_accepted

var reward = null

func assign_reward(_reward):
	reward = _reward
	$Title.text = _reward.title
	$Description.text = _reward.description
	$CenterContainer/Panel/Icon.texture = _reward.icon

func _on_Accept_pressed():
	match reward.title.to_upper():
		"HEAL":
			var current_player_health = State.get_value("current_player_health")
			var max_player_health = State.get_value("max_player_health")
			var updated_health = min(max_player_health, current_player_health + 20)
			State.set_value("current_player_health", updated_health)
			emit_signal("reward_accepted")
		"INSTANT":
			var abilities = State.get_value("abilities")
			abilities.push_back(load("res://src/resources/abilities/Instant.tres"))
			State.set_value("abilities", abilities)
			emit_signal("reward_accepted")
		"BUMP+":
			var abilities = State.get_value("abilities")
			for i in range(0, len(abilities)):
				if "BUMP" in abilities[i].name.to_upper():
					abilities.remove(i)
					abilities.insert(i, load("res://src/resources/abilities/BumpPlus.tres"))
			State.set_value("abilities", abilities)
			emit_signal("reward_accepted")
		"CRIT +15%":
			Globals.CRIT_BONUS = min(100, Globals.CRIT_BONUS + 15)
			emit_signal("reward_accepted")
		"SPED +10%":
			Globals.SPEED_BONUS = min(100, Globals.SPEED_BONUS + 10)
			emit_signal("reward_accepted")
		"SHUFFLE":
			var abilities = State.get_value("abilities")
			abilities.push_back(load("res://src/resources/abilities/Shuffle.tres"))
			State.set_value("abilities", abilities)
			emit_signal("reward_accepted")
		"FIRE DICE":
			var dice_deck = State.get_value("dice_deck").duplicate(true)
			dice_deck.push_back(load("res://src/resources/dice/FireDice.tres"))
			State.set_value("dice_deck", dice_deck)
			emit_signal("reward_accepted")
		"HEAL DICE":
			var dice_deck = State.get_value("dice_deck").duplicate(true)
			dice_deck.push_back(load("res://src/resources/dice/HealDice.tres"))
			State.set_value("dice_deck", dice_deck)
			emit_signal("reward_accepted")
