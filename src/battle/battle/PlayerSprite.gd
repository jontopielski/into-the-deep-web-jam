extends Sprite

onready var player_health = State.get_value("current_player_health")

func _ready():
	State.connect("state_changed", self, "_on_State_changed")

func _on_State_changed(key, value):
	match key:
		"current_player_health":
			if value < player_health:
				player_health = value
				$AnimationPlayer.play("take_damage")

func _on_PlayerBattleUI_attacked():
	$AttackPlayer.play("attack")
