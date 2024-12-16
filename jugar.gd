extends Button

#Una vez se clique el boton "Jugar" te mande al tablero
func _on_jugar_pressed():
	get_tree().change_scene("res://Juego.tscn") 

#Se sale del juego
func _on_salir_pressed():
	get_tree().quit(); 
