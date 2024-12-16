extends Node2D

# Variables utilizadas en Pelea.gd
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
	
	# En este IF larguisimo se establece que si es el turno del jugador, sera el quien lanze el dado de ataque, 
	# mientras que el enemigo lanzara su dado de defensa
	if turnoJugador:
		# Lanzar dado del jugador

		_roll_dice_jugador()
		yield(get_tree().create_timer(0.5), "timeout")
		
		# Lanzar dado del enemigo
		_roll_dice_rival()
		yield(get_tree().create_timer(0.5), "timeout")
		
		# Mostrar resultados con la animacion chulisima esa
		$dado1.animation = str(resultadoJugador)  # Dado izquierdo para jugador
		$dado2.animation = str(resultadoRival)    # Dado derecho para bot
		
		$ataqueJugador.text = str(resultadoJugador)
		$defensaRival.text = str(resultadoRival)
		yield(get_tree().create_timer(1), "timeout")
		
		# Calcular daño dependiendo de que haya tirado el jugador y el enemigo
		dano = resultadoJugador - resultadoRival
		
		# Si el daño resultante es mas grande que 0, se hace esa cantidad de daño al enemigo, sinó, termina el turno
		if dano > 0:
			$danoTotal.text = str(dano) 
			estatRival[2] -= dano
			yield(get_tree().create_timer(0.7), "timeout")
			if estatRival[2] < 0:
				$vidaRival.text = "0"
			else:
				$vidaRival.text = str(estatRival[2])
				$danoTotal.text = "0"
		
		# Se resetean los valores a 0 i pasa el turno al enemigo
		_reset_valores()  # Reset visual
		yield(get_tree().create_timer(0.8), "timeout")
		$modo.text = "DEFENSA"
		turnoJugador = false

	# 2da parte del IF larguisimoeste. Si antes era el turno del Jugador, 
	# ahora sera el enemigo quien lanze el dado de ataque, 
	else:
		# Lanzar dado del enemigo
		_roll_dice_rival()
		yield(get_tree().create_timer(1), "timeout")
		
		# Lanzar dado del jugador
		_roll_dice_jugador()
		yield(get_tree().create_timer(1), "timeout")
		
		# Mostrar resultados con la animación to chula esa dependiendo del resultado de cada uno
		$dado1.animation = str(resultadoJugador)  # Dado izquierdo para jugador
		$dado2.animation = str(resultadoRival)    # Dado derecho para bot
		
		$ataqueRival.text = str(resultadoRival)
		$defensaJugador.text = str(resultadoJugador)
		yield(get_tree().create_timer(1), "timeout")
		
		# Calcular daño dependiendo de que haya tirado el jugador y el enemigo
		dano = resultadoRival - resultadoJugador
		
		# Si el daño resultante es mas grande que 0, se hace esa cantidad de daño al enemigo, sinó, termina el turno		
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

	# Verificar quien gana dependiendo de a quien le haya llegado la vida a 0
	if estatRival[2] <= 0:
		gana = true
		emit_signal("return_value", gana)
	elif estatsJug[2] <= 0:
		gana = false
		emit_signal("return_value", gana)
	
	$Button.disabled = false


	# Lanzamiento de dado para el jugador 
func _roll_dice_jugador():
	resultadoJugador = randi() % 6 + 1
	$dado1.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado1.animation = str(resultadoJugador)
	
# Lanzamiento de dado para el bot (enemigo)
func _roll_dice_rival():
	resultadoRival = randi() % 6 + 1
	$dado2.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado2.animation = str(resultadoRival)
	
# Una vez termina el turno, las variables de Jugador y Bot, se restablecen a 0 
func _reset_valores():
	yield(get_tree().create_timer(0.6), "timeout")  # Pequeño tiempo de espera
	$ataqueJugador.text = "0"
	$defensaRival.text = "0"
	$ataqueRival.text = "0"
	$defensaJugador.text = "0"

	
