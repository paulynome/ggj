extends PathFollow3D

@export_enum("Child", "Monster") var entity_class: int
@export var texture: Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite:Sprite3D = get_node("Sprite3D")
	sprite.material_override.albedo_texture = texture
	sprite.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var dead = false

func is_dead() -> bool:
	return dead

func die() -> void:
	if not dead:
		dead = true
		var sprite = $Sprite3D
		var tween = create_tween().set_parallel(true)
		
		# 1. THE ANTICIPATION: Scale up and turn white (Overcharge)
		var ant_tween = create_tween().set_parallel(true)
		ant_tween.tween_property(sprite, "scale", sprite.scale * 1.4, 0.1)
		ant_tween.tween_property(sprite, "modulate", Color(10, 10, 10, 1), 0.1) # Overbright
		await ant_tween.finished

		# 2. THE EXPLOSION: Trigger the random colored particles
		var particles = $GPUParticles3D
		# Change material color to match the monster's "blood" or soul
		# var mat = particles.draw_pass_1.surface_get_material(0) as StandardMaterial3D
		# mat.albedo_color = Color(randf(), randf(), randf(), 1.0)
		var mat = particles.draw_pass_1.surface_get_material(0) as StandardMaterial3D
		
		# Define our two target colors
		var color_orange = Color(1.0, 0.5, 0.0) # Bright Orange
		var color_blood = Color(0.6, 0.0, 0.0)  # Darker, visceral Red
		
		# Pick a random point between them (0.0 to 1.0)
		var weight = randf() 
		mat.albedo_color = color_orange.lerp(color_blood, weight)
		mat.albedo_color.a = 0.5
		
		# If you want it to look extra "meaty", boost the red bias:
		# mat.albedo_color = color_orange.lerp(color_blood, randf_range(0.4, 1.0))

		particles.emitting = true
		# 3. THE SNAP: Vanish the sprite instantly
		sprite.visible = false
		
		# 4. THE SHAKE: Shake the camera (if you have one) or the parent
		# For a game jam, we'll shake the Sprite's parent node slightly
		var shake_tween = create_tween()
		for i in range(5):
			var intensity = 0.2
			shake_tween.tween_property(sprite, "position", get_parent().position + Vector3(randf()-0.5, randf()-0.5, 0) * intensity, 0.02)
		
		# 5. SOUND: If you have a sound list
		# $AudioStreamPlayer.play() 

		await get_tree().create_timer(1.0).timeout # Let particles settle
		queue_free()

func bye() -> void:
	if not dead:
		dead = true
		var tween = create_tween().set_parallel(true)
		
		# Move the Sprite3D on the X axis over 2 seconds
		# We use global_position or position depending on your setup
		tween.tween_property($Sprite3D, "position:x", $Sprite3D.position.x + 10.0, 0.5)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		# 3. Fade out
		tween.tween_property($Sprite3D, "modulate:a", 0.0, 0.12)
		
		# 4. Add a "Bye-bye" dandinage (Waddle)
		# This creates a quick back-and-forth tilt during the exit
		
		# 5. Wait for the exit to finish
		await tween.finished
		queue_free()
