extends Node3D


func _on_ready():
	print("Door is ready")


func open_door():
	$anim.play("open")
