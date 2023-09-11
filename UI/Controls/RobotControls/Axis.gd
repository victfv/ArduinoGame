extends GraphNode

var connections = {}

func getDataFromIndex(index):
	#print(connections)
	if !(connections.has(0) and connections.has(1)):
		return 0.0
	
	var obj0 = connections[0]["object"]
	var idx0 = connections[0]["index"]
	var obj1 = connections[1]["object"]
	var idx1 = connections[1]["index"]
	
	var val = obj0.getDataFromIndex(idx0) - obj1.getDataFromIndex(idx1)
	return val
	#obj.getDataFromIndex(idx)

func _process(delta):
	if !(connections.has(0) and connections.has(1)):
		$HBoxContainer/Val.text = "0"
		return
	
	var obj0 = connections[0]["object"]
	var idx0 = connections[0]["index"]
	var obj1 = connections[1]["object"]
	var idx1 = connections[1]["index"]
	
	var val = obj0.getDataFromIndex(idx0) - obj1.getDataFromIndex(idx1)
	$HBoxContainer/Val.text = str(val)

func addConnection(index, obj, fromIndex):
	connections[index] = {"object" : obj, "index" : fromIndex}

func removeConnection(index):
	if connections.has(index):
		print("cn erased")
		connections.erase(index)

func getControl(index) -> float:
	if connections.has(index):
		var npt = get_child(index)
		var obj = connections[index]["object"]
		var idx = connections[index]["index"]
		if (npt.has_method("getInRange")):
			return npt.getInRange(obj.getDataFromIndex(idx))
		return npt.getIn(obj.getDataFromIndex(idx))
	return 0.0
