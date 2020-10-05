extends Control

var main_game_path = "res://Levels/MainGame.tscn"
var tutorial_path = "res://Levels/Tutorial/Tutorial_1.tscn"

var input_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelTransition.transition_in()
	yield(LevelTransition, "finished")
	pass # Replace with function body.

func _process(delta):
	if input_disabled:
		return
		
	if Input.is_action_just_pressed("slash"):
		input_disabled = true
		LevelTransition.transition_out()
		yield(LevelTransition, "finished")
		get_tree().change_scene(main_game_path)
		
	elif Input.is_action_just_pressed("tutorial_key"):
		input_disabled = true
		LevelTransition.transition_out()
		yield(LevelTransition, "finished")
		get_tree().change_scene(tutorial_path)
