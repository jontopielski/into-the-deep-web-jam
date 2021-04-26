extends Sprite

onready var enemy_health = State.get_value("current_enemy_health")

func _ready():
	flip_h = false
	State.connect("state_changed", self, "_on_State_changed")
	texture = State.get_value("current_enemy").sprite

func _on_State_changed(key, value):
	match key:
		"current_enemy_health":
			if value < enemy_health:
				enemy_health = value
				$AnimationPlayer.play("take_damage")
			if value == 0:
				$AnimationPlayer.play("die")

func _on_EnemyBattleUI_attacked():
	$AttackPlayer.play("attack")
