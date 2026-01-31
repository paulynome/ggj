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
