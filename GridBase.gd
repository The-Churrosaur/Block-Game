# base for a grid, holds blocks as child nodes
# block are organized in a dict of vector2 -> node
class_name Grid
extends Node2D

var block_dict = {} # master dictionary of blocks
const grid_spacing = 64 # pixels per block

func _ready():
	pass

func add_block(pos : Vector2, block : Block):
	block_dict[pos] = block

func remove_block(pos : Vector2): 
	if block_dict.has(pos):
		block_dict.erase(pos)

func position_blocks():
	for p in block_dict.keys():
		var block = block_dict[p]
		block.position = p as Vector2 * grid_spacing

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
