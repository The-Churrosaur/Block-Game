# block grid manager, should hold blocks as child nodes

class_name GridBase
extends Node2D

export var grid_size = 64 # base

# TODO do these by path exports?
onready var shipBody = get_parent()
var shipInfo
onready var anchor = $GridAnchor
onready var tilemap : TileMap = get_parent().get_node("ShipTileMap")
onready var tilemap_remote : RemoteTransform2D = $TileMapRemote

# defunct
onready var storage = $GridBase_Storage

export var test_dict = {}

onready var num_blocks : int = 0
onready var gross_blocks : int = 0 # just for bad uid for now
var block_dict = {} # master dictionary of grid
# blocks are organized in a dict of vector2 -> node
# hashes all given positions as references to given block
# this is marginally expensive for saving/loading

signal block_added(coord, block, grid, update_com)
signal block_removed(coord, block, grid, update_com) 
# be wary of holding the reference to a dying block

func _ready():
	print("NEW GRID READY")
	
	# setup tilemap transform
	tilemap_remote.remote_path = tilemap.get_path()
	# to upper corner of 0,0 block : ergo tile pos == block pos
	tilemap_remote.position -= Vector2(grid_size/2, grid_size/2)

func _enter_tree():
	print("GRID ENTERED TREE")

#func set_vars_from_info(info):
#	if info is ShipInfo:
#		print (info.grid_size)
#		grid_size = info.grid_size

func get_block(pos : Vector2) -> Node2D:
	if block_dict.has(pos):
		return block_dict[pos]
	else:
		return null

func add_block(block, center_coord, facing, check_blocked = true, update_com = true):
	
	# add tile to tilemap
	tilemap.set_cellv(center_coord, block.tile_id)
	tilemap.rotate_tilev(center_coord, facing)
	
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
	position_block(center_coord, facing)
	
	# inject info to new block
	if block is Block:
		block.on_added_to_grid(center_coord, block, self)
		block.block_id = new_block_id()
		# would need reference to connect signal
	
	# COM recalcing (also picked up by block systems) 
	emit_signal("block_added", center_coord, block, self, update_com)
	
	num_blocks += 1
	gross_blocks += 1
	return true


func add_block_at_point(block : Block, point : Vector2, facing : int):
	
	var coord = get_gridFromPoint(point)
	add_block(block, coord, facing)


func new_block_id() -> int:
	
	# this is eh but w/e for now
	return gross_blocks;


func remove_block(pos : Vector2) -> bool:
	if block_dict.has(pos):
		var block = block_dict[pos]
		
		# calls cleanup on block, can abort here
		var cancel = block.on_removed_from_grid(pos, block, self)
		if cancel:
			print("block cancelled removal")
			return false
		
		block_dict.erase(pos)
		emit_signal("block_removed", pos, block, self, true)
		block.queue_free()
		num_blocks -= 1
		
		# remove from tilemap
		tilemap.set_cellv(pos, -1)
		
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

func get_blockFromPoint(point : Vector2):
	return get_block(get_gridFromPoint(point))

func position_block(pos : Vector2, facing):
	if !block_dict.has(pos):
		return false
	else: 
		var block = block_dict[pos]
		block.position = pos as Vector2 * grid_size
		
		# covers null case for legacy ships etc.
		if facing is int:
			block.set_facing(facing)
		else:
			block.set_facing(0)
	

func position_all_blocks():
	for p in block_dict.keys():
		position_block(p as Vector2, block_dict[p].block_rotation)

func post_load_block_setup():
	
	# iterate through blocks, call setup
	for pos in block_dict.keys():
		block_dict[pos].post_load_setup()

# SAVING AND LOADING ===========================================================
# this is all defunct old shit

signal save_blocks(name, folder)

func save(folder):
	print("grid saving: " + name)
	
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

# MOTHER FUCK TODO
var tim = 100
func _process(delta):
#	tim -= 1
#	if tim == 0:
#		print("==============================")
#		print(self, position, global_position)
#		print(shipBody.subShips)
#		for ship in shipBody.subShips.values():
#			print("parent: ", ship.get_parent())
#			print("grid: ",ship.grid)
#			for block in ship.grid.block_dict.values():
#				print(block)
#		tim = 100
		pass

func load_in(folder, ship):
	
	# reset pos (will be set when blocks added)
	position = ship.position
	
	# set vars
	shipBody = ship
	
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
		add_block(block, block.center_grid_coord, 0)
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
