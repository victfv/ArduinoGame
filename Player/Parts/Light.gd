extends KinematicBody

var type = "light"

func setLevel(level):
	match level:
		1:
			$Light/SpotLight.spot_range = 10.0
			$Light/SpotLight.spot_angle = 20.0
		2:
			$Light/SpotLight.spot_range = 20.0
			$Light/SpotLight.spot_angle = 30.0
		3:
			$Light/SpotLight.spot_range = 30.0
			$Light/SpotLight.spot_angle = 40.0
		_:
			$Light/SpotLight.spot_range = 10.0
			$Light/SpotLight.spot_angle = 20.0

func setTrs():
	rotate_y(-PI/2)
