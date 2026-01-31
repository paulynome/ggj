extends Node3D

@export var ChildSprites:Array[Texture]
@export var MonsterSprites:Array[Texture]
@onready var entityScene = preload("res://entity.tscn")
@onready var timer:Timer = %Timer

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for entity : PathFollow3D in %Path3D.get_children() :
		entity.progress_ratio += delta * 0.3
		if entity.progress_ratio == 1 :
			get_tree().change_scene_to_file("res://menu.tscn")
			
			
	if Input.is_action_just_pressed("kill") :
		if %Path3D.get_child_count() > 0:
			var entity:PathFollow3D = %Path3D.get_child(0)
			if (entity.entity_class == CHILD) :
				get_tree().change_scene_to_file("res://menu.tscn")
			entity.free()
			
	if Input.is_action_just_pressed("candy") :
		if %Path3D.get_child_count() > 0:
			var entity:PathFollow3D = %Path3D.get_child(0)
			if (entity.entity_class == MONSTER) :
				get_tree().change_scene_to_file("res://menu.tscn")
			entity.free()
			
	pass


func _on_timer_timeout() -> void:
	newEntity()
