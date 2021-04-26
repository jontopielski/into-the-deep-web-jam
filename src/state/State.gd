extends Node

signal state_changed

const GlobalState = preload("res://src/state/GlobalState.tres")

func set_value(key, value):
	if GlobalState.get(key) != null:
		GlobalState.set_value(key, value)
		emit_signal("state_changed", key, value)

func get_value(key):
	return GlobalState.get(key)

func get_state_tree():
	var state = {}
	for property in GlobalState.get_property_list():
		if property.type == 2 and GlobalState.get(property.name) != null:
			state[property.name] = GlobalState.get(property.name)
	return state
