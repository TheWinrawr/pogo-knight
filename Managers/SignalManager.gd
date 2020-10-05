extends Node

signal player_damaged
signal green_gem_collected(power)
signal red_gem_collected(power)

signal game_started

func on_player_damaged() -> void:
	emit_signal("player_damaged")

func on_green_gem_collected(power: String) -> void:
	emit_signal("green_gem_collected", power)
	
func on_red_gem_collected(power: String) -> void:
	emit_signal("red_gem_collected", power)

func on_game_started() -> void:
	emit_signal("game_started")
