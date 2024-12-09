extends Node2D

var countdown = 15  
onready var sprite = $reglas
onready var timer = $reglas/Timer 
onready var mapa = $mapa
const NUM_CASILLAS = 57
var casillas = []
var posJug1 = 0
var posJug2 = 0

var random1 = 0
var random2 = 0

var turno_jugador = 1
#var turnP3: bool = false;
#var turnP4: bool = false;

onready var jugador1 = $ficha1
onready var jugador2 = $ficha2


func _ready():
	# timer de las reglas
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	mapa.pause_mode = Node.PAUSE_MODE_STOP
	$jugador2.self_modulate.a = 0.5	
		
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

func _roll_dice(jugador_id):
	# Simular lanzamiento de los dos dados
	var movimiento = randi() % 6 + 1


	print("Jugador", jugador_id, "tiró", movimiento)

	# Mover al jugador
	if jugador_id == 1:
		posJug1 = _mover_jugador(posJug1, movimiento, jugador1)
	elif jugador_id == 2:
		posJug2 = _mover_jugador(posJug2, movimiento, jugador2)

func _mover_jugador(posicion_actual, movimiento, sprite):
	# Calcular nueva posición
	var nueva_posicion = posicion_actual + movimiento
	if nueva_posicion >= NUM_CASILLAS:
		print("¡El jugador ha llegado al final!")
		nueva_posicion = NUM_CASILLAS - 1  # Mantener dentro del tablero

	# Mover el sprite a la nueva casilla
	sprite.position = casillas[nueva_posicion].position
	print("Nueva posición del jugador:", nueva_posicion)
	return nueva_posicion


func _on_jugador1_pressed():
	if turno_jugador == 1:
		_roll_dice(1)  # Jugador 1 lanza los dados
		$jugador1.self_modulate.a = 0.5
		$jugador2.self_modulate.a = 1
		turno_jugador = 2  # Pasa el turno al jugador 2place with function body.


func _on_jugador2_pressed():
	if turno_jugador == 2:
		_roll_dice(2)  # Jugador 1 lanza los dados
		$jugador2.self_modulate.a = 0.5
		$jugador1.self_modulate.a = 1
		turno_jugador = 1  # Pasa el turno al jugador 2place with function body.
