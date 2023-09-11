extends Node

var inputParts = {}
var parts = [{"type" : "light", "level" : 1, "slot" : 0}]

#parts:
#{"type" : "light", "level" : 1, "slot" : 2}
#types: light, omni, glow

signal changeCam(cam)

func createPartControl(partName : String) -> InputElement:
	if (inputParts.has(partName)):
		return inputParts[partName]
	var newControl = ControlsConfig.addInputNode(partName)
	inputParts[partName] = newControl
	return newControl

var registeredParts = []
var registeredCams = []
var camControls : InputElement;

func _ready():
	camControls = PartsManager.createPartControl("Camera")
	
	camControls.addInput("X", 1, -1, 1)
	camControls.addInput("Y", 1, -1, 1)
	camControls.addInput("Next", 0)
	camControls.addInput("Prev", 0)

var currentCam = 0
var cPressed = false
func _process(delta):
	if registeredCams.size() > 0:
		var camAxis = camControls.getControl(2) - camControls.getControl(3)
		if abs(camAxis) > 0:
			if (!cPressed):
				setCamIndexWithWrap(camAxis)
				emit_signal("changeCam", registeredCams[currentCam])
			cPressed = true
		else:
			cPressed = false

func setCamIndexWithWrap(inc):
	currentCam += inc
	if (currentCam > registeredCams.size() - 1):
		currentCam = 0
	if (currentCam < 0):
		currentCam = registeredCams.size() - 1

func registerPart(part):
	registeredParts.append(part)
	match part.type:
		"omni":
			pass
		"light":
			pass
		"camera":
			registeredCams.append(part)
			emit_signal("changeCam", registeredCams[0])
