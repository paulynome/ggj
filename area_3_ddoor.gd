extends Area3D


func _on_body_entered(body):
	if body.is_in_group("player"):
		var door = get_parent().get_node("Door")
		door.open_door()
