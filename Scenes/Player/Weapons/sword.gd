class_name Sword
extends Weapon


signal world_collision(normal:Vector2)
signal enemy_collision()
signal attack_finished()
signal attack_started()


var has_recoiled:Array[CollisionObject2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func attack(direction:int = 0):
	attack_started.emit()
	if sign(direction) == -1:
		%AnimationPlayer.play("attack_left")
	else:
		%AnimationPlayer.play("attack_right")


func attack_vertical(direction:int = 0):
	attack_started.emit()
	if sign(direction) == -1:
		%AnimationPlayer.play("attack_down")
	else:
		%AnimationPlayer.play("attack_up")


func _physics_process(delta: float) -> void:
	if %AnimationPlayer.is_playing():
		if %WorldShapeCast.is_colliding():
			var normal:Vector2 = %WorldShapeCast.get_collision_normal(0)
			world_collision.emit(normal)
			%WorldShapeCast.add_exception_rid(%WorldShapeCast.get_collider_rid(0))
		if %EnemyShapeCast.is_colliding():
			var enemy:BaseEnemy = %EnemyShapeCast.get_collider(0)
			enemy_collision.emit(enemy)
			enemy.hit(self, damage)
			%EnemyShapeCast.add_exception_rid(%EnemyShapeCast.get_collider_rid(0))
	else:
		%WorldShapeCast.clear_exceptions()
		%EnemyShapeCast.clear_exceptions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_finished():
	attack_finished.emit()
