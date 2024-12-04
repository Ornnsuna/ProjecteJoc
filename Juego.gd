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

var turnP1: bool = true;
var turnP2: bool = false;
#var turnP3: bool = false;
#var turnP4: bool = false;

onready var jugador1 = $ficha1
onready var jugador2 = $ficha2


func _ready():
	# timer de las reglas
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	mapa.pause_mode = Node.PAUSE_MODE_STOP
	
	# colocacion del array de los hijos node2D
	for child in get_children():
		if child is Node2D:
			var child_name = int(child.name) if str(child.name).is_valid_integer() else -1
			if child_name in range(1,58):
				casillas.append(child)
				
	jugador1.position = casillas[0].position
	jugador2.position = casillas[0].position
	jugador1.connect("input_event", self, "_on_player_clicked", [1])
	jugador2.connect("input_event", self, "_on_player_clicked", [2])
		
	
func _on_timer_timeout():
	# timer de las reglas
	countdown -= 1
	if countdown <= 0:
		sprite.visible = false  
		timer.stop()
		mapa.pause_mode = Node.PAUSE_MODE_PROCESS

func _on_player_clicked(viewport, event, shape_idx, player_id):
	if event is InputEventMouseButton and event.pressed:
		if (player_id == 1 and turnP1) or (player_id == 2 and turnP2):
			_roll_dice(player_id)
func _roll_dice(player_id):
	var dice1 = randi() % 6 + 1  # Número aleatorio entre 1 y 6
	var dice2 = randi() % 6 + 1
	var total_move = dice1 + dice2

	if player_id == 1:
		posJug1 += total_move
		if posJug1 >= casillas.size():
			posJug1 = casillas.size() - 1  # Evitar desbordamientos
		jugador1.global_position = casillas[posJug1].global_position
		turnP1 = false
		turnP2 = true  # Cambiar al turno del jugador 2
	elif player_id == 2:
		posJug2 += total_move
		if posJug2 >= casillas.size():
			posJug2 = casillas.size() - 1
		jugador2.global_position = casillas[posJug2].global_position
		turnP2 = false
		turnP1 = true  # Cambiar al turno del jugador 1
