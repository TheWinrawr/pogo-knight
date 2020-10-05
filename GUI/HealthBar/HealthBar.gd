extends Control

onready var container: GridContainer = $GridContainer

var index = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("player_damaged", self, "_on_player_damaged")
	pass # Replace with function body.

func _on_player_damaged():
	if index < 0:
		return
	var hearts = container.get_children()
	hearts[index].visible = false
	index -= 1
	
	
func _on_player_healed():
	if index >= 4:
		return
	index += 1
	var hearts = container.get_children()
	hearts[index].visible = true
