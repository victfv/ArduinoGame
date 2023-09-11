extends Control

onready var controls_graph = $Panel/MarginContainer/ControlsGraph

func _ready():
	set_process(false)
	yield(get_tree().create_timer(0.4), "timeout")
	_on_Button_pressed()


func _on_ControlsGraph_connection_request(from, from_slot, to, to_slot):
	if from == to:
		return
	for cn in controls_graph.get_connection_list():
		if cn.to == to and cn.to_port == to_slot:
			controls_graph.disconnect_node(cn.from, cn.from_port, to, to_slot)
	controls_graph.connect_node(from, from_slot, to, to_slot)
	var fromNode = controls_graph.get_node(from)
	controls_graph.get_node(to).addConnection(to_slot, fromNode, from_slot)

func _on_ControlsGraph_disconnection_request(from, from_slot, to, to_slot):
	controls_graph.disconnect_node(from, from_slot, to, to_slot)
	controls_graph.get_node(to).removeConnection(to_slot)

var closed = false
func _on_Button_pressed():
	closed = !closed
	set_process(true)

onready var panel = $Panel

func _process(delta):
	if closed:
		panel.rect_position.x = lerp(panel.rect_position.x, panel.rect_size.x, delta * 20.0)
		$Panel/Button.text = "<<"
		if (panel.rect_position.x > (panel.rect_size.x - 0.001)):
			#print(str(panel.rect_position.x) + " > " + str(panel.rect_size.x - 0.001))
			set_process(false)
	else:
		panel.rect_position.x = lerp(panel.rect_position.x, 32, delta * 20.0)
		$Panel/Button.text = ">>"
		if (panel.rect_position.x < 0.001):
			set_process(false)

const ctrlElemScene = preload("res://UI/Controls/RobotControls/ControlElement.tscn")

func addControlElemNode(node):
	var current = ctrlElemScene.instance()
	current.control = node
	current.title = node.getName()
	controls_graph.add_child(current)

const inputElementScene = preload("res://UI/Controls/RobotControls/InputElement.tscn")

func addInputNode(newName) -> Object:
	var current = inputElementScene.instance()
	controls_graph.add_child(current)
	current.setName(newName)
	return current

func _on_ControlsGraph_delete_nodes_request(nodes):
	for node in nodes:
		for connection in controls_graph.get_connection_list():
			if connection.from == node.name or connection.to == node.name:
				_on_ControlsGraph_disconnection_request(connection.from, connection.from_port, connection.to, connection.to_port)
		node.queue_free()


func _on_ControlsGraph_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 and !event.pressed:
			var axis = load("res://UI/Controls/RobotControls/Axis.tscn").instance()
			controls_graph.add_child(axis)
