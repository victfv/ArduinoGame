extends MeshInstance


func _ready():
	set_process(false)

var rotSp = 0.0

func _process(delta):
	rotSp = min(rotSp + delta * 0.15, 0.6)
	rotate_x(-delta * rotSp)
