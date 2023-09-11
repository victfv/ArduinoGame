extends Spatial

func _ready():
	set_process(true)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _physics_process(delta):
	var analog = ControlsConfig.getControl("Main", "Analog")
	rotation.x = (float(analog[0] - 512)/1024.0) * PI/2
	rotation.z = (float(analog[1] - 512)/1024.0) * PI/2
	#if (index == 1):
	#	$MeshInstance2.material_override.call_deferred("set", "albedo_color", Color.red if (dataA == 1) else Color.white)
	#if (index == 2):
	#	$MeshInstance.material_override.call_deferred("set", "albedo_color", Color.red if (dataA == 1) else Color.white)
	
	#serial_interface.SendStatus(64,100,30)

# warning-ignore:unused_argument
var tmr = 1.0
var health = 255

func _process(delta):
	tmr = max(tmr - delta, 0.0)
	if (tmr < 0.001):
		print("Health: " + str(health))
		#ControlsConfig.sendData(health, 50, 30, "Controller 0")
		tmr = 0.1
		health -= 1;
		if (health < 0):
			health = 255
