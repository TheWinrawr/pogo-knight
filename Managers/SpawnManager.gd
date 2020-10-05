extends Node

export(PackedScene) var Bullet
export(PackedScene) var GreenGem
export(PackedScene) var RedGem
export(PackedScene) var Ghost

onready var game_manager = get_parent()
onready var spawn_tiles: Node2D = null
onready var bullet_spawn_tiles: TileMap = null
onready var gem_spawn_tiles: TileMap = null
onready var ghost_spawn_tiles: TileMap = null

var min_bullet_spawn_cooldown = 2
var max_bullet_spawn_cooldown = 8
var bullet_spawn_cooldown = 7
var time_until_bullet_spawn = 5
var override_bullet_spawn_cooldown = false

var min_gem_spawn_cooldown = 5
var max_gem_spawn_cooldown = 15
var time_until_gem_spawn = 10

var min_ghost_spawn_cooldown = 10
var max_ghost_spawn_cooldown = 20
var time_until_ghost_spawn = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("game_started", self, "_on_game_started")
	set_process(false)
	
	spawn_tiles = get_parent().get_node("SpawnTiles")
	bullet_spawn_tiles = spawn_tiles.get_node("BulletSpawn")
	gem_spawn_tiles = spawn_tiles.get_node("GemSpawn")
	ghost_spawn_tiles = spawn_tiles.get_node("GhostSpawn")
	pass # Replace with function body.

func _on_game_started() -> void:
	print("spawn manager active")
	set_process(true)
	
func _process(delta: float) -> void:
	_update_base_cooldowns()
	_spawn_bullet(delta)
	_spawn_gem(delta)
	_spawn_ghost(delta)
	pass
	
func _update_base_cooldowns() -> void:
	if override_bullet_spawn_cooldown:
		return
	bullet_spawn_cooldown = lerp(max_bullet_spawn_cooldown, min_bullet_spawn_cooldown, game_manager.time_elapsed / 120)
	bullet_spawn_cooldown = clamp(bullet_spawn_cooldown, min_bullet_spawn_cooldown, max_bullet_spawn_cooldown)

func _spawn_bullet(delta: float) -> void:
	if time_until_bullet_spawn > 0:
		time_until_bullet_spawn -= delta
		return
	else:
		time_until_bullet_spawn = bullet_spawn_cooldown
		
	var positions = bullet_spawn_tiles.get_used_cells()
	var pos: Vector2 = positions[randi() % positions.size()]
	pos *= bullet_spawn_tiles.cell_size.x
	pos += bullet_spawn_tiles.global_position
	
	var bullet = Bullet.instance()
	bullet.global_position = pos
	get_tree().current_scene.add_child(bullet)
	bullet.target = game_manager.player
	
func _spawn_gem(delta: float) -> void:
	if time_until_gem_spawn > 0:
		time_until_gem_spawn -= delta
		return
	else:
		time_until_gem_spawn = rand_range(min_gem_spawn_cooldown, max_gem_spawn_cooldown)
		
	var positions = gem_spawn_tiles.get_used_cells()
	var pos: Vector2 = positions[randi() % positions.size()]
	pos *= gem_spawn_tiles.cell_size.x
	pos += gem_spawn_tiles.global_position
	
	var gem = null
	if randf() < 0.5:
		gem = RedGem.instance()
	else:
		gem = GreenGem.instance()
	gem.global_position = pos
	get_tree().current_scene.add_child(gem)
	
func _spawn_ghost(delta: float) -> void:
	if time_until_ghost_spawn > 0:
		time_until_ghost_spawn -= delta
		return
	else:
		time_until_ghost_spawn = rand_range(min_ghost_spawn_cooldown, max_ghost_spawn_cooldown)
		
	var positions = ghost_spawn_tiles.get_used_cells()
	var pos: Vector2 = positions[randi() % positions.size()]
	pos *= ghost_spawn_tiles.cell_size.x
	pos += ghost_spawn_tiles.global_position
	
	var ghost = Ghost.instance()
	ghost.global_position = pos
	get_tree().current_scene.add_child(ghost)
	ghost.target = game_manager.player
