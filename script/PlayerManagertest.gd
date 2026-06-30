extends Node
@onready var network=$"../Network"
var localplayer : PlayerData
var players={}

func _ready():
	network.player_joined.connect(add_player)
	network.player_left.connect(remove_player)

func add_player(id):
	if players.has(id):
		return
	
	players[id]=PlayerData.new()
	if id==multiplayer.get_unique_id():
		localplayer=players[id]

func remove_player(id):
	if id==multiplayer.get_unique_id():
		localplayer=null
	players.erase(id)
	
func get_player(id):
	return players.get(id)
