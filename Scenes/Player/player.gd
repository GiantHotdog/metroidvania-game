extends CharacterBody2D

@export_category("Movement constants")
@export var jump_strength:float = 300.0
@export var air_jump_strength:float = 250.0
@export var wall_jump_strength:float = 180.0
@export var move_speed:float = 150.0
#@export var sprint_speed:float = 250.0
@export var movement_acceleration:float = 1200.0
@export var friction:float = 100.0
@export var max_fall_velocity:float = 1200.0
@export var wall_slip_speed:float = 65.0
@export var dash_boost:float = 400.0

@export var max_air_jumps:int = 1

var last_moved_direction = 1
var air_jumps_count:int = 0
var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_dash:bool = true

const MAX_HEALTH:int = 40
var health:int = 30
var hp:HpBar

var default_damage:int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Sword.visible = false
	hp = %UI.get_hp_bar()
	hp.heart_count = int(float(MAX_HEALTH) / hp.hp_per_heart)
	await get_tree().process_frame
	hp.hp = health
	#hp.update_hearts()


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
	# Handle dashing
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		%DashCooldownTimer.start()
		velocity.x += last_moved_direction * dash_boost
	
	# Handle wall climbing
	if can_climb_wall():
		pass
	
	var direction = Input.get_axis("left", "right")
	if not is_zero_approx(direction):
		last_moved_direction = sign(direction)
		%Hand.position = Vector2(10, 0) * direction
	var movement = direction * move_speed
	velocity.x = move_toward(velocity.x, movement, movement_acceleration * delta)
	
	# Handle attacking
	if Input.is_action_just_pressed("attack"):
		%Sword.attack(last_moved_direction)
	
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


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true


func damage(amount:int = 0):
	health -= amount
	hp.hp = health
	%DamageCooldownTimer.start()


func _on_damage_area_body_entered(body: Node2D) -> void:
	damage(default_damage)
	print("Damaged by body")


func _on_damage_cooldown_timer_timeout() -> void:
	if len(%DamageArea.get_overlapping_bodies()) > 0:
		damage(default_damage)
