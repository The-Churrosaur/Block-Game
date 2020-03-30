# block grid, should hold blocks as child nodes for tidiness
# blocks are organized in a dict of vector2 -> node
class_name Grid
extends Node2D

const grid_spacing = 64 # pixels per block

var block_dict = {} # master dictionary of grid
# hashes all given positions as references to given block

func _ready():
	pass

func add_block(block : Block, coord_ary = []):

	# add all pos to dict
	var temp
	for pos in coord_ary:
		if block_dict.has(pos): # if 'blocked'
			print (name,": coordinate occupied, block failed to place")
			return false
		block_dict[pos] = block
		temp = pos
	
	add_child(block) # for cleanliness
	position_block(temp)
	return true

func add_block_at_point(block : Block, point : Vector2):
	
	# creates array of grid coords from block's sizegrid, and found coord
	
	var coord = get_gridFromPoint(point)
	var coord_ary = []
	#coord_ary.resize(block.size_grid.size())
	# removed since we're appending to the array per point
	
	for vec in block.size_grid:
		coord_ary.append(coord + vec * grid_spacing)
		# position + scaled relative vector
	
	# a surprise tool that will help us later
	block.grid_coord = coord_ary
	block.center_grid_coord = coord
	
	add_block(block, coord_ary)

func remove_block(pos : Vector2): 
	if block_dict.has(pos):
		block_dict.erase(pos)

func position_block(pos : Vector2):
	if !block_dict.has(pos):
		return false
	else: 
		var block = block_dict[pos]
		block.position = pos as Vector2 * grid_spacing

func get_gridFromPoint(point : Vector2):
	var relativeVec = point - position
	var x = relativeVec.x / grid_spacing
	var y = relativeVec.y / grid_spacing
	var grid_coord = Vector2(x,y).round()
	#print("getting grid coordinate ", grid_coord)
	return grid_coord

func position_all_blocks():
	for p in block_dict.keys():
		position_block(p as Vector2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
