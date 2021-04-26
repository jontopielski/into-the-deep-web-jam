extends FSM_State

var is_textbox_active = false

func on_enter():
	is_textbox_active = true
	TextBox.connect("finished", self, "_on_TextBox_finished")
	TextBox.push_text("The journey begins on the surface web.")
	TextBox.push_text("The public web.")

func on_exit():
	pass

func run(_delta):
	pass

func _on_TextBox_finished():
	if is_textbox_active:
		is_textbox_active = false
		fsm.state_next = fsm.states.Battle
