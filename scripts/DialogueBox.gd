extends CanvasLayer
class_name DialogueBox 

signal dialogue_finished

var full_text: String = ""
var current_char: int = 0
var display_timer: Timer
var label: Label

func _init(text_to_display: String):
	full_text = text_to_display
	
	# 1. Le Panel (Ton design blanc & noir)
	var panel = Panel.new()
	add_child(panel)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color.WHITE
	style.set_border_width_all(5)
	style.border_color = Color.BLACK
	panel.add_theme_stylebox_override("panel", style)
	
	panel.set_begin(Vector2(500, 800)) 
	panel.set_end(Vector2(1350, 1000))
	
	# 2. Le Label (Initialement vide)
	label = Label.new()
	panel.add_child(label)
	label.text = "" # On commence avec rien
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color.BLACK)
	label.add_theme_font_size_override("font_size", 35)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_WIDTH, 20)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# 3. Le Timer pour les lettres
	display_timer = Timer.new()
	add_child(display_timer)
	display_timer.wait_time = 0.03 # Vitesse des lettres (plus petit = plus rapide)
	display_timer.timeout.connect(_on_timer_timeout)

func _ready():
	display_timer.start()

func _on_timer_timeout():
	if current_char < full_text.length():
		label.text += full_text[current_char]
		current_char += 1
	else:
		display_timer.stop()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		# Cas 1 : Le texte est encore en train de défiler -> On affiche tout d'un coup
		if current_char < full_text.length():
			label.text = full_text
			current_char = full_text.length()
			display_timer.stop()
		# Cas 2 : Tout est affiché -> On ferme la boîte
		else:
			dialogue_finished.emit()
			queue_free()
