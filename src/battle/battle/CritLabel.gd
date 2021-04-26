extends Label

func _ready():
	hide()

func _on_PlayerBattleUI_critical_hit():
	show()
	rect_position = Vector2(190, 68)
	$Tween.interpolate_property(self, "rect_position", Vector2(190, 68), Vector2(190, 79), 1.0)
	$Tween.start()

func _on_Battle_paused():
	$Tween.set_active(false)

func _on_Battle_unpaused():
	$Tween.set_active(true)

func _on_Tween_tween_completed(object, key):
	hide()
