extends KinematicBody2D

enum State {IDLE, SLASH_SIDE, SLASH_UP, SLASH_DOWN}

signal damaged

onready var slash_hitboxes: Node2D = $SlashHitboxes
onready var down_slash: Area2D = $SlashHitboxes/DownSlash
onready var side_slash: Area2D = $SlashHitboxes/SideSlash
onready var up_slash: Area2D = $SlashHitboxes/UpSlash

onready var player_anim_sprite: AnimatedSprite = $PlayerAnimation
onready var anim_player: AnimationPlayer = $AnimationPlayer

onready var slash_sfx: AudioStreamPlayer = $SlashSFX

onready var floor_check: RayCast2D = $FloorCheck

var base_speed = 250
var base_gravity = 0

var speed = 200
var terminal_speed = 800
var velocity = Vector2()

var max_health = 5
var health = 5


var jump_height = 200
var time_to_jump_apex = 0.7
var gravity = 0
var jump_velocity = 0


var slash_cooldown = 0.4
var time_until_can_slash = 0
var active_slash_hitbox: Area2D = null
var hitbox_duration = 0.1
var time_until_no_hitbox = 0

var lock_dir = false
var state = State.IDLE

var is_invincible = false
var invincible_timer = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("damaged", SignalManager, "on_player_damaged")
	
	gravity = 2 * jump_height / pow(time_to_jump_apex, 2)
	jump_velocity = gravity * time_to_jump_apex
	base_gravity = gravity
	speed = base_speed
	
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.
	
func spawn(var pos: Vector2) -> void:
	set_process(true)
	set_physics_process(true)
	
	is_invincible = true
	anim_player.seek(0, true)
	anim_player.play("invincible")

	global_position = pos
	state = State.IDLE
	velocity = Vector2()
	pass
	
func take_damage() -> void:
	if is_invincible:
		return
	is_invincible = true
	
	health -= 1
	
	set_process(false)
	set_physics_process(false)
	emit_signal("damaged")
	
	anim_player.play("damaged")
	state = State.IDLE
	_handle_anim()
	$DamageSFX.play()
	
func _process(delta):
	_handle_anim()
	_check_player_direction()

func _physics_process(delta):
	_handle_slash_input(delta)
	_handle_slash_hitbox(delta)
	_handle_movement(delta)
	
func _check_player_direction():
	if lock_dir:
		return
		
	if Input.is_action_pressed("right"):
		player_anim_sprite.scale.x = 1
		slash_hitboxes.scale.x = 1
	if Input.is_action_pressed("left"):
		player_anim_sprite.scale.x = -1
		slash_hitboxes.scale.x = -1
		
func _handle_movement(delta: float) -> void:
	var dir = Vector2()
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_just_pressed("slash") && floor_check.is_colliding():
		velocity.y = -jump_velocity
	
	
	velocity.x = dir.x * speed
	velocity.y += gravity * delta
	if velocity.y > terminal_speed:
		velocity.y = terminal_speed

	velocity = move_and_slide(velocity)
	if is_on_floor():
		velocity.y = 0
		
func _handle_anim() -> void:
	var animation = "default"
	var offset = Vector2(8, 0)
	
	match state:
		State.IDLE:
			animation = "default"
			offset = Vector2(8, 0)
		State.SLASH_DOWN:
			animation = "downslash"
			offset = Vector2(8, 0)
		State.SLASH_UP:
			animation = "upslash"
			offset = Vector2(8, 0)
		State.SLASH_SIDE:
			animation = "sideslash"
			offset = Vector2(8, 0)
	
	if player_anim_sprite.animation != animation:
		player_anim_sprite.play(animation)
		player_anim_sprite.offset = offset
		
func _handle_slash_input(delta: float) -> void:
	if time_until_can_slash > 0:
		time_until_can_slash -= delta
		return
		
	if !Input.is_action_pressed("slash"):
		return
		
	lock_dir = false
	_check_player_direction()
	
	time_until_can_slash = slash_cooldown
	lock_dir = true
		
	# Order of checking - down, up, then side
	active_slash_hitbox = side_slash
	state = State.SLASH_SIDE
	if Input.is_action_pressed("down"):
		active_slash_hitbox = down_slash
		state = State.SLASH_DOWN
	elif Input.is_action_pressed("up"):
		active_slash_hitbox = up_slash
		state = State.SLASH_UP
		
	time_until_no_hitbox = hitbox_duration
	
	slash_sfx.play()
	#print("slash %s" % State.keys()[state])
		
func _handle_slash_hitbox(delta: float) -> void:
	if time_until_no_hitbox <= 0:
		return
	else:
		time_until_no_hitbox -= delta
		
	var hits = active_slash_hitbox.get_overlapping_areas()
	if hits.size() <= 0:
		return
		
	for hit in hits:
		if hit is Pogoable:
			hit.pogo()
		
	if state == State.SLASH_DOWN:
		velocity.y = -jump_velocity
		
func _disable_collisions(disabled: bool) -> void:
	var collision = $CollisionShape2D
	collision.set_deferred("disabled", disabled)

func _on_PlayerAnimation_animation_finished():
	lock_dir = false
	if player_anim_sprite.animation != "default":
		state = State.IDLE
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "invincible":
		is_invincible = false
		_disable_collisions(false)
	pass # Replace with function body.
