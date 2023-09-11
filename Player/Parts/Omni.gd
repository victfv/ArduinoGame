extends KinematicBody

var type = "omni"

func setLevel(level):
	print("lvl:" + str(level))
	match level:
		1:
			$MeshInstance/OmniLight.omni_range = 10.0
			print("set to 1")
		2:
			$MeshInstance/OmniLight.omni_range = 30.0
			$MeshInstance/OmniLight.light_energy = 2.0
		3:
			$MeshInstance/OmniLight.omni_range = 60.0
			$MeshInstance/OmniLight.light_energy = 3.0
		_:
			$MeshInstance/OmniLight.omni_range = 10.0
			print("set to null")

func setTrs():
	pass
