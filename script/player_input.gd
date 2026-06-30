extends Node2D
@onready var inventory=$Tower/Inventory
var typed_stuff=""
var scene=0 #1- tower, 2-shop
var lock=0
#player
var mult=1
var player=PlayerData.new()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_BACKSPACE and lock==1:
			typed_stuff = typed_stuff.left(typed_stuff.length() - 1)
			lock=0
		elif event.keycode == KEY_SPACE and typed_stuff!="":
			typed_stuff+=" "
		elif event.unicode>0:
			var evchar=char(event.unicode)
			if (evchar in [',','.','?','!'] or RegEx.create_from_string("^[a-zA-Z]$").search(evchar)) and lock==0:
				typed_stuff+=evchar
			if int(evchar) in [1,2,3,4,5]:
				var num=int(evchar)-1
				if inventory.cooldown==0 and player.inventory[num]:
					inventory.invcol[num]=Color.DARK_RED
					inventory.queue_redraw()
					inventory.cooldown=player.inventory[num]["cooldown"]
					inventory.item=player.inventory[num]["name"]
					inventory.slotnum=num
