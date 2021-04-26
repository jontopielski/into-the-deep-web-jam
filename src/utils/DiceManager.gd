extends Node

const Dice = preload("res://src/resources/Dice.tres")

func _ready():
	pass

func pop_next_dice():
	var dice_draw_pile = State.get_value("dice_draw_pile")
	var dice_discard_pile = State.get_value("dice_discard_pile")
	
	var next_dice = dice_draw_pile.pop_front()
	var dice_duplicate = next_dice.duplicate()
	var dice_value = next_dice.value
	
	State.set_value("dice_draw_pile", dice_draw_pile)
	dice_discard_pile.push_back(next_dice)
	State.set_value("dice_discard_pile", dice_discard_pile)
	
	if dice_draw_pile.empty():
		randomize()
		dice_discard_pile.shuffle()
		dice_discard_pile = get_new_dice_values(dice_discard_pile)
		State.set_value("dice_draw_pile", dice_discard_pile)
		State.set_value("dice_discard_pile", [])

	return dice_duplicate

func get_new_dice_values(dice_array):
	for i in range(0, len(dice_array)):
		randomize()
		dice_array[i].value = dice_array[i].values[randi() % len(dice_array[i].values)]
	return dice_array

func set_initial_player_dice_deck():
	var initial_dice = []
	for i in range(0, 8):
		var next_dice = Dice.duplicate()
		initial_dice.push_back(next_dice)
	State.set_value("dice_deck", initial_dice)

func apply_bump(dice_index):
	var draw_pile = State.get_value("dice_draw_pile")
	if dice_index >= len(draw_pile):
		return
	if draw_pile[dice_index].value <= 5:
		draw_pile[dice_index].value += 1
	State.set_value("dice_draw_pile", draw_pile)

func apply_bump_plus(dice_index):
	var draw_pile = State.get_value("dice_draw_pile")
	if dice_index >= len(draw_pile):
		return
	if draw_pile[dice_index].value <= 5:
		draw_pile[dice_index].value = min(6, draw_pile[dice_index].value + 2)
	State.set_value("dice_draw_pile", draw_pile)

func apply_instant(dice_index):
	var draw_pile = State.get_value("dice_draw_pile")
	var discard_pile = State.get_value("dice_discard_pile")
	if dice_index >= len(draw_pile):
		return
	var selected_dice = draw_pile[dice_index]
	var dice_type = selected_dice.effect
	var dice_value = selected_dice.value
	match dice_type:
		Enums.DiceEffects.HEAL:
			var current_player_health = State.get_value("current_player_health")
			var max_player_health = State.get_value("max_player_health")
			var updated_health = min(max_player_health, current_player_health + dice_value)
			State.set_value("current_player_health", updated_health)
		Enums.DiceEffects.FIRE:
			var current_enemy_health = State.get_value("current_enemy_health")
			State.set_value("current_enemy_health", max(0, current_enemy_health - (dice_value * 2)))
		_:
			var current_enemy_health = State.get_value("current_enemy_health")
			State.set_value("current_enemy_health", max(0, current_enemy_health - (dice_value)))
	discard_pile.push_back(selected_dice)
	draw_pile.remove(dice_index)
	State.set_value("dice_draw_pile", draw_pile)
	State.set_value("dice_discard_pile", discard_pile)
	
	
	if draw_pile.empty():
		randomize()
		discard_pile.shuffle()
		discard_pile = get_new_dice_values(discard_pile)
		State.set_value("dice_draw_pile", discard_pile)
		State.set_value("dice_discard_pile", [])
	
	State.set_value("dragged_ability", "NONE")

func apply_shuffle(dice_index):
	var draw_pile = State.get_value("dice_draw_pile")
	if dice_index >= len(draw_pile):
		return
	var original_value = draw_pile[dice_index].value
	randomize()
	var next_value = randi() % 6 + 1
	while next_value == original_value:
		randomize()
		next_value = randi() % 6 + 1
	draw_pile[dice_index].value = next_value
	State.set_value("dice_draw_pile", draw_pile)
