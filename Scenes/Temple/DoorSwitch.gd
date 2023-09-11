extends Area

export (NodePath) var doorPath
onready var door = get_node(doorPath)


var once = false
func _on_Area_body_entered(body):
	if !once:
		door.open()
