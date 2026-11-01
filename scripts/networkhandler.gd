extends Node

signal server_started

const IP_ADDRESS: String = "localhost"
const PORT : int = 30055
const MAX_CLIENT: int = 10

var peer: ENetMultiplayerPeer
var current_level: String = ""
var waiting_to_join: bool = false
var target_ip: String = IP_ADDRESS

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

# Create server
func start_server() -> void:
	waiting_to_join = false
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENT)
	multiplayer.multiplayer_peer = peer
	server_started.emit()

# Create client
func start_client(ip: String = IP_ADDRESS) -> void:
	target_ip = ip
	waiting_to_join = true
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer

func _on_connected_to_server() -> void:
	waiting_to_join = false

func _on_connection_failed() -> void:
	# If client clicked Join before Host started the server, keep retrying
	if waiting_to_join:
		start_client(target_ip)

func _on_peer_connected(id: int) -> void:
	# If the host is already in a level when a client joins, send the client to that level
	if multiplayer.is_server() and current_level != "":
		load_level.rpc_id(id, current_level)

@rpc("call_local", "reliable")			#Switch scenes for both host and all connected clients
func load_level(scene_path: String) -> void:
	current_level = scene_path
	get_tree().change_scene_to_file(scene_path)
