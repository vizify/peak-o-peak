extends Control

func _ready() -> void:
	%level1.pressed.connect(level1)

func level1() -> void:			#host picks lvl and broadcasts to all clients
	if multiplayer.is_server():
		Networkhandler.load_level.rpc("res://scenes/level_01.tscn")    
