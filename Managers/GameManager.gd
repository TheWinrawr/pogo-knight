extends Node

signal started

onready var player: Node2D = $Player
onready var spawn_platform: Node2D = $SpawnPlatform
onready var spikes_container: Node2D = $SpikesGroup
onready var time_label: Label = $GUI/TimeLabel

var game_over_path = "res://Levels/GameOver.tscn"

var player_spawn_pos = Vector2()

var game_started = false
var time_elapsed = 0

var spikes = []
var spike_cooldown = 30
var time_until_spike_falls = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	SignalManager.connect("player_damaged", self, "_on_player_damaged")
	connect("started", SignalManager, "on_game_started")
	
	player_spawn_pos = player.global_position
	
	for spike in spikes_container.get_children():
		if !spike.is_middle:
			spikes.append(spike)
	spikes.shuffle()
	
	LevelTransition.transition_in()
	yield(LevelTransition, "finished")
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if !game_started:
		game_started = true
		player.set_process(true)
		player.set_physics_process(true)
		spawn_platform.set_process(true)
		spawn_platform.spawn()
		emit_signal("started")
		
	if game_started:
		time_elapsed += delta
		_handle_spikes(delta)
		time_label.text = "%.2f" % time_elapsed

func _on_player_damaged() -> void:
	yield(get_tree().create_timer(2), "timeout")
	if player.health <= 0:
		StatsManager.time_elapsed = time_elapsed
		LevelTransition.transition_out()
		yield(LevelTransition, "finished")
		get_tree().change_scene(game_over_path)
		pass
	else:
		player.spawn(player_spawn_pos)
		spawn_platform.spawn()
	pass
	
func _handle_spikes(delta: float) -> void:
	if spikes.size() <= 0:
		return
		
	if time_until_spike_falls > 0:
		time_until_spike_falls -= delta
		return
		
	time_until_spike_falls = spike_cooldown
	var spike = spikes.pop_back()
	spike.remove_from_stage()
