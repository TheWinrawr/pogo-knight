extends Camera2D

var shake_duration = 1
var shake_time_left = 0
var shake_strength = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("player_damaged", self, "shake")
	pass # Replace with function body.

func shake():
	shake_time_left = shake_duration
	
func _process(delta):
	if shake_time_left > 0:
		var strength = shake_strength * shake_time_left / shake_duration
		offset.x = rand_range(-strength, strength)
		offset.y = rand_range(-strength, strength)
		
		shake_time_left -= delta
	else:
		offset = Vector2()
