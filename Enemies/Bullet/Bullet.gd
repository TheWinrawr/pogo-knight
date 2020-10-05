extends Pogoable

onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var collision: CollisionShape2D = $CollisionShape2D

var speed = 200
var target: Node2D = null
var dir = Vector2.RIGHT

var spawned = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	anim_sprite.frame = 0
	pass # Replace with function body.

func _physics_process(delta):
	position += dir * speed * delta
	rotation = dir.angle()
	
func pogo():
	.pogo()
	destroy()

func _on_Bullet_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	destroy()
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if spawned:
		return
	spawned = true
	anim_sprite.play("default")
	collision.set_deferred("disabled", false)
	$ShootSFX.play()
	
	set_physics_process(true)
	if target != null:
		dir = (target.global_position - global_position).normalized()
		
func destroy():
	queue_free()
