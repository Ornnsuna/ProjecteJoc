extends Node2D

var countdown = 1  
onready var sprite = $reglas
onready var win = $win
onready var timer = $reglas/Timer 
onready var mapa = $mapa
const NUM_CASILLAS = 57
var casillas = []
var posJug1 = 0
var posJug2 = 0

var monedasJug1 = 0
var monedasJug2 = 0

var pausaJug1 = false
var pausaJug2 = false
var contPausa1 = 0
var contPausa2 = 0
var pelea
var gana
var resultado = false

var tipoRival = 0

var retroceder = 0

var movimiento = RandomNumberGenerator.new()


var turno_jugador = 1
#var turnP3: bool = false;
#var turnP4: bool = false;

onready var jugador1 = $ficha1
onready var jugador2 = $ficha2


func _ready():
	# timer de las reglas
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	$jugador1.disabled = true
	$jugador2.disabled = true	
	win.visible = false
	mapa.pause_mode = Node.PAUSE_MODE_STOP
	
	randomize()
	$jugador2.self_modulate.a = 0.5	
	$jugador1.self_modulate.a = 1
	# colocacion del array de los hijos node2D
	for child in get_children():
		if child is Node2D:
			var child_name = int(child.name) if str(child.name).is_valid_integer() else -1
			if child_name in range(1,58):
				casillas.append(child)
				
	jugador1.position = casillas[0].position
	jugador2.position = casillas[0].position
	
	
func _on_timer_timeout():
	# timer de las reglas
	countdown -= 1
	if countdown <= 0:
		sprite.visible = false  
		timer.stop()
		mapa.pause_mode = Node.PAUSE_MODE_PROCESS
		$jugador1.disabled = false
		$jugador2.disabled = false
		
func _roll_dice(jugador_id):
	# Simular lanzamiento de dado
	var movimiento = randi() % 6 + 1
	
	$dado.animation = "rolling"
	yield(get_tree().create_timer(0.4), "timeout")
	$dado.animation = str(movimiento)
	
	

	print("Jugador ", jugador_id, " tiró ", movimiento)

	# Mover al jugador
	
	if jugador_id == 1:		
		posJug1 = _mover_jugador(posJug1, movimiento, jugador1, 1)
			
	elif jugador_id == 2:
		posJug2 = _mover_jugador(posJug2, movimiento, jugador2, 2)

			
			
func _mover_jugador(posicion_actual, movimiento, sprite, id):
	
	# Calcular nueva posición
	var nueva_posicion = posicion_actual + movimiento
	
	#CORRIENTE BAJADA
	if nueva_posicion == 17:
		nueva_posicion = 7
		print("Me lleva la Corriente")
	
	#CORRIENTE SUBIDA	
	elif nueva_posicion == 7:
		nueva_posicion =17
		print("Me lleva la Corriente")
		
	#DOBLE TIRADA (OCA)
	if nueva_posicion == 9 || nueva_posicion == 21 || nueva_posicion == 31 || nueva_posicion == 40 || nueva_posicion ==50:
		print("¡Oca por oca y tiro por que me toca!")
		if id == 1:
			turno_jugador = 1
			$jugador2.self_modulate.a = 0.5
			$jugador1.self_modulate.a = 1	
		elif id == 2:
			turno_jugador = 2
			$jugador2.self_modulate.a = 1
			$jugador1.self_modulate.a = 0.5
		
	#CASILLAS DE ESPERA		
	if nueva_posicion == 19 || nueva_posicion == 29 || nueva_posicion == 44: 
		
		if id == 1:
			pausaJug1 = true
			contPausa1 = cuenta_Espera(nueva_posicion)
			if nueva_posicion == 19:
				monedasJug1 += 1
		elif id == 2:
			pausaJug2 = true
			contPausa2 = cuenta_Espera(nueva_posicion)
			if nueva_posicion == 19:
				monedasJug2 += 1
	
	# MUERTE
	if nueva_posicion == 52:
		print("LA MUERTE jugador ", id)
		nueva_posicion = 0;
	
	#PELEA CONTRA BOT
	if nueva_posicion in [4, 12, 15, 23, 28, 34, 42, 46, 51]:
		pelea = preload("res://Pelea.tscn")
		gana = pelea.instance()
		gana.some_variable = "0"
		gana.id = turno_jugador
		tipoRival = 0
		gana.tipoBot = tipoRival
		add_child(gana)
		gana.connect("return_value", self, "_on_scene_b_return_value")
		yield(gana, "return_value")  # Esperar a que se devuelva el resultado
		
		resultado = gana.gana
		# Si resultado es false, volver a casilla 0
		if resultado == false:
			print("Resultado es falso: vuelves a la casilla 0")
			nueva_posicion = 0
		if resultado == true:
			print("Resultado es verdadero: ganas una moneda")
			if id == 1:
				monedasJug1 += 1

			elif id == 2:
				monedasJug2 += 1

	
	
	#PELEA CONTRA JEFE
	if nueva_posicion >= NUM_CASILLAS-1:
		# Lógica de la última casilla (ya existente)
		pelea = preload("res://Pelea.tscn")
		gana = pelea.instance()
		gana.some_variable = "0"
		gana.id = turno_jugador
		tipoRival = 1
		gana.tipoBot = tipoRival
		add_child(gana)
		gana.connect("return_value", self, "_on_scene_b_return_value")
		yield(gana, "return_value")  # Esperar resultado
		yield(get_tree().create_timer(0.4), "timeout")
		
		resultado = gana.gana
		
		if resultado == false:
			print("Resultado final es falso: vuelves a la casilla 0")
			nueva_posicion = 0
		elif resultado == true:
			print("Ganas")
			win.visible == true
			$jugador1.disabled = true
			$jugador2.disabled = true
	
	
	# Mover el sprite a la nueva casilla
	$monedas1.text = str(monedasJug1)
	$monedas2.text = str(monedasJug2)
	sprite.position = casillas[nueva_posicion].position
	print("Nueva posición del jugador ", id ,"  ", nueva_posicion + 1)
	
	
	return nueva_posicion
	


func _on_jugador1_pressed():
	if pausaJug1 == true:
		print("Jugador 1 está en pausa durante ", contPausa1, " turnos restantes.")
		contPausa1 -= 1
		if contPausa1 <= 0:
			pausaJug1 = false
		turno_jugador = 2  # Pasar el turno al siguiente jugador
		$jugador1.self_modulate.a = 0.5
		$jugador2.self_modulate.a = 1
		return

	if turno_jugador == 1:
		turno_jugador = 2
		_roll_dice(1)
		$jugador1.self_modulate.a = 0.5
		$jugador2.self_modulate.a = 1
		
		


func _on_jugador2_pressed():
	if pausaJug2 == true:
		print("Jugador 2 está en pausa durante ", contPausa2, " turnos restantes.")
		contPausa2 -= 1
		if contPausa2 <= 0:
			pausaJug2 = false
		turno_jugador = 1  # Pasar el turno al siguiente jugador
		$jugador2.self_modulate.a = 0.5
		$jugador1.self_modulate.a = 1
		
	if turno_jugador == 2:
		turno_jugador = 1
		_roll_dice(2)
		$jugador2.self_modulate.a = 0.5
		$jugador1.self_modulate.a = 1
	
func cuenta_Espera(nueva_posicion):
	if nueva_posicion == 19:
		return 1
	elif nueva_posicion == 29:
		return 3
	elif nueva_posicion == 44:
		return 2
		
func _on_scene_b_return_value(result: bool):
		# Destruir la escena B si ya no es necesaria
	remove_child(gana)	

