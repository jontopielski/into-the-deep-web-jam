extends Control

var text_counter = 0

func _ready():
	$Silhouette.hide()
	$Computer.hide()
	$ComputerOff.hide()
	$Silhouette.scale = Vector2(0.3, 0.3)
	$Silhouette.position = Vector2(114, 78)
	TextBox.connect("finished", self, "_on_TextBox_finished")

func _on_TextBox_finished():
	match text_counter:
		0:
			text_counter += 1
			$Silhouette.show()
			$ComputerOff.show()
			TextBox.push_text("It's you.")
			TextBox.push_text("But you're too big.")
		1:
			text_counter += 1
			$AnimationPlayer.play("shrink")
		2:
			text_counter +=1
			$AnimationPlayer.play("warp")

func _on_Button_pressed():
	$CenterContainer.hide()
	$Button.hide()
	push_initial_texts()

func push_initial_texts():
	TextBox.push_text('"Deep Web"')
	TextBox.push_text('What secrets could it hold?')

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shrink":
		TextBox.push_text("That's better.")
		TextBox.push_text("Off you go.")
	if anim_name == "warp":
		$AnimationPlayer.play("outro")
	if anim_name == "outro":
		get_tree().change_scene_to(load("res://src/desktop/Desktop.tscn"))
