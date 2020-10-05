extends Pogoable

export var is_middle = false

onready var sprite: Sprite = $Sprite

var is_falling = false
var time_until_start_fall = 2
var shake_offset = 2
var fall_speed = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pogo():
	.pogo()
	$PogoSFX.play()
	
func _process(delta: float) -> void:
	if is_falling:
		sprite.offset = Vector2(rand_range(-shake_offset, shake_offset), rand_range(-shake_offset, shake_offset))
		
		if time_until_start_fall > 0:
			time_until_start_fall -= delta
		else:
			position.y += fall_speed * delta


func _on_Spikes_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	pass # Replace with function body.


func remove_from_stage():
	is_falling = true
	$RumbleSFX.play()
