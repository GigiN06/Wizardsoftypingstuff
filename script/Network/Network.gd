extends Node
var ip= "localhost"
var port=9000
var peer: ENetMultiplayerPeer
var maxusers=5

func host():
	peer=ENetMultiplayerPeer.new()
	peer.create_server(port,maxusers)
	multiplayer.multiplayer_peer=peer
	
func client():
	peer=ENetMultiplayerPeer.new()
	peer.create_client(ip,port)
	multiplayer.multiplayer_peer=peer
