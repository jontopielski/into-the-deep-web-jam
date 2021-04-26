extends Node2D

#func _ready():
#	State.connect("state_changed", self, "_on_State_changed")
#	update_draw_pile(State.get_value("dice_draw_pile"))
#
#func _on_State_changed(key, value):
#	match key:
#		"dice_draw_pile":
#			update_draw_pile(value)
#
#func update_draw_pile(draw_pile):
#	for i in range(0, 4):
#		if i >= len(draw_pile):
#			get_child(i).frame = 0
#		else:
#			get_child(i).frame = draw_pile[i].value
#
#func _on_Battle_started_drag():
#	pass
#
#func _on_Battle_ended_drag():
#	pass # Replace with function body.
