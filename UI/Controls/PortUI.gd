extends Control

var portInterface = null
onready var portLine = $Panel/MarginContainer/VBoxContainer/HeaderBox/Port
onready var baudLine = $Panel/MarginContainer/VBoxContainer/HeaderBox/BaudRate
onready var controls_box = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ControlsBox
onready var stats_label = $Panel/MarginContainer/VBoxContainer/NameBox/StatsLabel

const control = preload("res://UI/Controls/Control.tscn")


func testPort():
	if (portInterface.GetConnected()):
		stats_label.text = "Status: OK"
	else:
		stats_label.text = "Status: CLOSED"

func _ready():
	portInterface.connect("controlReceived", self, "controlReceived")

func _on_AcceptButton_pressed():
	if portInterface != null:
		portInterface.port = portLine.text
		portInterface.baudRate = int(baudLine.text)

func controlReceived(index, type, dataA, dataB, dataC):
	for ctrl in controls_box.get_children():
		if (ctrl.index == index):
			ctrl.type = type
			ctrl.dataA = dataA
			ctrl.dataB = dataB
			ctrl.dataC = dataC
			return
	addCtrl(index, type, dataA, dataB, dataC)

func addCtrl(index, type, dataA, dataB, dataC):
	var newControl = control.instance()
	newControl.index = index
	newControl.type = type
	newControl.dataA = dataA
	newControl.dataB = dataB
	newControl.dataC = dataC
	controls_box.add_child(newControl)

func getName() -> String:
	if (is_inside_tree()):
		return "_" + $Panel/MarginContainer/VBoxContainer/NameBox/NameLine.text
	return "ERRNOTINTREE"

func sendInfo(health : int, energy : int, cargo : int):
	portInterface.SendStatus(health,energy,cargo)

func getControl(control):
	for ctrl in controls_box.get_children():
		if ctrl.getName() == control:
			var ret = []
			ret.push_back(ctrl.dataA)
			ret.push_back(ctrl.dataB)
			ret.push_back(ctrl.dataC)
			return ret
	return [0,0,0]

func _on_CloseButton_pressed():
	portInterface.Close()
	for ch in $Panel/MarginContainer/VBoxContainer/ScrollContainer/ControlsBox.get_children():
		ch._on_DeleteButton_pressed()
	portInterface.queue_free()
	queue_free()
