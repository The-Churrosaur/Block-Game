class_name ShipTileMap
extends TileMap

# just fyi this is remote transformed to the gridbase

onready var ship = get_parent()
onready var grid = get_parent().get_node("GridBase")

func _ready():
	pass
