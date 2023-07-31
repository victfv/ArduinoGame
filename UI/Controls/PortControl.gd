extends Control

var index = -1
var controlName

var type = -1 setget setType
var dataA = 0
var dataB = 0
var dataC = 0

signal deleted
signal nameChanged(nm)

func _ready():
	$Panel/HBoxContainer/LineEdit.text = "Control " + str(index)

func setType(t):
	type = t
	var text
	match type:
		-1:
			text = "Unknown"
		0:
			text = "Digital"
		1:
			text = "Analog 1 Axis"
		2:
			text = "Analog 2 Axis"
		3:
			text = "Analog 3 Axis"
	$Panel/HBoxContainer/Label.text = text

func getName() -> String:
	return $Panel/HBoxContainer/LineEdit.text

func _on_DeleteButton_pressed():
	emit_signal("deleted")
	queue_free()


func _on_AddButton_pressed():
	ControlsConfig.addControlElementNode(self)


func _on_LineEdit_text_changed(new_text):
	emit_signal("nameChanged", new_text)
