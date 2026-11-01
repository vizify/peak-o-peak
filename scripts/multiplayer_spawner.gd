extends MultiplayerSpawner

@export var network_player: PackedScene
@export var spawn_pos: Vector2 = Vector2(100, 200)

func _ready() -> void:
	multiplayer.peer_disconnected.connect(remove_player)
	Networkhandler.server_started.connect(func(): spawn_player(1))
	multiplayer.connected_to_server.connect(func(): client_level_ready.rpc_id(1))
	
	await get_tree().create_timer(0.2).timeout
	
	if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		if multiplayer.is_server():
			spawn_player(1)
			for id in multiplayer.get_peers():
				spawn_player(id)
		else:
			client_level_ready.rpc_id(1)

@rpc("any_peer", "reliable")
func client_level_ready() -> void:
	if not multiplayer.is_server():
		return
	var client_id = multiplayer.get_remote_sender_id()
	var parent = get_node(spawn_path)
	# If this client was already spawned at level start, nothing to do
	if parent.has_node(str(client_id)):
		return
	
	# Late-joining client: refresh existing players across frames so the new client receives them
	var saved_positions: Dictionary = {}
	for child in parent.get_children():
		if child.is_in_group("player"):
			saved_positions[child.name.to_int()] = child.position
			child.queue_free()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	for existing_id in saved_positions:
		spawn_player(existing_id, saved_positions[existing_id])
	spawn_player(client_id)

func spawn_player(id: int, pos: Vector2 = spawn_pos) -> void:
	if not multiplayer.is_server():
		return
	var parent = get_node(spawn_path)
	if parent.has_node(str(id)):
		return
	var player = network_player.instantiate()
	player.name = str(id)
	player.position = pos
	parent.call_deferred("add_child", player, true)

func remove_player(id: int) -> void:
	if not multiplayer.is_server():
		return
	var player = get_node_or_null(str(spawn_path) + "/" + str(id))
	if player:
		player.queue_free()
