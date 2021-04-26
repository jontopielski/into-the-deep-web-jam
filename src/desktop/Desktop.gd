extends Control

export(PackedScene) var battle_window = null
export(PackedScene) var reward_window = null

onready var fsm = FSM.new(self, $States, $States/Setup, true)

func _ready():
	TextBox.connect("finished", self, "_on_TextBox_finished")
	State.connect("state_changed", self, "_on_State_changed")
	set_health_timer()

func _physics_process(delta):
	fsm.run_machine(delta)

func set_health_timer():
	var max_health = State.get_value("max_player_health")
	var current_health = State.get_value("current_player_health")
	$Taskbar/HP/CenterContainer/Label.text = "%2d:%2d HP" % [current_health, max_health]

func set_health_latest(latest):
	var max_health = State.get_value("max_player_health")
	$Taskbar/HP/CenterContainer/Label.text = "%2d:%2d HP" % [latest, max_health]

func _on_State_changed(key, value):
	match key:
		"current_player_health":
			set_health_latest(value)

func _on_BattleWindow_tree_exited():
	fsm.state_next = fsm.states.Reward

func _on_RewardWindow_tree_exited():
	Globals.ENCOUNTER_COUNT += 1
	fsm.state_next = fsm.states.Story

func instance_reward_screen():
	var next_window = reward_window.instance()
	add_child(next_window)
	next_window.connect("tree_exited", self, "_on_RewardWindow_tree_exited")

func instance_battle_window():
	var next_battle = battle_window.instance()
	add_child(next_battle)
	next_battle.connect("tree_exited", self, "_on_BattleWindow_tree_exited")
