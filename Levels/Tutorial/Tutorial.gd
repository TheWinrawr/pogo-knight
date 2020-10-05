extends Node2D

export(String) var next_scene

onready var player: Node2D = $Player

var spawn_pos = Vector2()
var enter_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelTransition.transition_in()
	yield(LevelTransition, "finished")
	
	SignalManager.connect("player_damaged", self, "_on_player_damaged")
	
	spawn_pos = player.global_position
	player.set_process(true)
	player.set_physics_process(true)
	pass # Replace with function body.

func _on_player_damaged() -> void:
	yield(get_tree().create_timer(2), "timeout")
	player.spawn(spawn_pos)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tutorial_key") && !enter_pressed:
		enter_pressed = true
		LevelTransition.transition_out()
		yield(LevelTransition, "finished")
		get_tree().change_scene(next_scene)
