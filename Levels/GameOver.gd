extends Control

var main_menu_path = "res://Levels/MainMenu.tscn"

var input_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimeLabel.text = "You survived for %.2f seconds!" % StatsManager.time_elapsed
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
		get_tree().change_scene(main_menu_path)
