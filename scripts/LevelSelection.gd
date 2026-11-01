extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%level1.pressed.connect(level1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func level1():
	get_tree().change_scene_to_file('res://scenes/level_01.tscn')
