extends Node2D

var countdown = 15  
onready var sprite = $reglas
onready var timer = $reglas/Timer 
onready var mapa = $mapa
const NUM_CASILLAS = 57
var casillas = []
var posJug1 = 0
var posJug2 = 0
var monedasJug1 = 0
var monedasJug2 = 0
var estatsJug1 = [3, -2, -1]
var estatsJug2 = [1, 1, 1]
var contPosada = 2
var contJaula = 2
var contLaberinto = 3
var pausaJug1 = false
var pausaJug2 = false



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
	
	

	print("Jugador", jugador_id, "tiró", movimiento)

	# Mover al jugador
	if jugador_id == 1:
		posJug1 = _mover_jugador(posJug1, movimiento, jugador1, 1)
	elif jugador_id == 2:
		posJug2 = _mover_jugador(posJug2, movimiento, jugador2, 2)

func _mover_jugador(posicion_actual, movimiento, sprite, id):
	# Calcular nueva posición
	if id == 1:
		$jugador1.self_modulate.a = 0.5
		$jugador2.self_modulate.a = 1
		
	elif id == 2:
		$jugador2.self_modulate.a = 0.5
		$jugador1.self_modulate.a = 1
	var nueva_posicion = posicion_actual + movimiento
	if nueva_posicion == 17:
		nueva_posicion = 7
		print("Me lleva la marea")
	elif nueva_posicion == 7:
		nueva_posicion =17
		print("Me lleva la marea")
	if nueva_posicion == 9 || nueva_posicion == 21 || nueva_posicion == 31 || nueva_posicion == 40 || nueva_posicion ==50:
		print("¡Oca por oca y tiro por que me toca!")
		if id == 1:
			turno_jugador = 1
			$jugador2.self_modulate.a = 0.5
			$jugador1.self_modulate.a = 1	
		elif id == 2:
			turno_jugador = 2
			$jugador1.self_modulate.a = 0.5
			$jugador2.self_modulate.a = 1
	if nueva_posicion == 19: 
		if id == 1:
			pausaJug1 = true
		elif id == 2:
			pausaJug2 = true
	
	if posicion_actual == 19 && (pausaJug1 == true || pausaJug2 == true ):
		if id == 1:
			pausaJug1 = true
		elif id == 2:
			pausaJug2 = true
	if nueva_posicion > NUM_CASILLAS:	
		retroceder=nueva_posicion - NUM_CASILLAS
		nueva_posicion = nueva_posicion - retroceder
		retroceder=0
			
	if nueva_posicion== NUM_CASILLAS:
		print("¡El jugador ha llegado al final!")
		nueva_posicion = NUM_CASILLAS - 1  # Mantener dentro del tablero

	# Mover el sprite a la nueva casilla
	sprite.position = casillas[nueva_posicion].position
	print("Nueva posición del jugador", id ,"  " ,nueva_posicion+1)
	return nueva_posicion


func _on_jugador1_pressed():
	if turno_jugador == 1:
		turno_jugador = 2 # Pasa el turno al jugador 2place with function bod
		_roll_dice(1)  # Jugador 1 lanza los dados y.


func _on_jugador2_pressed():
	if turno_jugador == 2:
		turno_jugador = 1  # Pasa el turno al jugador 2place with function body.
		_roll_dice(2)  # Jugador 1 lanza los dados
