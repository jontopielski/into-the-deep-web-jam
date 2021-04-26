extends Control

func _ready():
	TextBox.connect("finished", self, "_on_TextBox_finished")
	TextBox.push_text('..')
	TextBox.push_text('Well that was your tour into the "Deep Web".')
	TextBox.push_text('Turns out the "Deep Web" is just a bunch of hidden pages.')
	TextBox.push_text("But not all hidden things are worthy of exploration.")
	TextBox.push_text("I hope this experience was worthy of exploration.")

func _on_TextBox_finished():
	$Label.show()
