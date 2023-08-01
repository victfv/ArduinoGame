extends VehicleBody

var health = 1000
var energy = 1000
var cargo = 0

var throttle = 0.0
var turn = 0.0
var brk = 0.0
var torque = 30.0
var maxSpeed = 3.0

var spd = 0.0

onready var b_wheel_r = $BWheelR
onready var b_wheel_l = $BWheelL
onready var f_wheel_l = $FWheelL
onready var f_wheel_r = $FWheelR

var prevVel = Vector3()

var nd : InputElement = null

func _ready():
	nd = ControlsConfig.addInputNode("Movement")
	nd.addInput("Throttle", 1, -1, 1)
	nd.addInput("Steering", 1, -1, 1)
	nd.addInput("Break", 1, 0, 1)

func _process(delta):
	throttle = clamp(nd.getControl(0), -1, 1)#float(Input.is_action_pressed("ui_up")) - float(Input.is_action_pressed("ui_down"))
	turn = clamp(nd.getControl(1), -1, 1)#float(Input.is_action_pressed("ui_left")) - float(Input.is_action_pressed("ui_right"))
	brk = clamp(nd.getControl(2), 0, 1)
	ControlsConfig.sendDataAll(health, energy, cargo, int(throttle * 100), int(spd * 100))

func _physics_process(delta):
	spd = linear_velocity.project(global_transform.basis.z.normalized()).length()
	engine_force = throttle * (torque - clamp(spd/maxSpeed,0,1) * torque)
	steering = lerp(steering, turn * (PI/4), delta * 3.0)
	brake = brk * 0.5
	prevVel = linear_velocity


func _on_PlayerRobot_body_entered(body):
	var contactVel = (linear_velocity - prevVel).length()
	if (contactVel > 0.4):
		var dmg = int(contactVel * 30)
		health = max(0.0, health - dmg)
		print(dmg)
