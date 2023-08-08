extends CharacterBody2D

@export var player_movement : PlayerMovement 

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_forgive_timer = $JumpForgiveness

var double_jump = false # For later
var can_forgive_jump = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	player_movement = load("res://Resources/PlayerMovement_Normal.tres")
	var direction = Input.get_axis("move_left", "move_right")
	apply_gravity(delta)
	jump_mechanics()
#	wall_jump_mechanics()
	apply_acceleration(direction, delta)
	handle_air_acceleration(direction, delta)
	apply_friction(direction, delta)
	apply_air_resistance(direction, delta)
#	character_animations(direction)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		jump_forgive_timer.start()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func apply_acceleration(direction, delta):
	if not is_on_floor(): return
	if direction != 0:
		velocity.x = move_toward(velocity.x, player_movement.speed * direction, player_movement.acceleration * delta) # acceleration code
#		velocity.x = direction * speed # no acceleration
		
func handle_air_acceleration(direction, delta):
		if is_on_floor(): return
		if direction != 0:
			velocity.x = move_toward(velocity.x, player_movement.speed * direction, player_movement.air_acceleration * delta)
			
func apply_friction(direction, delta):
	if direction == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, player_movement.friction * delta) # friction code
#		velocity.x = 0 # no friction

func apply_air_resistance(direction, delta):
	if direction == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, player_movement.air_resistance * delta)

#func wall_jump_mechanics():
#	if not is_on_wall(): return
#	var wall_normal = get_wall_normal()
#	if Input.is_action_just_pressed("move_left") and wall_normal == Vector2.LEFT:
#		velocity.x = wall_normal.x * player_movement.speed
#		velocity.y = player_movement.jump_velocity
#	if Input.is_action_just_pressed("move_right") and wall_normal == Vector2.RIGHT:
#		velocity.x = wall_normal.x * player_movement.speed
#		velocity.y = player_movement.jump_velocity

func jump_mechanics():
#	if is_on_floor(): double_jump = true

	if is_on_floor() or jump_forgive_timer.time_left > 0.0 and can_forgive_jump:
		if Input.is_action_just_pressed("jump"):
			velocity.y = player_movement.jump_velocity
			can_forgive_jump = false
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < player_movement.jump_velocity / 2:
			velocity.y = player_movement.jump_velocity / 2

#		if Input.is_action_just_released("jump") and double_jump:
#			velocity.y = player_movement.jump_velocity * 0.8
#			double_jump = false

#func character_animations(direction):
#	if direction != 0:
#		animated_sprite_2d.play("run")
#		animated_sprite_2d.flip_h = (direction < 0)
#	else:
#		animated_sprite_2d.play("idle")
#	if not is_on_floor():
#		animated_sprite_2d.play("jump")
