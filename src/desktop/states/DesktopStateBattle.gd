extends FSM_State

var is_textbox_active = false

func on_enter():
	TextBox.connect("finished", self, "_on_TextBox_finished")
	Helpers.reset_player_battle_state()
	Helpers.set_next_enemy()
	$DelayTimer.start()

func on_exit():
	pass

func run(_delta):
	pass

func _on_DelayTimer_timeout():
	obj.instance_battle_window()
	is_textbox_active = true
	match Globals.ENCOUNTER_COUNT:
		1:
			TextBox.push_text("An enemy draws near!")
			TextBox.push_text("Don't panic - you'll automatically attack with your dice every couple of seconds.")
			TextBox.push_text("Pause the fight using SPACE to catch your breath and use abilities in the bottom panel.")
			TextBox.push_text("Good luck!")
		2:
			TextBox.push_text("A strange relic of the past approaches!")
			TextBox.push_text("Blog Man represents all the private journals that never got published.")
			TextBox.push_text("Good luck!")
		3:
			TextBox.push_text("A double edged figure appears!")
			TextBox.push_text("Pill Man represents all the medical records that will never be scraped.")
			TextBox.push_text("Good luck!")
		4:
			TextBox.push_text("An automaton charges up!")
			TextBox.push_text("Rack Man represents all the private servers for companies worldwide.")
			TextBox.push_text("Good luck!")
		5:
			TextBox.push_text("A scientist wanders forward!")
			TextBox.push_text("Science Man represents all the research papers that never saw the light of day.")
			TextBox.push_text("Good luck!")

func _on_TextBox_finished():
	if is_textbox_active:
		is_textbox_active = false
