extends Node3D

@export var ChildSprites:Array[Texture]
@export var MonsterSprites:Array[Texture]
@onready var entityScene = preload("res://entity.tscn")
@onready var timer:Timer = %Timer
var candyMonster:bool = false
var score:int = 0

var rng = RandomNumberGenerator.new()

enum {CHILD, MONSTER}

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for entity : PathFollow3D in %Path3D.get_children() :
		entity.progress_ratio += delta * 0.3
		if entity.progress_ratio == 1 :
			set_process(false)
			%Restart.visible = true
			if candyMonster == true :
				%DefeatCandyMonster.visible = true
			elif entity.entity_class == CHILD :
				%DefeatChildTimeout.visible = true
			elif entity.entity_class == MONSTER :
				%DefeatMonsterTimeout.visible = true
			
			%AnimationPlayer.play("die")
			return			
			
	if Input.is_action_just_pressed("kill") && !timer.is_stopped() :
		%GPUParticles3D.emitting = true
		if %Path3D.get_child_count() > 0:
			var entity:PathFollow3D = %Path3D.get_child(0)
			if (entity.entity_class == CHILD) :
				defeat_child(entity)
				set_process(false)
				timer.stop()
				return
			entity.free()
			score += 1
			timer.wait_time *= 0.99
			
	if Input.is_action_just_pressed("candy") && !timer.is_stopped() :
		%candyParticule.restart()
		if %Path3D.get_child_count() > 0:
			var entity:PathFollow3D = %Path3D.get_child(0)
			if (entity.entity_class == MONSTER) :
				timer.stop()
				candyMonster = true
				return
			entity.free()
			score += 1
			timer.wait_time *= 0.99
	%Score.text = str(score)



func _on_timer_timeout() -> void:
	newEntity()


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
