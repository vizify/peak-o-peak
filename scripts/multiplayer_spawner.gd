extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)
	Networkhandler.server_started.connect(func(): spawn_player(1))
	
func spawn_player(id: int) -> void:
	if not multiplayer.is_server():
		return
	var player: Node = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
	
func remove_player(id: int) -> void:
	if not multiplayer.is_server():
		return
	var player = get_node_or_null(str(spawn_path) + "/" + str(id))
	if player:
		player.queue_free()
