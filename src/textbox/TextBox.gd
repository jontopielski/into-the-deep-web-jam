extends CanvasLayer

signal finished

const READ_RATE = 0.015

onready var textbox = get_node("TextBox")
onready var speaker = get_node("TextBox/Margin/HBox/HBox/VBox/Speaker")
onready var body = get_node("TextBox/Margin/HBox/HBox/VBox/Body")
onready var portrait = get_node("TextBox/Margin/HBox/Patch/Center/Portrait")
onready var portrait_container = get_node("TextBox/Margin/HBox/Patch")
onready var ticker = get_node("TextBox/Margin/HBox/HBox/Margin/Ticker")
onready var tween = get_node("Tween")

onready var fsm = FSM.new(self, $States, $States/Ready, true)

var text_queue = []

func _ready():
	set_speaker("")
	set_portrait(null)
	reset_textbox()

func _process(delta):
	fsm.run_machine(delta)

func push_text(_text):
	text_queue.push_back(_text)

func set_speaker(_speaker):
	speaker.text = _speaker
	if speaker.text == "":
		speaker.hide()
	else:
		if !speaker.text.ends_with(":"):
			speaker.text += ":"
		speaker.show()

func set_portrait(_portrait):
	portrait.texture = _portrait
	if _portrait:
		portrait_container.show()
	else:
		portrait_container.hide()

func reset_textbox():
	textbox.hide()
	ticker.hide()
	body.text = ""
