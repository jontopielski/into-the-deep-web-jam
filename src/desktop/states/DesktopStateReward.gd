extends FSM_State

var is_textbox_active = false

func on_enter():
	
	var current_player_health = State.get_value("current_player_health")
	var max_player_health = State.get_value("max_player_health")
	var updated_health = min(max_player_health, current_player_health + 10)
	State.set_value("current_player_health", updated_health)
	
	TextBox.connect("finished", self, "_on_TextBox_finished")
	match Globals.ENCOUNTER_COUNT:
		_:
			is_textbox_active = true
			TextBox.push_text("You heal +10 HP after the battle.")

func on_exit():
	pass

func run(_delta):
	pass

func _on_TextBox_finished():
	if is_textbox_active:
		is_textbox_active = false
		obj.instance_reward_screen()
