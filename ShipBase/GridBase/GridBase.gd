# block grid manager, should hold blocks as child nodes for tidiness

class_name GridBase
extends Node2D

var shipBody
var shipInfo
var grid_size = 64 # base
onready var anchor = $GridAnchor

var block_dict = {} # master dictionary of grid
# blocks are organized in a dict of vector2 -> node
# hashes all given positions as references to given block

signal block_added(coord, block, grid)
signal block_removed(coord, block, grid) 
# be wary of holding the reference to a dying block

func _ready():
	
	# set node references from tree
	
	var parent = get_parent()
	if parent is ShipBody:
		shipBody = parent
	
	# TODO this is somehow broken
	var info = parent.get_node("ShipInfo")
	if info is ShipInfo:
		shipInfo = info
		#set_vars_from_info(info)
	
	pass

func set_vars_from_info(info):
	if info is ShipInfo:
		print (info.grid_size)
		grid_size = info.grid_size

func add_block(block, center_coord, coord_ary = []):

	# add all pos to dict
	for pos in coord_ary:
		if block_dict.has(pos): # if 'blocked'
			print (name,": coordinate occupied, block failed to place")
			return false
		block_dict[pos] = block
	
	add_child(block) # for cleanliness
	block.owner = shipBody
	position_block(center_coord)
	
	# a surprise tool that will help us later
	if block is Block:
		block.on_added_to_grid(center_coord, block, self)
	emit_signal("block_added", center_coord, block, self)
	return true

func add_block_at_point(block : Block, point : Vector2):
	
	# creates array of grid coords from block sizegrid, centered on found coord
	
	var coord = get_gridFromPoint(point)
	var coord_ary = []
	
	for vec in block.size_grid:
		coord_ary.append(coord + vec)
		# position + relative vector
	
	add_block(block, coord, coord_ary)


func remove_block(pos : Vector2): 
	if block_dict.has(pos):
		var block = block_dict[pos]
		block_dict.erase(pos)
		block.queue_free()
		emit_signal("block_removed", pos, block, self)
		return true
	else:
		return false

func remove_block_at_point(point : Vector2):
	var coord = get_gridFromPoint(point)
	return remove_block(coord)


func get_gridFromPoint(point : Vector2):
	
	# relative vector decomposes to give offset along each axis
	
	var relativeVec = point - global_position
	var grid_coord = relativeVec.rotated(-global_rotation) # relative to grid
	grid_coord = (grid_coord / grid_size).round()
	print("getting grid coordinate ", grid_coord)
	return grid_coord


func position_block(pos : Vector2):
	if !block_dict.has(pos):
		return false
	else: 
		var block = block_dict[pos]
		block.position = pos as Vector2 * grid_size

func position_all_blocks():
	for p in block_dict.keys():
		position_block(p as Vector2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
