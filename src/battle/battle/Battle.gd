extends Control

const Ability = preload("res://src/battle/battle/Ability.tscn")

signal paused
signal unpaused
signal started_drag
signal ended_drag
signal won_battle

var is_paused = false
var is_intro_done = false
var is_dragging = false

func _ready():
	$Victory.hide()
	$GameOver.hide()
	$PauseContainer.hide()
	$AnimationPlayer.play("load")
	load_abilities()
	State.connect("state_changed", self, "on_State_changed")
	TextBox.connect("finished", self, "_on_TextBox_finished")

var sent_enemy_text = false
func on_State_changed(key, value):
	match key:
		"current_player_health":
			if value == 0:
				$DragSprite.hide()
				$PauseContainer.hide()
				$AnimationPlayer.play("game_over")
				get_tree().paused = true
		"current_enemy_health":
			if value == 0:
				$DragSprite.hide()
				sent_enemy_text = true
				Helpers.play_enemy_defeated_text()
				get_tree().paused = true

func _on_TextBox_finished():
	if sent_enemy_text:
		get_tree().paused = true
		$PauseContainer.hide()
		$AnimationPlayer.play("victory")

func load_abilities():
	var abilities = State.get_value("abilities")
	for i in range(0, len(abilities)):
		if i == 3:
			break;
		var ability_res = abilities[i]
		var ability_inst = Ability.instance()
		ability_inst.assign_ability(ability_res)
		$BottomPanel/Abilities.add_child(ability_inst)
		ability_inst.connect("started_dragging", self, "_on_Ability_started_dragging")
		ability_inst.connect("stopped_dragging", self, "_on_Ability_stopped_dragging")
		self.connect("paused", ability_inst, "_on_Battle_paused")
		self.connect("unpaused", ability_inst, "_on_Battle_unpaused")

func _on_Ability_started_dragging(sprite):
	is_dragging = true
	$DragSprite.texture = sprite

func _on_Ability_stopped_dragging():
	is_dragging = false
	$DragSprite.texture = null
	$DragSprite.position = Vector2.ZERO

func _process(delta):
	if is_dragging:
		$DragSprite.global_position = get_global_mouse_position()

func _input(event):
	if Input.is_action_just_pressed("ui_pause"):
		if !is_paused:
			pause()
		else:
			unpause()

func pause():
	if !is_intro_done:
		return
	is_paused = true
	$PauseContainer.show()
	$BottomPanel/VBoxContainer/PauseButton.text = "Unpause"
	emit_signal("paused")

func unpause():
	$PauseContainer.hide()
	is_paused = false
	$BottomPanel/VBoxContainer/PauseButton.text = "Pause"
	emit_signal("unpaused")

func _on_PauseButton_pressed():
	if is_paused:
		unpause()
	else:
		pause()

func _on_AnimationPlayer_animation_finished(anim_name):
	is_intro_done = true
	for ability in $BottomPanel/Abilities.get_children():
		ability.is_intro_done = true
	$EnemyBattleUI.start_mana_bar()
	$PlayerBattleUI.start_mana_bar()

func _on_DiceHolder_used_ability(ability):
	for abil in $BottomPanel/Abilities.get_children():
		if abil.ability_name.to_upper() == ability:
			abil.start_cooldown(is_paused)

func _on_GameOverButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to(load("res://src/menus/GameOver.tscn"))

func _on_VictoryButton_pressed():
	emit_signal("won_battle")
