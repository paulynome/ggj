extends Sprite2D

@export var rotation_amplitude: float = 15.0 # L'angle max du balancement (en degrés)
@export var speed: float = 8.0              # La vitesse du dandinage

var time: float = 0.0

func _process(delta):
	time += delta
	
	# Calcul de la rotation en utilisant sinus
	# On convertit les degrés en radians pour Godot
	var target_rotation = sin(time * speed) * deg_to_rad(rotation_amplitude)
	
	# Applique la rotation
	rotation = target_rotation
