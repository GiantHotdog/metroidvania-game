class_name BaseEnemy
extends CharacterBody2D


@export_category("Movement constants")
@export var move_speed:float = 65.0
@export var move_acceleration:float = 300.0

@export_category("Health")
@export var max_health:int = 10

@export_category("Combat")
@export var knockback:float = 300.0
#@export var knockback_decay:float = 300.0
@export var damage:int = 10

var gravity:int = ProjectSettings.get_setting("physics/2d/default_gravity")
var tracking_player:bool = true
var health:int = max_health:
	set(value):
		health = value
		if health <= 0:
			die()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func deal_damage(value:int) -> void:
	health -= value


func hit(by:Node2D, value:int):
	deal_damage(value)
	knock_back_from(by)


func die() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	if tracking_player:
		track_player(delta)
	move_and_slide()


func track_player(delta:float) -> void:
	var tracking_arr:Array[Node2D] = %TrackingArea.get_overlapping_bodies()
	if len(tracking_arr) > 0:
		var tracking:Node2D = tracking_arr[0]
		var direction:Vector2 = global_position.direction_to(tracking.global_position)
		velocity.x = sign(direction.x) * move_speed
		#velocity.x = move_toward(velocity.x, sign(direction.x) * move_speed, move_speed * delta)


func path_find_to_position():
	pass


func path_find_to_entity():
	pass


func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta


#func _on_damage_area_area_entered(area: Area2D) -> void:
	#var parent:Node = area.get_parent()
	#if parent is Weapon:
		#deal_damage(parent.damage)


func knock_back_from(node:Node2D):
	var hitter_position = node.global_position
	var direction:Vector2 = global_position.direction_to(hitter_position)
	velocity -= direction * knockback
