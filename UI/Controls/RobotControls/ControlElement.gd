extends GraphNode

var control = null
var index = 0

onready var a = $A
onready var b = $B
onready var c = $C

func _ready():
	control.connect("deleted", self, "killed")
	control.connect("nameChanged", self, "nameChanged")

func getDataFromIndex(index) -> int:
	a.text = str(control.dataA)
	b.text = str(control.dataB)
	c.text = str(control.dataC)
	if control == null or !is_instance_valid(control):
		return 0
	match index:
		0:
			return control.dataA
		1:
			return control.dataB
		2:
			return control.dataC
	return 0

func updName(nm):
	title = nm

func killed():
	emit_signal("close_request")
	queue_free()

func _on_Name_text_changed(new_text):
	pass

func nameChanged(nm):
	title = nm
