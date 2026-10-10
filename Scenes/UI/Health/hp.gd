class_name HpBar
extends Control


@export var hp:int = 30:
	set(value):
		hp = value
		if is_ready:
			update_hearts()
## The HP required to draw one heart, filled
@export var hp_per_heart:int = 10
@export var heart_count:int = 3:
	set(value):
		heart_count = value
		redraw_hearts()
@export var heart_scene:PackedScene

var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	redraw_hearts()
	is_ready = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func redraw_hearts():
	for child in %HpBar.get_children():
		child.queue_free()
	for i in heart_count:
		if heart_scene:
			var heart:Control = heart_scene.instantiate()
			%HpBar.add_child(heart)
	update_hearts()


func update_hearts():
	var filled_hearts:int = int(hp / float(hp_per_heart))
	var heart_fill_percent:int = int((hp - filled_hearts * hp_per_heart) / (hp_per_heart / 100.0))
	for i in len(%HpBar.get_children()):
		var child = %HpBar.get_child(i)
		if child is Heart:
			if i < filled_hearts:
				child.value = 100
			elif i > filled_hearts:
				child.value = 0
			else:
				child.value = heart_fill_percent
