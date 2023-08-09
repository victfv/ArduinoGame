extends GraphNode

var control = null
var index = 0

onready var a = $A
onready var b = $B
onready var c = $C

var da = 0
var db = 0
var dc = 0

func _ready():
	control.connect("deleted", self, "killed")
	control.connect("nameChanged", self, "nameChanged")

func getDataFromIndex(index) -> int:
	if control == null or !is_instance_valid(control):
		return 0
	match index:
		0:
			return da
		1:
			return db
		2:
			return dc
	return 0

func _process(delta):
	if (control != null):
		da = control.dataA
		db = control.dataB
		dc = control.dataC
	
	$A/Val.text = str(da)
	$B/Val.text = str(db)
	$C/Val.text = str(dc)

func updName(nm):
	title = nm

func killed():
	get_parent().emit_signal("delete_nodes_request", [self])
	queue_free()

func _on_Name_text_changed(new_text):
	pass

func nameChanged(nm):
	title = nm
