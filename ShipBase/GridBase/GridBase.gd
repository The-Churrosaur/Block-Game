# block grid manager, should hold blocks as child nodes

class_name GridBase
extends Node2D

onready var storage = $GridBase_Storage
# TODO timing of loading children/references

var shipBody
var shipInfo
export var grid_size = 64 # base
onready var anchor = $GridAnchor

var block_dict = {} # master dictionary of grid
# blocks are organized in a dict of vector2 -> node
# hashes all given positions as references to given block

signal block_added(coord, block, grid)
signal block_removed(coord, block, grid) 
# be wary of holding the reference to a dying block

export var saved = false

func _ready():
	
	# on load to reset offset position
	# TODO is this the best way to do this?
	position = Vector2(0,0)
	
	# TODO clean a bunch of this garbage
	# just in case
	if saved:
		storage = $GridBase_Storage 
	
	# set node references from tree
	
	var parent = get_parent()
	#if parent is ShipBody: # whyyyyyyy
	shipBody = parent
	
	# TODO this is somehow broken
	var info = parent.get_node("ShipInfo")
#	if info is ShipInfo:
	shipInfo = info
		#set_vars_from_info(info)
	
	pass

#func set_vars_from_info(info):
#	if info is ShipInfo:
#		print (info.grid_size)
#		grid_size = info.grid_size

func add_block(block, center_coord, check_blocked = true):
	
	# creates array of grid coords from block sizegrid, centered on found coord
	var coord_ary = []
	for vec in block.size_grid:
		coord_ary.append(center_coord + vec)
		# position + relative vector
	
	# check if pos blocked
	if (check_blocked):
		for pos in coord_ary:
			if block_dict.has(pos): # if 'blocked'
				print (name,": coordinate occupied, block failed to place")
				return false
	
	# add all pos to dict
	for pos in coord_ary:
		block_dict[pos] = block
	
	add_child(block) # for cleanliness
	position_block(center_coord)
	
	# a surprise tool that will help us later
	if block is Block:
		block.on_added_to_grid(center_coord, block, self)
		# would need reference to connect signal
	emit_signal("block_added", center_coord, block, self)
	return true

func add_block_at_point(block : Block, point : Vector2):
	
	var coord = get_gridFromPoint(point)
	add_block(block, coord)


func remove_block(pos : Vector2) -> bool:
	if block_dict.has(pos):
		var block = block_dict[pos]
		
		# calls cleanup on block, can abort here
		var cancel = block.on_removed_from_grid(pos, block, self)
		if cancel:
			print("block cancelled removal")
			return false
		
		block_dict.erase(pos)
		emit_signal("block_removed", pos, block, self)
		block.queue_free()
		return true
	else:
		print("block to remove not found!")
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

# SAVING AND LOADING ===========================================================

signal save_blocks(name, folder)

func save(folder):
	print("grid saving: " + name)
	
	saved = true
	
	# serialize vars, save storage
	storage.save(self, folder)
	
	# -> save blocks
	
	# make new folder for blocks
	var directory = Directory.new()
	directory.open(folder)
	directory.make_dir("Blocks")
	directory.change_dir("Blocks")
	var new_folder = directory.get_current_dir()
	
	# tell blocks to save under new folder
	emit_signal("save_blocks", new_folder, folder)
	
	# dissociates self from ship (removes duplicate nodes in save)
	owner = null
	
	# save self 
	
	var address = folder + "/" + name + ".tscn"
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save(address, packed_scene)

func load_in(folder, ship):
	
	# set vars
	shipBody = ship
	print("grid shipbody: ", shipBody)
	
	# load blocks
	
	# navigate to blocks directory
	var directory = Directory.new()
	directory.open(folder)
	directory.change_dir("Blocks")
	var address = directory.get_current_dir()
	
	# cycle through blocks
	var bname
	var block_preload
	var block
	var block_folder
	
	directory.list_dir_begin(true, false)
	bname = directory.get_next()
	
#	print ("bname:" + bname)
#	print (address)
	
	while bname != "":
		# instantiate block
		block_folder = address + "/" + bname
		block_preload = load(block_folder + "/" + bname + ".tscn")
		block = block_preload.instance()
		add_child(block)
		
		# tell block to load in
		block.load_in(block_folder, self, folder, bname)
		
		# add block
		add_block(block, block.center_grid_coord)
		block_dict[block.center_grid_coord] = block
		print("block loaded: " + block.name)
		print(block.center_grid_coord)
		
		bname = directory.get_next()
	
	directory.list_dir_end()
	
	print("blocks loaded")
	
	# load storage
	
	# search and destroy false storage
	storage = $GridBase_Storage
	if (storage != null):
		storage.free()
	
	# load storage
	var storage_packed = load(folder + "/" + name + "_storage.tscn")
	storage = storage_packed.instance()
	add_child(storage)
	print("grid storage: " + storage.name)
	
	storage.load_data(self)
