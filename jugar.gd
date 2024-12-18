extends Button

onready var sceneTransitionAnimation = $TransicionAnimacion/AnimationPlayer
onready var MainTrans = $TransicionAnimacion
onready var Salir = $salir
#onready var Jugar = $"./jugar"



#Una vez se clique el boton "Jugar" te mande al tablero
func _on_jugar_pressed():
	MainTrans.show()
	sceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	sceneTransitionAnimation.play("fade_in")
	yield(get_tree().create_timer(1), "timeout")
	MainTrans.hide()
	get_tree().change_scene("res://Juego.tscn") 

#Se sale del juego
func _on_salir_pressed():
	get_tree().quit(); 
