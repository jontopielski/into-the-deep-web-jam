extends Control

export(Resource) var starting_state = null

func _on_Button_pressed():
	reset_all_player_state()
	get_tree().change_scene_to(load("res://src/desktop/Desktop.tscn"))

func reset_all_player_state():
	Globals.ENCOUNTER_COUNT = 1
	Globals.CRIT_BONUS = 10
	Globals.SPEED_BONUS = 0
	var state_duplicate = starting_state.duplicate()
	State.set_value("dice_deck", state_duplicate.dice_deck)
	State.set_value("dice_draw_pile", state_duplicate.dice_draw_pile)
	State.set_value("dice_discard_pile", state_duplicate.dice_discard_pile)
	State.set_value("abilities", state_duplicate.abilities)
	State.set_value("current_enemy", state_duplicate.current_enemy)
	State.set_value("player_speed", state_duplicate.player_speed)
	State.set_value("max_player_health", state_duplicate.max_player_health)
	State.set_value("current_player_health", state_duplicate.current_player_health)
	State.set_value("current_enemy_health", state_duplicate.current_enemy_health)
	State.set_value("dragged_ability", state_duplicate.dragged_ability)
