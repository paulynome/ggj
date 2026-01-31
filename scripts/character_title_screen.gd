extends CharacterBody3D

@export var speed: float = 5.0

func _process(delta):
	# 1. Vérifier si l'une des touches est pressée
	# print(self.position)
	if Input.is_action_pressed("ui_accept"):
		# On récupère la direction avant locale du personnage (-z)
		var direction = -transform.basis.z
		
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Si on ne touche à rien, on s'arrête net
		velocity.x = 0
		velocity.z = 0

	# 2. Appliquer le mouvement (sans gravité, donc pas de velocity.y)
	move_and_slide()
