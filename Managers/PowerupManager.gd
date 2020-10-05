extends Node

onready var spawn_manager: Node2D = null
onready var label: Label = null

var player: Node = null

var buff_duration = 10
var nerf_duration = 10
var time_until_no_effect = 0

var label_text_duration = 5
var time_until_no_text = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("green_gem_collected", self, "_on_green_gem_collected")
	SignalManager.connect("red_gem_collected", self, "_on_red_gem_collected")
	SignalManager.connect("player_damaged", self, "_on_player_damaged")
	
	player = get_parent().get_node("Player")
	spawn_manager = get_parent().get_node("SpawnManager")
	label = get_parent().get_node("GUI/StatusLabel")
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if time_until_no_effect <= 0:
		set_player_stats_to_normal()
	else:
		time_until_no_effect -= delta
	
	if time_until_no_text <= 0:
		label.text = ""
	else:
		time_until_no_text -= delta
		
func _on_player_damaged() -> void:
	set_player_stats_to_normal()

func _on_green_gem_collected(power: String) -> void:
	time_until_no_text = label_text_duration
	if power == "SPEED":
		set_player_stats_to_normal()
		time_until_no_effect = buff_duration
		player.speed = player.base_speed * 2
		label.text = "Increased speed!"
	elif power == "GRAVITY":
		set_player_stats_to_normal()
		time_until_no_effect = buff_duration
		player.gravity = player.base_gravity * 0.5
		label.text = "Decreased gravity!"
	elif power == "BOMB":
		label.text = "Bomb!"
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			if enemy.has_method("destroy"):
				enemy.destroy()
		
func _on_red_gem_collected(power: String) -> void:
	set_player_stats_to_normal()
	time_until_no_effect = buff_duration
	time_until_no_text = label_text_duration
	if power == "SPEED":
		label.text = "Decreased speed!"
		player.speed = player.base_speed * 0.5
	elif power == "GRAVITY":
		label.text = "Increased gravity!"
		player.gravity = player.base_gravity * 2
	elif power == "BULLET":
		label.text = "Bullet swarm!"
		spawn_manager.override_bullet_spawn_cooldown = true
		spawn_manager.bullet_spawn_cooldown = 1
		spawn_manager.time_until_bullet_spawn = 0

func set_player_stats_to_normal() -> void:
	player.gravity = player.base_gravity
	player.speed = player.base_speed
	
	spawn_manager.override_bullet_spawn_cooldown = false
	
