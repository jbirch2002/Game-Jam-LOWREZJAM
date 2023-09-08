extends CharacterBody2D

@export var player_movement : PlayerMovement 

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_forgive_timer = $JumpForgiveness
@onready var starting_position = global_position
@onready var wall_jump_timer = $WallJumpTimer

#var double_jump = false
var jump_count = 0
var jump_max = 1
var just_wall_jumped = false
var can_forgive_jump = true
var was_wall_normal = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	player_movement = load("res://Resources/PlayerMovement_Normal.tres")
	var direction = Input.get_axis("move_left", "move_right")
	apply_gravity(delta)
	wall_jump_mechanics()
	jump_mechanics()
	apply_acceleration(direction, delta)
	handle_air_acceleration(direction, delta)
	apply_friction(direction, delta)
	apply_air_resistance(direction, delta)
#	character_animations(direction)
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		jump_forgive_timer.start()
	var just_left_wall = was_on_floor and not is_on_wall()
	if just_left_wall:
		wall_jump_timer.start()


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

func wall_jump_mechanics():
	if not is_on_wall_only():
		just_wall_jumped = false
		return
	var wall_normal = get_wall_normal()
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_normal.x * player_movement.speed
		velocity.y = player_movement.jump_velocity
		just_wall_jumped = true


func jump_mechanics():
	if is_on_floor() or jump_forgive_timer.time_left > 0.0 and can_forgive_jump:
		if Input.is_action_just_pressed("jump"):
			velocity.y = player_movement.jump_velocity
			can_forgive_jump = false
			jump_count = 1
			just_wall_jumped = false
			
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < player_movement.jump_velocity / 2:
			velocity.y = player_movement.jump_velocity / 2

		if jump_count < jump_max and not just_wall_jumped:
			if Input.is_action_just_pressed("jump"):
				velocity.y = player_movement.jump_velocity * 0.8
				jump_count += 1
		if is_on_floor() and jump_count != 0:
			jump_count = 0


#func character_animations(direction):
#	if direction != 0:
#		animated_sprite_2d.play("run")
#		animated_sprite_2d.flip_h = (direction < 0)
#	else:
#		animated_sprite_2d.play("idle")
#	if not is_on_floor():
#		animated_sprite_2d.play("jump")


func _on_hazard_detection_area_entered(area):
	global_position = starting_position

