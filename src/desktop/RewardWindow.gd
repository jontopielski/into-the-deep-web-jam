extends Control

var has_gotten_heal = false

func _ready():
	set_rewards()

func set_rewards():
	var left_reward = get_next_left_reward()
	$Window/Rewards/RewardLeft.assign_reward(left_reward)
	var right_reward = get_random_reward()
	while (left_reward == right_reward):
		right_reward = get_random_reward()
	$Window/Rewards/RewardRight.assign_reward(right_reward)
	$Window/Rewards/RewardLeft.show()
	$Window/Rewards/RewardRight.show()

func get_next_left_reward():
	if !Helpers.has_ability("shuffle"):
		return load("res://src/resources/rewards/ShuffleReward.tres")
	elif !Helpers.has_ability("bump+"):
		return load("res://src/resources/rewards/BumpPlusReward.tres")
	elif !Helpers.has_ability("instant"):
		return load("res://src/resources/rewards/InstantReward.tres")
	else:
		return get_random_reward()

func get_random_reward():
	var rewards = [
		load("res://src/resources/rewards/CritReward.tres"),
		load("res://src/resources/rewards/FireDieReward.tres"),
		load("res://src/resources/rewards/HealingDieReward.tres"),
#		load("res://src/resources/rewards/HealReward.tres"),
		load("res://src/resources/rewards/SpeedReward.tres")
	]
#	if State.get_value("current_player_health") < 10 and !has_gotten_heal and (randi() % 10 <= 8) or (Globals.ENCOUNTER_COUNT == 4 and !has_gotten_heal):
#		has_gotten_heal = true
#		return rewards[3]
	randomize()
	var next_reward = rewards[randi() % len(rewards)]
	while !is_reward_valid(next_reward):
		randomize()
		next_reward = rewards[randi() % len(rewards)]
	return next_reward

func is_reward_valid(reward):
	if "FIRE" in reward.title and Helpers.has_fire_dice():
		return false
	elif "HEAL" in reward.title and Helpers.has_heal_dice():
		return false
	elif "CRIT" in reward.title and Globals.CRIT_BONUS >= 100:
		return false
	elif "SPED" in reward.title and Globals.SPEED_BONUS >= 100:
		return false
	else:
		return true

func _on_Reward_reward_accepted():
	queue_free()
