extends MeshInstance

var type = "camera"

export var invertCam = false

func _ready():
	PartsManager.connect("changeCam", self, "_on_cam_activate")
	PartsManager.registerPart(self)
	if invertCam:
		$CameraBase/CameraSphere/Camera.rotation.z = PI

func activate():
	$CameraBase/CameraSphere/Camera.current = true
	set_process(true)

func deactivate():
	$CameraBase/CameraSphere/Camera.current = false
	set_process(false)

func _on_cam_activate(cam):
	if cam != self:
		deactivate()
	else:
		activate()

const clampRot = PI/2.1

func _process(delta):
	var inv = float(invertCam) * -1 + float(!invertCam) * 1
	$CameraBase.rotate_y(delta *  clamp(PartsManager.camControls.getControl(0),-1,1))
	$CameraBase/CameraSphere.rotation.z = clamp($CameraBase/CameraSphere.rotation.z + inv * clamp(PartsManager.camControls.getControl(1), -1, 1) * delta, -clampRot, clampRot)
