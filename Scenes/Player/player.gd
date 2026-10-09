extends CharacterBody2D

@export_category("Movement constants")
@export var jump_strength:float = 250.0
@export var air_jump_strength:float = 250.0
@export var wall_jump_strength:float = 150.0
@export var move_speed:float = 150.0
@export var sprint_speed:float = 250.0
@export var movement_acceleration:float = 1200.0
@export var friction:float = 120.0
@export var max_fall_velocity:float = 1200.0
@export var wall_slip_speed:float = 75.0

@export var max_air_jumps:int = 1

var last_moved_direction = 1
var air_jumps_count:int = 0
var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_sprinting:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func can_climb_wall() -> Object:
	for ray in %ClimbingRays.get_children():
		if ray is RayCast2D:
			var collider:Object = ray.get_collider()
			if collider:
				return collider
	return null


func check_inputs(delta: float):
	# Handle jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = - jump_strength
		elif can_climb_wall():
			velocity.y = - wall_jump_strength
		elif air_jumps_count < max_air_jumps:
			velocity.y = - air_jump_strength
			air_jumps_count += 1
	# Handle sprinting
	if Input.is_action_just_pressed("dash"):
		pass
	
	# Handle wall climbing
	if can_climb_wall():
		pass
	
	var direction = Input.get_axis("left", "right")
	if is_zero_approx(direction):
		pass
	var movement = direction * move_speed if not is_sprinting else direction * sprint_speed
	velocity.x = move_toward(velocity.x, movement, movement_acceleration * delta)
	
	if is_on_floor() or can_climb_wall():
		air_jumps_count = 0


func apply_friction(delta: float):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)


func apply_gravity(delta: float):
	velocity.y += gravity * delta


func limit_fall_speed():
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity 
	# Limit y velocity to slip speed if on a wall
	if can_climb_wall() and velocity.y > wall_slip_speed:
		velocity.y = wall_slip_speed


func _physics_process(delta: float) -> void:
	check_inputs(delta)
	apply_friction(delta)
	apply_gravity(delta)
	limit_fall_speed()
	
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
