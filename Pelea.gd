extends Node2D

signal return_value

var resultadoJugador=0
var resultadoRival=0
var dano = 0

onready var jugador1 = $ficha1
onready var jugador2 = $ficha2
var estatsJug = [0, 0, 20]
var estatRival = [0, 0, 10]
var estatJefe = [0, 0, 30]

onready var jugador = $jugador
onready var rival = $rival

var some_variable: String
var tipoBot
var id
var gana = false

var cont = 0
var puntosJug
var puntosBot

var turnoJugador = true


func _ready():
	jugador1.position = jugador.position
	jugador2.position = jugador.position
	$ataqueJugador.text = str(estatsJug[0])
	$defensaJugador.text = str(estatsJug[1])
	$vidaJugador.text = str(estatsJug[2])
	if id == 2: 
		jugador1.visible = true
		jugador2.visible = false
		
	if id == 1:
		jugador2.visible = true
		jugador1.visible = false
		

func _on_Button_pressed():
	
		if turnoJugador == true:
			_roll_dice_jugador()
			yield(get_tree().create_timer(0.2), "timeout")
			_roll_dice_rival()
			$ataqueJugador.text = str(resultadoJugador)
			yield(get_tree().create_timer(0.2), "timeout")
			$defensaRival.text = str(resultadoRival)
			yield(get_tree().create_timer(0.4), "timeout")
			dano = resultadoJugador - resultadoRival
			if dano > 0:
				estatRival[2] - dano
				$vidaRival.text = estatRival[2]
			dano = 0
			turnoJugador = false
		elif turnoJugador == false:
			_roll_dice_jugador()
			yield(get_tree().create_timer(0.2), "timeout")
			_roll_dice_rival()
			$defensaRivalJugador.text = str(resultadoJugador)
			yield(get_tree().create_timer(0.2), "timeout")
			$ataqueRivalRival.text = str(resultadoRival)
			yield(get_tree().create_timer(0.4), "timeout")
			dano = resultadoRival - resultadoJugador
			if dano > 0:
				estatRival[2] - dano
				$vidaJugador.text = estatRival[2]
			dano = 0
			turnoJugador = true

		


		emit_signal("return_value", gana)



func _roll_dice_jugador():
	# Simular lanzamiento de dado
	var resultadoJugador = randi() % 6 + 1
	$dado.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado.animation = str(resultadoJugador)

func _roll_dice_rival():
	var resultadoRival = randi() % 6 + 1
	$dado.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado.animation = str(resultadoRival)

	
