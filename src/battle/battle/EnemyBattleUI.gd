extends Panel

signal attacked

var max_health = 0
var current_health = 0
var enemy_speed = 0
var enemy_damage = 0
onready var tween = $Tween
var next_damage_amount = 0
var enemy_resource = null

func _ready():
	State.connect("state_changed", self, "_on_State_changed")
	enemy_resource = State.get_value("current_enemy")
	set_initial_health(State.get_value("current_enemy_health"))
	enemy_speed = enemy_resource.speed
	enemy_damage = enemy_resource.damage
	$Name.text = enemy_resource.name
	set_next_damage()
#	start_mana_bar()

func set_next_damage():
	randomize()
	var base_damage = enemy_resource.damage
	var plus_minus = enemy_resource.damage_range
	randomize()
	next_damage_amount = randi() % (2 * plus_minus) + (base_damage - plus_minus)
	$Sword/Label.text = str(next_damage_amount)

func start_mana_bar():
	$Tween.interpolate_property($ManaBar, "value", 100, 0, enemy_speed)
	$Tween.start()

func _on_State_changed(key, value):
	match key:
		"current_enemy_health":
			update_enemy_health(value)

func update_enemy_health(_current_health):
	current_health = _current_health
	$HealthBar.value = current_health
	$Health.text = "HP: %d/%d" % [current_health, max_health]

func set_initial_health(_initial_health):
	max_health = _initial_health
	current_health = _initial_health
	$HealthBar.min_value = 0
	$HealthBar.max_value = max_health
	$HealthBar.value = current_health
	$Health.text = "HP: %d/%d" % [current_health, max_health]

func _on_Tween_tween_completed(object, key):
	var current_player_health = State.get_value("current_player_health")
	State.set_value("current_player_health", max(0, current_player_health - next_damage_amount))
	set_next_damage()
	emit_signal("attacked")
	start_mana_bar()

func _on_Battle_paused():
	$Tween.set_active(false)

func _on_Battle_unpaused():
	$Tween.set_active(true)
