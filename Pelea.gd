extends Node2D

signal return_value

var resultadoJugador=0
var resultadoRival=0
var dano = 0

onready var jugador1 = $ficha1
onready var jugador2 = $ficha2
onready var bot = $bot
onready var jefe = $jefe
var estatsJug = [0, 0, 20]
var estatRival = []


onready var jugador = $jugador
onready var rival = $rival
onready var posJefe = $posJefe

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
	bot.position = rival.position
	jefe.position = posJefe.position
	$ataqueJugador.text = str(estatsJug[0])
	$defensaJugador.text = str(estatsJug[1])
	$vidaJugador.text = str(estatsJug[2])
	
	if id == 2: 
		jugador1.visible = true
		jugador2.visible = false
	elif id == 1:
		jugador2.visible = true
		jugador1.visible = false
		
	if tipoBot == 0:
		estatRival = [0 ,0 ,10]
		bot.visible = true
		jefe.visible = false
	elif tipoBot == 1:
		estatRival = [0, 0, 30]
		bot.visible = false
		jefe.visible = true
	$ataqueRival.text = str(estatRival[0])
	$defensaRival.text = str(estatRival[1])
	$vidaRival.text = str(estatRival[2])
		

func _on_Button_pressed():
	
	$Button.disabled = true  

	if turnoJugador:
		# Lanzar dado izquierdo (jugador)

		_roll_dice_jugador()
		yield(get_tree().create_timer(0.5), "timeout")
		
		# Lanzar dado derecho (bot)
		_roll_dice_rival()
		yield(get_tree().create_timer(0.5), "timeout")
		
		# Mostrar resultados
		$dado1.animation = str(resultadoJugador)  # Dado izquierdo para jugador
		$dado2.animation = str(resultadoRival)    # Dado derecho para bot
		
		$ataqueJugador.text = str(resultadoJugador)
		$defensaRival.text = str(resultadoRival)
		yield(get_tree().create_timer(1), "timeout")
		
		# Calcular daño
		dano = resultadoJugador - resultadoRival
		
		if dano > 0:
			$danoTotal.text = str(dano) 
			estatRival[2] -= dano
			yield(get_tree().create_timer(0.7), "timeout")
			if estatRival[2] < 0:
				$vidaRival.text = "0"
			else:
				$vidaRival.text = str(estatRival[2])
				$danoTotal.text = "0"
	
		_reset_valores()  # Reset visual
		yield(get_tree().create_timer(0.8), "timeout")
		$modo.text = "DEFENSA"
		turnoJugador = false

	else:

		# Lanzar dado derecho (bot)
		_roll_dice_rival()
		yield(get_tree().create_timer(1), "timeout")
		
		# Lanzar dado izquierdo (jugador)
		_roll_dice_jugador()
		yield(get_tree().create_timer(1), "timeout")
		
		# Mostrar resultados
		$dado1.animation = str(resultadoJugador)  # Dado izquierdo para jugador
		$dado2.animation = str(resultadoRival)    # Dado derecho para bot
		
		$ataqueRival.text = str(resultadoRival)
		$defensaJugador.text = str(resultadoJugador)
		yield(get_tree().create_timer(1), "timeout")
		
		# Calcular daño
		dano = resultadoRival - resultadoJugador
		if dano > 0:
			$danoTotal.text = str(dano)
			estatsJug[2] -= dano
			yield(get_tree().create_timer(0.7), "timeout")
			if estatsJug[2] < 0:
				$vidaJugador.text = "0"
			else:
				$vidaJugador.text = str(estatsJug[2])
				$danoTotal.text = "0"
		
		_reset_valores()  # Reset visual

		$modo.text = "ATAQUE"
		turnoJugador = true

	# Verificar si alguien ganó
	if estatRival[2] <= 0:
		gana = true
		emit_signal("return_value", gana)
	elif estatsJug[2] <= 0:
		gana = false
		emit_signal("return_value", gana)
	
	$Button.disabled = false



func _roll_dice_jugador():
	# Simular lanzamiento de dado para el jugador (izquierda)
	resultadoJugador = randi() % 6 + 1
	$dado1.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado1.animation = str(resultadoJugador)

func _roll_dice_rival():
	# Simular lanzamiento de dado para el bot (derecha)
	resultadoRival = randi() % 6 + 1
	$dado2.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado2.animation = str(resultadoRival)
	
func _reset_valores():
	yield(get_tree().create_timer(0.6), "timeout")  # Pequeño tiempo de espera
	$ataqueJugador.text = "0"
	$defensaRival.text = "0"
	$ataqueRival.text = "0"
	$defensaJugador.text = "0"

	
