extends Control


func _ready() -> void:
	%Host.pressed.connect(_on_host_pressed)
	%Join.pressed.connect(_on_join_pressed)
	
# Called when the node enters the scene tree for the first time.
func _on_host_pressed() -> void:
	Networkhandler.start_server()
	get_tree().change_scene_to_file("res://scenes/LevelSelection.tscn") #host chooses lvl

func _on_join_pressed() -> void:
	Networkhandler.start_client("localhost")
	%title.text = "Waiting for Host..."
