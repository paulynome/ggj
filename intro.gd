extends Node2D



func _ready():
	# premier dialogue:
	# bonjour cher telespectateurs:
	var dialogue1 = DialogueBox.new("Hi dear viewers, we are on air for worrying breaking news : this halloween we are invaded by monsters !")
	add_child(dialogue1)
	dialogue1.connect("dialogue_finished", Callable(self, "_on_dialogue1_finished"))

func _on_dialogue1_finished():
	# deuxieme dialogue:
	var dialogue2 = DialogueBox.new("If you see them, you are allowed to kill them, but be careful, do not hurt any innocent people, they just want candy for halloween!")
	add_child(dialogue2)
	dialogue2.connect("dialogue_finished", Callable(self, "_on_dialogue2_finished"))
func _on_dialogue2_finished():
	# troisieme dialogue:
	var dialogue3 = DialogueBox.new("Good luck to all of you, and stay safe!")
	add_child(dialogue3)
	dialogue3.connect("dialogue_finished", Callable(self, "_on_dialogue3_finished"))
func _on_dialogue3_finished():
	# Lol je ne crois pas à ces histoires de monstres... je vais aller me coucher.
	var dialogue4 = DialogueBox.new("LOL.. I don't really believe in this monsters story... ahah!")
	add_child(dialogue4)
	dialogue4.connect("dialogue_finished", Callable(self, "_on_dialogue4_finished"))

func _on_dialogue4_finished():
	# lancer l'animation du monstre qui va tuer le pres:
	$anim.play("monster_attack")

	await($anim.animation_finished)
	get_tree().change_scene_to_file("res://titlescreen.tscn")
