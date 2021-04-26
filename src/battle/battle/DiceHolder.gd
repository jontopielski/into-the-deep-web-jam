extends Node2D

signal used_ability(ability)

export(int) var index = 0
export(Color) var eligible_color = Color("ffd273")
export(Color) var hover_color = Color("d41818")
export(Color) var fire_color = Color("0cc509")
export(Color) var heal_color = Color("99e550")

var is_hovering = false
var is_eligible = false
var current_ability = "NONE"

func _ready():
	$Focus.hide()
	State.connect("state_changed", self, "_on_State_changed")
	update_dice_sprite(State.get_value("dice_draw_pile"))

func _input(event):
	if Input.is_action_just_released("ui_release"):
		if is_hovering and is_eligible and $Sprite.frame != 0:
			print("Received ability: %s" % current_ability)
			use_ability(current_ability)

func use_ability(current_ability):
	is_eligible = false
	is_hovering = false
	match current_ability.to_upper():
		"BUMP":
			DiceManager.apply_bump(index)
			emit_signal("used_ability", current_ability.to_upper())
		"SHUFFLE":
			DiceManager.apply_shuffle(index)
			emit_signal("used_ability", current_ability.to_upper())
		"BUMP+":
			DiceManager.apply_bump_plus(index)
			emit_signal("used_ability", current_ability.to_upper())
		"INSTANT":
			DiceManager.apply_instant(index)
			emit_signal("used_ability", current_ability.to_upper())

func _on_State_changed(key, value):
	match key:
		"dice_draw_pile":
			update_dice_sprite(value)
		"dragged_ability":
			handle_dragged_ability(value)

func update_dice_sprite(draw_pile):
	if index < len(draw_pile):
		$Sprite.frame = draw_pile[index].value
		match draw_pile[index].effect:
			Enums.DiceEffects.DAMAGE:
				$Sprite.modulate = Color.white
			Enums.DiceEffects.FIRE:
				$Sprite.modulate = fire_color
			Enums.DiceEffects.HEAL:
				$Sprite.modulate = heal_color
	else:
		$Sprite.frame = 0
	handle_dragged_ability(State.get_value("dragged_ability"))

func handle_dragged_ability(ability):
	if $Sprite.frame == 0:
		is_eligible = false
		$Focus.hide()
		return
	current_ability = ability
	match ability.to_upper():
		"BUMP":
			if $Sprite.frame < 6 and $Sprite.frame != 0:
				is_eligible = true
				$Focus.modulate = eligible_color
				$Focus.show()
		"SHUFFLE":
			if $Sprite.frame != 0:
				is_eligible = true
				$Focus.modulate = eligible_color
				$Focus.show()
		"BUMP+":
			if $Sprite.frame < 6 and $Sprite.frame != 0:
				is_eligible = true
				$Focus.modulate = eligible_color
				$Focus.show()
		"INSTANT":
			if $Sprite.frame != 0:
				is_eligible = true
				$Focus.modulate = eligible_color
				$Focus.show()
		"NONE":
			is_eligible = false
			$Focus.hide()

func _on_Area2D_area_entered(area):
	if "Drag" in area.name:
		is_hovering = true
		if is_eligible:
			pass
			$Focus.modulate = hover_color
			$Focus.show()

func _on_Area2D_area_exited(area):
	if "Drag" in area.name:
		is_hovering = false
		if is_eligible:
			pass
			$Focus.modulate = eligible_color
			$Focus.show()
		current_ability = "NONE"
