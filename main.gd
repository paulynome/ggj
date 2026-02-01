extends Node3D

@export var ChildSprites:Array[Texture]
@export var MonsterSprites:Array[Texture]
@onready var entityScene = preload("res://entity.tscn")
@onready var timer:Timer = %Timer


@export var gunSounds:Array[AudioStream]
@export var monsterSounds:Array[AudioStream]
@export var kidSounds:Array[AudioStream]
@export var candySounds:Array[AudioStream]

var candyMonster:bool = false
var score:int = 0

var rng = RandomNumberGenerator.new()

enum {CHILD, MONSTER}
var speed = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func newEntity() -> void:
	var entity = entityScene.instantiate()
	var randomi:int = rng.randi_range(0,1)
	match randomi:
		0:
			entity.entity_class = CHILD
			entity.texture = ChildSprites.pick_random()
		1:
			entity.entity_class = MONSTER
			entity.texture = MonsterSprites.pick_random()
		_:
			assert(false, "non implémenté")
	%Path3D.add_child(entity)
	pass

func defeat_child(killedEntity:PathFollow3D) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(%Camera3D, "position", killedEntity.position + Vector3(0,1,-1.5), 1)
	tween.parallel().tween_property(killedEntity, "rotation", Vector3(deg_to_rad(-85),0,0), 1)
	tween.parallel().tween_property(killedEntity, "position", killedEntity.position + Vector3(0,1,0), 1)
	tween.parallel().tween_property(%Camera3D, "rotation", Vector3(-1,0,0), 1)
	%DefeatChild.visible = true
	%Restart.visible = true


func update_difficulty(delta:float) -> void:
	# enemy spawn rate increase with score
	if score >= 800 :
		timer.wait_time *= 0.99
	elif score >= 600 :
		timer.wait_time = 0.5
	elif score >= 500 :
		timer.wait_time = 0.6
	elif score >= 200:
		timer.wait_time = 0.8
	elif score >= 100 :
		timer.wait_time = 1
	elif score >= 50 :
		timer.wait_time = 1.2
	elif score >= 30 :
		timer.wait_time = 1.5
	elif score >= 10 :
		timer.wait_time = 1.8
	else :	
		pass

	# enemy speed
	if score >= 3000 :
		speed *= 1.01
	elif score >= 2000:
		speed = 0.7
	elif score >= 1000 :
		speed = 0.6
	elif score >= 800 :
		speed = 0.5
	elif score >= 600 :
		speed = 0.45
	elif score >= 500 :
		speed = 0.4
	elif score >= 400 :
		speed = 0.35
	elif score >= 300 :
		speed = 0.3
	elif score >= 100 :
		speed = 0.2
	else :	
		speed = 0.2
	
	#faster music
	if score >= 1000 :
		$Music.pitch_scale = 2.0
	elif score >= 800 :
		$Music.pitch_scale = 1.7
	elif score >= 600 :
		$Music.pitch_scale = 1.5
	elif score >= 500 :
		$Music.pitch_scale = 1.3
	elif score >= 300 :
		$Music.pitch_scale = 1.1
	elif score >= 200 :
		$Music.pitch_scale = 1.0
	elif score >= 100 :
		$Music.pitch_scale = 0.9
	else :
		pass


	# on emit rain si seulement on est entre 300 et 500 ou 700 et 900 + ou moins 1000
	var scoreMod1000 = score % 1000
	if (scoreMod1000 >= 300 and scoreMod1000 < 500) or (scoreMod1000 >= 700 and scoreMod1000 < 900) :
		$rain.emitting = true
	else :
		$rain.emitting = false
	
	# tous les 200 points on perd en luminosité
	

	




	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_difficulty(delta)
	for entity : PathFollow3D in %Path3D.get_children() :
		if not entity.is_dead() :
			entity.progress_ratio += delta * speed
		if entity.progress_ratio == 1 :
			set_process(false)
			%Restart.visible = true
			if candyMonster == true :
				%DefeatCandyMonster.visible = true
				$monsterAudio.stream = monsterSounds.pick_random()
				$monsterAudio.play()
			elif entity.entity_class == CHILD :
				%DefeatChildTimeout.visible = true
				$kidsAudio.stream = kidSounds.pick_random()
				$kidsAudio.play()
			elif entity.entity_class == MONSTER :
				%DefeatMonsterTimeout.visible = true
				$monsterAudio.stream = monsterSounds.pick_random()
				$monsterAudio.play()
			%AnimationPlayer.play("die")
			return			
			
	if Input.is_action_just_pressed("kill") && !timer.is_stopped() :
		var mesh = %GPUParticles3D.draw_pass_1
	
		var mat = mesh.surface_get_material(0) as StandardMaterial3D
	
		if mat:
			mat.albedo_color = Color(randf(), randf(), randf(), 1.0)

		%GPUParticles3D.emitting = true
		$gunAudio.stream = gunSounds.pick_random()
		$gunAudio.play()
		if %Path3D.get_child_count() > 0:
			var entity:PathFollow3D = %Path3D.get_child(0)
			if (entity.entity_class == CHILD) :
				defeat_child(entity)
				set_process(false)
				timer.stop()
				return
			%Path3D.remove_child(entity)
			$cimetiere.add_child(entity)
			entity.die()
			# entity.free()
			score += 10
			
	if Input.is_action_just_pressed("candy") && !timer.is_stopped() :
		var mesh = %candyParticule.draw_pass_1
	
		var mat = mesh.surface_get_material(0) as StandardMaterial3D
	
		if mat:
			mat.albedo_color = Color(randf(), randf(), randf(), 1.0)

		%candyParticule.restart()
		$candyAudio.stream = candySounds.pick_random()
		$candyAudio.play()
		if %Path3D.get_child_count() > 0:
			var entity:PathFollow3D = %Path3D.get_child(0)
			if (entity.entity_class == MONSTER) :
				timer.stop()
				candyMonster = true
				return
			# entity.die()
			%Path3D.remove_child(entity)
			$cimetiere.add_child(entity)
			entity.bye()
			# entity.free()
			score += 10
	%Score.text = str(score)



func _on_timer_timeout() -> void:
	newEntity()


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
