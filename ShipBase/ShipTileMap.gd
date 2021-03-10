class_name ShipTileMap
extends TileMap

# just fyi this is remote transformed to the gridbase

onready var ship = get_parent()
onready var grid = get_parent().get_node("GridBase")

func _ready():
	pass

func rotate_tilev(pos, facing):
	
	if !facing is int: return
	
	facing %= 4
	
	if facing == 1:
		set_cellv(pos, get_cellv(pos), true, false, true)
	elif facing == 2:
		set_cellv(pos, get_cellv(pos), true, true, false)
	elif facing == 3:
		set_cellv(pos, get_cellv(pos), false, true, true)
	
