extends GraphNode

class_name InputElement

const rangeSel = preload("res://UI/Controls/RobotControls/RangeSelector.tscn")
const dig = preload("res://UI/Controls/RobotControls/DigitalInput.tscn")

var connections = {}

var addSlot = 0
func addInput(inputName, type, rangeMin, rangeMax):
	match type:
		0:
			var current = dig
			current.setName(inputName)
			add_child(current)
			set_slot(addSlot, true, 0, "ababab", false, 0, Color.white)
		1:
			var current = rangeSel.instance()
			current.setName(inputName)
			current.setRange(rangeMin, rangeMax)
			add_child(current)
			set_slot(addSlot, true, 0, "ababab", false, 0, Color.white)
	addSlot += 1

func setName(newName):
	title = newName

func getControl(index) -> float:
	if connections.has(index):
		var npt = get_child(index)
		var obj = connections[index]["object"]
		var idx = connections[index]["index"]
		if (npt.has_method("getInRange")):
			return npt.getInRange(obj.getDataFromIndex(idx))
		return npt.getIn(obj.getDataFromIndex(idx))
	return 0.0

func addConnection(index, obj, fromIndex):
	connections[index] = {"object" : obj, "index" : fromIndex}

func removeConnection(index):
	if connections.has(index):
		print("cn erased")
		connections.erase(index)
