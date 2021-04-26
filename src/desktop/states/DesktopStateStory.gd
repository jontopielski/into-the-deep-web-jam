extends FSM_State

var is_textbox_active = false

func on_enter():
	is_textbox_active = true
	TextBox.connect("finished", self, "_on_TextBox_finished")
	match Globals.ENCOUNTER_COUNT:
		2:
			TextBox.push_text("You delve a bit deeper into the web, searching for god knows what.")
		3:
			TextBox.push_text("You go deeper into the web, but for what?")
		4:
			TextBox.push_text("Deeper you venture, surely there must be something interesting.")
		5:
			TextBox.push_text("Deeper and deeper you go forward.")
		_:
			TextBox.push_text("You delve deeper and deeper into the web.")

func on_exit():
	pass

func run(_delta):
	pass

func _on_TextBox_finished():
	if is_textbox_active:
		is_textbox_active = false
		fsm.state_next = fsm.states.Battle
