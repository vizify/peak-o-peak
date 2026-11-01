extends Node

const IP_ADDRESS: String = "localhost"
const PORT : int = 30055
const MAX_CLIENT: int = 10

var peer: ENetMultiplayerPeer

# Create server
func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENT)
	multiplayer.multiplayer_peer = peer

# Create client
func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
