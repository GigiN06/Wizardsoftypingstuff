extends Node2D
@onready var game=$"../../"
var invcol=[Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE]
var cooldown=0

var maxcooldown=0.1
var basecol=Color.WHITE
var stopcol= Color(0.4, 0.0, 0.0)
var item="none"
var slotnum=0
var alpha=1
var font = preload("res://misc/font/PixelifySans-VariableFont_wght.ttf")
var invslot=preload("res://misc/sprites/inventory3.png")
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown > 0:
		maxcooldown=cooldown
		cooldown -= delta
		alpha -= delta
		var progress=1.0-(cooldown/maxcooldown)
		var color=stopcol.lerp(basecol,progress)
		invcol[slotnum]=color
		queue_redraw()
	else:
		alpha=1
		cooldown = 0
		invcol = [Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE]
		queue_redraw()
		
func _draw():
	for i in range(5):
		var pos=Vector2(150+i*150,500)
		draw_texture_rect(invslot,Rect2(pos, Vector2(96, 96)),false,invcol[i])
		draw_string(font,pos + Vector2(15, 80),str(i + 1),HORIZONTAL_ALIGNMENT_LEFT, -1, 16, invcol[i])
	if item=="None" and cooldown>0:
		draw_string(font,Vector2(400, 620),str("No item was use"),HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(1,1,1,alpha))


