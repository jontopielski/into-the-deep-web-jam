extends FSM_State

var can_proceed = false

func on_enter():
	can_proceed = false
	$Timer.wait_time = obj.READ_RATE
	$Timer.start()

func on_exit():
	obj.ticker.hide()

func run(_delta):
	pass

func _input(event):
	if fsm.state_curr == fsm.states.Finished and Input.is_action_just_pressed("ui_accept") \
		and can_proceed:
			if obj.text_queue.empty():
				fsm.state_next = fsm.states.Ready
				get_tree().paused = false
				obj.set_speaker("")
				obj.set_portrait(null)
				obj.emit_signal("finished")
			else:
				fsm.state_next = fsm.states.Reading

func _on_Timer_timeout():
	obj.ticker.show()
	can_proceed = true
