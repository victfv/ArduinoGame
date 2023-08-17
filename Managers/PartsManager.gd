extends Node

var inputParts = {}
var parts = [{"type" : "light", "level" : 3, "slot" : 0}]

#parts:
#{"type" : "light", "level" : 1, "slot" : 2}
#types: light, omni, glow

func createPartControl(partName : String) -> InputElement:
	if (inputParts.has(partName)):
		return inputParts[partName]
	var newControl = ControlsConfig.addInputNode(partName)
	inputParts[partName] = newControl
	return newControl

