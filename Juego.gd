extends Node2D

var countdown = 15  
onready var sprite = $reglas
onready var timer = $reglas/Timer 
onready var mapa = $mapa
const NUM_CASILLAS = 57
var casillas = []



func _ready():
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	mapa.pause_mode = Node.PAUSE_MODE_STOP
	for i in range(NUM_CASILLAS):
		casillas[i]=i;
		
	
	 


func _on_timer_timeout():

	countdown -= 1
	if countdown <= 0:
		sprite.visible = false  
		timer.stop()
		mapa.pause_mode = Node.PAUSE_MODE_PROCESS

