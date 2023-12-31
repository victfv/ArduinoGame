extends Control

const debugControls = false

func _enter_tree():
	rect_size = get_viewport().size
	get_parent().connect("child_entered_tree", self, "reorder")

func reorder(node):
	if (node != self):
		get_parent().call_deferred("move_child", node, 0)

onready var port_line = $Panel/VBoxContainer/PortAdderBar/PortLine
onready var baud_rate_line = $Panel/VBoxContainer/PortAdderBar/BaudRateLine
onready var ports = $Ports
onready var ports_container = $Panel/VBoxContainer/ScrollContainer/PortsContainer
onready var robot_control = $RobotControl


const serialScene = preload("res://Serial/SerialInterfaceManager.tscn")
const portUI = preload("res://UI/Controls/PortUI.tscn")

func connectionError(port):
	pass
	#print("Connection error on port \"" + port + "\"")

const timerTime = 0.2
var checkTimer = timerTime

var cnPorts : PoolStringArray = []

func _ready():
	_on_Button_pressed()

func _process(delta):
	checkTimer = max(0.0, checkTimer - delta)
	if (checkTimer == 0.0):
		for p in ports_container.get_children():
			p.testPort()
		checkTimer = timerTime
		
		updatePortsOptions()

onready var port_select = $Panel/VBoxContainer/PortAdderBar/PortSelect

func updatePortsOptions():
	if cnPorts != $Ports.getPortNames():
		cnPorts = $Ports.getPortNames()
		port_select.clear()
		port_select.add_item("None", 0)
		var id = 1
		for port in cnPorts:
			port_select.add_item(port, id)
			id += 1
	

var portCounter = 0

func _on_AddButton_pressed():
	var port = cnPorts[port_select.selected - 1]
	var baud = baud_rate_line.text
	if (port == ""):
		port = "COM3"
	if (baud == ""):
		baud = "9600"
	
	var cPort = serialScene.instance()
	cPort.connect("connectionError", self, "connectionError")
	cPort.port = port
	cPort.baudRate = int(baud)
	ports.add_child(cPort)
	
	var cPortUI = portUI.instance()
	cPortUI.get_node("Panel/MarginContainer/VBoxContainer/NameBox/NameLine").text = "Controller " + str(portCounter)
	cPortUI.get_node("Panel/MarginContainer/VBoxContainer/HeaderBox/Port").text = port
	cPortUI.get_node("Panel/MarginContainer/VBoxContainer/HeaderBox/BaudRate").text = baud
	cPortUI.portInterface = cPort
	ports_container.add_child(cPortUI)

func sendDataAll(health, energy, cargo, throttle, speed):
	for cn in ports_container.get_children():
		cn.sendInfo(health, energy, cargo, throttle, speed)

func sendData(health, energy, cargo, interface, throttle, speed):
	for cn in ports_container.get_children():
		if cn.getName() == "_" + interface:
			cn.sendInfo(health, energy, cargo, throttle, speed)

func getControl(port, control):
	var arr = [0,0,0]
	for cn in ports_container.get_children():
		if cn.getName() == "_" + port:
			arr = cn.getControl(control)
	return arr

var closed = false
func _on_Button_pressed():
	if !closed:
		closed = true
		$AnimationPlayer.play("Close")
		$Panel/OpenArrow/MarginContainer/CloseButton.text = ">>"
	else:
		closed = false
		$AnimationPlayer.play_backwards("Close")
		$Panel/OpenArrow/MarginContainer/CloseButton.text = "<<"

func addControlElementNode(ctrl):
	robot_control.addControlElemNode(ctrl)

func addInputNode(newName) -> Object:
	return robot_control.addInputNode(newName)


func _on_PortSelect_item_selected(index):
	$Panel/VBoxContainer/PortAdderBar/AddButton.disabled = index == 0
