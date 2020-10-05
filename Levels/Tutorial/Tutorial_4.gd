extends "res://Levels/Tutorial/Tutorial.gd"

export(PackedScene) var Bullet

onready var pos: Position2D = $Position2D

var bullet_spawn_cooldown = 5
var time_until_bullet_spawn = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if time_until_bullet_spawn <= 0:
		time_until_bullet_spawn = bullet_spawn_cooldown
		var bullet = Bullet.instance()
		bullet.global_position = pos.global_position
		bullet.target = player
		add_child(bullet)
	else:
		time_until_bullet_spawn -= delta
