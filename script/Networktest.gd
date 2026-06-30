extends Node
signal player_joined(peer_id)
signal player_left(peer_id)
signal hosted
signal joined
signal disconnected
@onready var player_manager=$"../PlayerManager"

var port =9000

func host_game():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port)
	if err!=OK:
		print("Failed to host : ",err)
		return
	multiplayer.multiplayer_peer=peer
	player_joined.emit(multiplayer.get_unique_id())
	hosted.emit()

func join_game(ip):
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip,port)
	if err!= OK:
		print("Failed to join : ",err)
		return
	multiplayer.multiplayer_peer=peer
	print("Joining server")

func _ready():
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	
func _peer_connected(id):
	player_joined.emit(id)
	print("Player", id, "joined")

func _peer_disconnected(id):
	player_left.emit(id)
	
@rpc("authority","call_local")
func register_player(id):
	player_manager.add_player(id)
	print("Registered player:", id) 
