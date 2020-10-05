extends Pogoable

class_name Gem

onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var collision: CollisionShape2D = $CollisionShape2D
onready var break_particles: Particles2D = $BreakParticles

var will_destroy = false
var time_until_destroyed = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if will_destroy:
		time_until_destroyed -= delta
	if time_until_destroyed <= 0:
		queue_free()

func pogo() -> void:
	.pogo()
	break_particles.emitting = true
	anim_sprite.visible = false
	$PogoSFX.play()
	_destroy()
	
func _destroy() -> void:
	if will_destroy:
		return
	will_destroy = true
	collision.set_deferred("disabled", true)

func _on_gem_body_entered(body):
	anim_player.play("collected")
	_destroy()
	pass
