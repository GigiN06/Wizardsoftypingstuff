extends Node2D
@onready var game=$".."
@onready var network=$"../Network"
var menuscene=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if menuscene==2:
		connectstuff()


func connectstuff():
	if game.typed_stuff=="Host":
		network.host()
	if game.typed_stuff=="Join":
		network.client()
