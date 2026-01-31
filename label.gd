extends Label

@export var visible_duration: float = 1.2  # Time it stays shown
@export var hidden_duration: float = 0.2   # Time it stays hidden
var timer: float = 0.0

func _process(delta):
	timer += delta
	
	if visible:
		# If the label is currently showing
		if timer >= visible_duration:
			visible = false
			timer = 0.0
	else:
		# If the label is currently hidden
		if timer >= hidden_duration:
			visible = true
			timer = 0.00
