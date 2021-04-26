extends Panel

signal attacked
signal critical_hit

var max_health = 0
var current_health = 0
onready var tween = $Tween

func _ready():
	State.connect("state_changed", self, "_on_State_changed")
	set_initial_health(State.get_value("current_player_health"))
#	start_mana_bar()

func start_mana_bar():
	$Tween.interpolate_property($ManaBar, "value", 100, 0, State.get_value("player_speed") * (1.0 - (Globals.SPEED_BONUS / 100.0)))
	$Tween.start()

func _on_State_changed(key, value):
	match key:
		"current_player_health":
			update_player_health(value)

func update_player_health(_current_health):
	current_health = _current_health
	$HealthBar.value = current_health
	$Health.text = "HP: %d/%d" % [current_health, max_health]

func set_initial_health(_initial_health):
	max_health = State.get_value("max_player_health")
	current_health = _initial_health
	$HealthBar.min_value = 0
	$HealthBar.max_value = max_health
	$HealthBar.value = current_health
	$Health.text = "HP: %d/%d" % [current_health, max_health]

func _on_Tween_tween_completed(object, key):
	var current_enemy_health = State.get_value("current_enemy_health")
	var next_dice = DiceManager.pop_next_dice()
	var dice_effect = next_dice.effect
	var dice_value = next_dice.value
	var next_damage = dice_value
	if Globals.CRIT_BONUS > 0:
		randomize()
		if randi() % 100 <= Globals.CRIT_BONUS * 1.2:
			emit_signal("critical_hit")
			next_damage *= 2
	match dice_effect:
		Enums.DiceEffects.HEAL:
			var current_player_health = State.get_value("current_player_health")
			var max_player_health = State.get_value("max_player_health")
			var updated_health = min(max_player_health, current_player_health + dice_value)
			State.set_value("current_player_health", updated_health)
		Enums.DiceEffects.FIRE:
			State.set_value("current_enemy_health", max(0, current_enemy_health - (next_damage * 2)))
			emit_signal("attacked")
		_:
			State.set_value("current_enemy_health", max(0, current_enemy_health - (next_damage)))
			emit_signal("attacked")
	start_mana_bar()

func _on_Battle_paused():
	$Tween.set_active(false)

func _on_Battle_unpaused():
	$Tween.set_active(true)
