extends FSM_State

func on_enter():
	get_tree().paused = true
	if obj.text_queue.empty():
		fsm.state_next = fsm.states.Reading
	else:
		obj.textbox.show()
		obj.body.percent_visible = 0
		obj.body.text = obj.text_queue.pop_front()
		obj.tween.interpolate_property(obj.body, "percent_visible", 0, 1.0, len(obj.body.text) * obj.READ_RATE, \
			obj.tween.TRANS_LINEAR, obj.tween.EASE_IN_OUT)
		obj.tween.start()

func on_exit():
	pass

func run(_delta):
	pass

func _input(event):
	if fsm.state_curr == fsm.states.Reading and Input.is_action_just_pressed("ui_accept") \
		and obj.tween.is_active():
			obj.tween.stop_all()
			obj.body.percent_visible = 1.0
			fsm.state_next = fsm.states.Finished

func _on_Tween_tween_completed(object, key):
	if fsm.state_curr == fsm.states.Reading:
		fsm.state_next = fsm.states.Finished
