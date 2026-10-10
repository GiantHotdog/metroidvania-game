extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func attack(direction:int = 0):
	if sign(direction) == -1:
		%AnimationPlayer.play("attack_left")
	else:
		%AnimationPlayer.play("attack_right")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
