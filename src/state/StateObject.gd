extends Resource
class_name StateObject

export(Array, Resource) var dice_deck = []
export(Array, Resource) var dice_draw_pile = []
export(Array, Resource) var dice_discard_pile = []

export(Array, Resource) var abilities = []

export(Resource) var current_enemy = null
export(float) var player_speed = 2.25
export(int) var max_player_health = 30
export(int) var current_player_health = 30
export(int) var current_enemy_health = 0
export(String) var dragged_ability = "NONE"

func set_value(property, value):
	set_deferred(property, value)
