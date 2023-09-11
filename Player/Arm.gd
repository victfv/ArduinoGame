extends Spatial


onready var crane_base = $CraneBase
onready var crane_arm = $CraneBase/CraneArm
onready var crane_extension = $CraneBase/CraneArm/CraneExtension
onready var grabber_tip = $CraneBase/CraneArm/CraneExtension/GrabberTip
onready var pin_joint = $CraneBase/CraneArm/CraneExtension/PinJoint
onready var grabber_base = $CraneBase/CraneArm/CraneExtension/GrabberBase
onready var pull_point = $CraneBase/CraneArm/CraneExtension/GrabberTip/PullPoint
onready var area = $CraneBase/CraneArm/CraneExtension/GrabberTip/Area


var ctrl : InputElement

func _ready():
	
	grabber_tip.set_as_toplevel(true)
	ctrl = PartsManager.createPartControl("Robotic Arm")
	ctrl.addInput("Base", 1, -1, 1)
	ctrl.addInput("Extension", 1, 0, 1)
	ctrl.addInput("Rope", 1, 0, 1)
	ctrl.addInput("Grab", 0)

var baseRTT = 0.0
var extension = 0.0
var rope = 0.0

var smStt = 0

var prevLayer
var prevMask
var grabbed : RigidBody
var prevPar

func doAGrab() -> bool:
	var bods = area.get_overlapping_bodies()
	if bods.size() > 0:
		print("haz bods")
		if bods[0] is RigidBody:
			grabbed = bods[0]
			grabbed.mode = RigidBody.MODE_KINEMATIC
			prevLayer = grabbed.collision_layer
			prevMask = grabbed.collision_mask
			grabbed.collision_layer = 0
			grabbed.collision_mask = 0
			var trsBF = grabbed.global_transform
			prevPar = grabbed.get_parent()
			prevPar.remove_child(grabbed)
			grabber_tip.add_child(grabbed)
			grabbed.global_transform = trsBF
			return true
	print("noBodz")
	return false

func release():
	grabbed.collision_layer = prevLayer
	grabbed.collision_mask = prevMask
	var trsBF = grabbed.global_transform
	grabber_tip.remove_child(grabbed)
	prevPar.add_child(grabbed)
	grabbed.global_transform = trsBF
	grabbed.mode = RigidBody.MODE_RIGID
	grabbed = null
	

var lastRope = rope

func _physics_process(delta):
	baseRTT = clamp(ctrl.getControl(0), -1, 1)
	extension = clamp(ctrl.getControl(1), 0, 1)
	rope = lerp(rope, clamp(ctrl.getControl(2), 0, 1), delta * 0.25)
	
	var grabPress = ctrl.getControl(3) == 1
	print(grabPress)
	match smStt:
		0:
			if grabPress:
				if (doAGrab()):
					smStt = 1
		1:
			if !grabPress:
				smStt = 2
		2:
			if grabPress:
				release()
				smStt = 3
		3:
			if !grabPress:
				smStt = 0
	#debug
	if OS.is_debug_build() and ControlsConfig.debugControls:
		baseRTT = clamp(baseRTT + Input.get_axis("ui_right", "ui_left") * delta * 0.2, -1, 1)
		extension = clamp(extension + Input.get_axis("AF", "AB") * delta * 0.2, 0, 1)
	#debug
	crane_base.rotation.y += baseRTT * delta * 0.5
	crane_extension.transform.origin.x = lerp(crane_arm.transform.origin.x, 0.04 + extension * 0.58, delta)
	
	processRope(delta)
	

func processRope(delta):
	var ropeLen = 0.28 + rope * 1.54
	var vec = grabber_base.global_transform.origin - grabber_tip.global_transform.origin
	var dist = vec.length()
	if dist > 2:
		grabber_tip.global_transform.origin = grabber_base.global_transform.origin + vec.normalized() * ropeLen
		grabber_tip.linear_velocity = grabber_tip.linear_velocity.limit_length(0.25)
	if (dist > ropeLen):
		var vnorm = vec.normalized()
		grabber_tip.apply_central_impulse((vnorm * (dist - ropeLen) * 980.0) * delta - grabber_tip.linear_velocity.project(vnorm))
	pass




