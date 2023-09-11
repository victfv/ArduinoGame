extends KinematicBody


func open():
	$AnimationPlayer.play("Open")
	$"../WaterWheel".set_process(true)
	$"../Particles".emitting = true
