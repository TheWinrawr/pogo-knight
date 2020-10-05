extends Gem

enum Power {SPEED, GRAVITY, BULLET}

signal collected(power)

var power = Power.SPEED


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("collected", SignalManager, "on_red_gem_collected")
	
	power = randi() % Power.size()
	anim_sprite.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RedGem_body_entered(body):
	_on_gem_body_entered(body)
	emit_signal("collected", Power.keys()[power])
	$CollectSFX.play()

func _on_AnimatedSprite_animation_finished():
	anim_sprite.animation = "default"
	anim_sprite.frame = power
	anim_sprite.playing = false
	collision.set_deferred("disabled", false)
	pass # Replace with function body.
