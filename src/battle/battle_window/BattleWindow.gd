extends Control

func _on_Battle_won_battle():
	if Globals.ENCOUNTER_COUNT == 5:
		get_tree().paused = false
		get_tree().change_scene_to(load("res://src/menus/Outro.tscn"))
	else:
		get_tree().paused = false
		queue_free()
