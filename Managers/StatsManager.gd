extends Node

var time_elapsed = 0

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
