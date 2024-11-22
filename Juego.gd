extends Node2D

var countdown = 10  
onready var sprite = $Sprite 
onready var timer = $Sprite/Timer 

func _ready():

	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()

func _on_timer_timeout():

	countdown -= 1
	if countdown <= 0:
		sprite.visible = false  
		timer.stop()
