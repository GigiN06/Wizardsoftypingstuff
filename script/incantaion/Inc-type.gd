extends RichTextLabel
@onready var game=$"../../../"
@onready var inc_show=$"../Inc_show"
@onready var inc_type=$"."
var line=0
var red=Color(1,0,0,1)
var white=Color(1,1,1,1)
var textdisplay=[]
var originpos=Vector2.ZERO

func _ready():
	position=inc_show.position
	size = inc_show.size
	modulate.a=1
	originpos=position
	textdisplay.resize(inc_show.paragraph.size())
	for i in range(textdisplay.size()):
		textdisplay[i] = ""
	
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if game.typed_stuff!="" :
		if line<len(inc_show.paragraph):
			if game.typed_stuff!=inc_show.paragraph[line].left(len(game.typed_stuff)):
				game.lock=1
				error()			
			if game.lock==0:
				modulate=Color.WHITE
				position=originpos
			if game.typed_stuff==inc_show.paragraph[line]:
				textdisplay[line]=game.typed_stuff
				game.typed_stuff=""
				line+=1
		if line==len(inc_show.paragraph):
			redotext()
			inc_show.generate()
			line=0
	textdisplay[line]=game.typed_stuff
	text="\n".join(textdisplay)
			
func error():
	modulate=Color.RED
	position= originpos + Vector2(randf_range(-5,5),randf_range(-3,3))
	
func redotext():
	for i in range(textdisplay.size()):
		textdisplay[i] = ""
