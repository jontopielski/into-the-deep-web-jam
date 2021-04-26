extends Node

func set_next_enemy():
	match Globals.ENCOUNTER_COUNT:
		1:
			set_current_enemy(load("res://src/resources/enemies/Whistler.tres"))
		2:
			set_current_enemy(load("res://src/resources/enemies/Blogman.tres"))
		3:
			set_current_enemy(load("res://src/resources/enemies/Pillman.tres"))
		4:
			set_current_enemy(load("res://src/resources/enemies/RackMan.tres"))
		5:
			set_current_enemy(load("res://src/resources/enemies/ScienceMan.tres"))
		_:
			set_current_enemy(load("res://src/resources/enemies/Whistler.tres"))

func set_current_enemy(enemy_resource):
	State.set_value("current_enemy", enemy_resource)
	State.set_value("current_enemy_health", enemy_resource.health)

func reset_player_battle_state():
	State.set_value("dice_discard_pile", [])
	var current_dice_deck = State.get_value("dice_deck").duplicate(true)
	randomize()
	current_dice_deck = DiceManager.get_new_dice_values(current_dice_deck)
	current_dice_deck.shuffle()
	State.set_value("dice_draw_pile", current_dice_deck)

func play_enemy_defeated_text():
	var current_enemy = State.get_value("current_enemy")
	var enemy_name = current_enemy.name
	match enemy_name.to_upper():
		"WHISTLER":
			TextBox.set_speaker("WHISTLER")
			TextBox.push_text("Ouch.")
			TextBox.push_text("I'm late for my improv class anyway.")
		"BLOG MAN":
			TextBox.set_speaker("BLOG MAN")
			TextBox.push_text("Well.")
			TextBox.push_text("I'm gonna go blog about this experience.")
		"PILL MAN":
			TextBox.set_speaker("PILL MAN")
			TextBox.push_text("Yikes.")
			TextBox.push_text("I need to go take some pills.")
		"RACK MAN":
			TextBox.set_speaker("RACK MAN")
			TextBox.push_text("Beep boop.")
			TextBox.push_text("This is a waste of energy.")
		"SCIENCE MAN":
			TextBox.set_speaker("SCIENCE MAN")
			TextBox.push_text("Well.")
			TextBox.push_text("Guess I'd better start studying again.")

func has_ability(ability_name):
	for ability in State.get_value("abilities"):
		if ability_name.to_upper() in ability.name.to_upper():
			return true
	return false

func has_fire_dice():
	for dice in State.get_value("dice_deck"):
		if dice.effect == Enums.DiceEffects.FIRE:
			return true
	return false

func has_heal_dice():
	for dice in State.get_value("dice_deck"):
		if dice.effect == Enums.DiceEffects.HEAL:
			return true
	return false
