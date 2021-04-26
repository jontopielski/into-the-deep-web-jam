extends FSM_State

func on_enter():
	obj.reset_textbox()

func on_exit():
	pass

func run(_delta):
	if !obj.text_queue.empty() and fsm.state_curr == fsm.states.Ready:
		fsm.state_next = fsm.states.Reading
