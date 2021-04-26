extends CenterContainer

signal started_dragging(sprite)
signal stopped_dragging

export(Resource) var ability = null
var ability_name = ""
var is_intro_done = false
var is_on_cooldown = false

func assign_ability(_ability):
	ability = _ability
	ability_name = ability.name
	$VBox/CenterContainer/Button.text = ability.name
	$VBox/Label.text = ability.description

func start_cooldown(is_paused):
	is_on_cooldown = true
	$VBox/CenterContainer/Button.hide()
	$VBox/CenterContainer/Cooldown.show()
	$VBox/CenterContainer/Cooldown.value = 0
	$Tween.interpolate_property($VBox/CenterContainer/Cooldown, "value", 0, 100, ability.cooldown)
	$Tween.start()
	if is_paused:
		$Tween.set_active(false)
	else:
		$Tween.set_active(true)

func _on_Button_button_down():
	if !is_intro_done or is_on_cooldown:
		return
	emit_signal("started_dragging", ability.sprite)
	State.set_value("dragged_ability", ability.name.to_upper())

func _on_Button_button_up():
	if !is_intro_done:
		return
	emit_signal("stopped_dragging")
	State.set_value("dragged_ability", "NONE")

func _on_Tween_tween_completed(object, key):
	is_on_cooldown = false
	$VBox/CenterContainer/Cooldown.hide()
	$VBox/CenterContainer/Button.show()

func _on_Battle_paused():
	$Tween.set_active(false)

func _on_Battle_unpaused():
	$Tween.set_active(true)
