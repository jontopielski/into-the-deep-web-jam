extends Label

func _ready():
	text = "+%d" % Globals.SPEED_BONUS
	text += "%"
