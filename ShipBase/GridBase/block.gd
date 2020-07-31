class_name Block
extends Node2D

# relative grid of block positions
const size_grid = [Vector2(0,0)] 
# ie. a 1x2 spire would be [0,0 , 0,1]

# public array of collisionshapes, populated on load
var hitbox_collision_shapes = [] 
export var hitbox_names_string = "Hitbox"

export var mass = 100

# if block has storage
var storage
export var data_block = true 
export var storage_type = "Block_Storage"
var saved_name

# owned by grid, no touch vvv

var grid : Node2D = null
var grid_coord = [] # DEFUNCT just in case self-reference to find itself through grid
var center_grid_coord : Vector2 # center coordinate of block
var shipBody

func _ready():
	storage = get_node(storage_type)
	sanitize_name()
	set_hitbox_collision_shapes()

# removes the @node@ from node name
# don't ask...
func sanitize_name():
	var chars = name
	name = chars

func set_hitbox_collision_shapes():
	for node in get_children():
		if (node is CollisionShape2D) and (node.name == hitbox_names_string):
			hitbox_collision_shapes.append(node)
			node.disabled = true
	pass

# TODO give full coordinates for deletion (or should it recreate from local?)
func on_added_to_grid(center_coord, block, grid):
	# vars from grid
	self.center_grid_coord = center_coord
	self.grid = grid
	shipBody = grid.shipBody
	print("block shipbody: ", shipBody)
	# grid signals
	grid.connect("save_blocks", self, "on_save_blocks")

func on_removed_from_grid(center_coord, block, grid):
	pass

# SAVING AND LOADING ===========================================================
#TODO do some c# shit to make this not hot garbage

func on_save_blocks(folder, ship_folder):
	
	print("block saving: " + name)
	
	# new folder
	
	var directory = Directory.new()
	directory.open(folder)
	directory.make_dir(self.name)
	directory.change_dir(self.name)
	var new_folder = directory.get_current_dir()
	
	# save data
	storage.save(self, new_folder)
	
	# save self 
	
	var address = new_folder + "/" + self.name + ".tscn"
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save(address, packed_scene)
	
	return new_folder # for inheriting blocks

func load_in(folder, grid, ship_folder, old_name):
	set_name(old_name)
	print("block loading: " + name)
	
	# vars should be recreated from data/when grid adds block
	
	# load storage
	load_storage(folder)
	print("block position: ", position, global_position)
	print("grid position: ", grid.position)

func load_storage(folder):

	# remove false storage
	storage = get_node_or_null(storage_type)
	if (storage != null):
		storage.free()
	
	# load storage
	var storage_packed = load(folder + "/" + name + "_storage.tscn")
	storage = storage_packed.instance()
	add_child(storage)
	
	# get data from storage
	storage.load_data(self)
