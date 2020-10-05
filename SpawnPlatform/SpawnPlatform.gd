extends StaticBody2D

onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D

var platform_active_duration = 2
var time_until_platform_destroyed = 0
var is_destroyed = false
var shake_offset = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.
	
func _process(delta):
	if time_until_platform_destroyed <= 0:
		destroy()
	else:
		time_until_platform_destroyed -= delta
		sprite.offset = Vector2(rand_range(-shake_offset, shake_offset), rand_range(-shake_offset, shake_offset))
	
func spawn():
	sprite.visible = true
	collision.disabled = false
	time_until_platform_destroyed = platform_active_duration
	is_destroyed = false

func destroy():
	if is_destroyed:
		return
		
	sprite.visible = false
	collision.disabled = true
	is_destroyed = true
	$Particles2D.emitting = true
