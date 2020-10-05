extends Area2D

class_name Pogoable

var can_pogo = true
var pogo_cooldown = 0.5
var time_until_can_pogo = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta: float) -> void:
	if time_until_can_pogo <= 0:
		can_pogo = true
	else:
		time_until_can_pogo -= delta
		
func pogo() -> void:
	if !can_pogo:
		return
	can_pogo = false
	time_until_can_pogo = pogo_cooldown
