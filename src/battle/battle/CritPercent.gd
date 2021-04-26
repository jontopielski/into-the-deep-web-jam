extends Label

func _ready():
	text = "+%d" % Globals.CRIT_BONUS
	text += "%"
