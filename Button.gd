extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.




func _on_Button_pressed():
	# Carga la segunda escena
	var nueva_escena = load("res://Juego.tscn")
	get_tree().change_scene_to(nueva_escena)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
