extends Pogoable

export(PackedScene) var Bullet

onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var collision: CollisionShape2D = $CollisionShape2D

var shoot_cooldown = 4
var time_until_shoot = 2

var target: Node2D = null

var will_destroy = false
var time_until_destroyed = 3

var spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_sprite.frame = 0
	set_process(false)
	pass # Replace with function body.
	
func pogo():
	.pogo()
	destroy()
	
func destroy() -> void:
	if will_destroy:
		return
	will_destroy = true
	collision.set_deferred("disabled", true)
	anim_player.play("death")
	$DeathSFX.play()

func _process(delta):
	if will_destroy:
		time_until_destroyed -= delta
	if time_until_destroyed <= 0:
		queue_free()
		
	_handle_shoot(delta)
	if target != null && !will_destroy:
		if target.global_position.x > global_position.x:
			scale.x = 1
		else:
			scale.x = -1
	
func _handle_shoot(delta):
	if target == null:
		return
		
	if time_until_shoot > 0:
		time_until_shoot -= delta
		return
	time_until_shoot = shoot_cooldown
	
	var bullet = Bullet.instance()
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)
	bullet.target = target


func _on_AnimatedSprite_animation_finished():
	if spawned:
		return
	spawned = true
	anim_sprite.play("default")
	collision.set_deferred("disabled", false)
	set_process(true)
	pass # Replace with function body.


func _on_Ghost_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	pass # Replace with function body.
