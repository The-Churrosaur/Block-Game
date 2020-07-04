class_name Block
extends Node2D

# relative grid of block positions
const size_grid = [Vector2(0,0)] 
# ie. a 1x2 spire would be [0,0 , 0,1]

# public array of collisionshapes, populated on load
var hitbox_collision_shapes = [] 
export var hitbox_names_string = "Hitbox"

export var mass = 100

onready var storage = $Block_Storage

# owned by grid, no touch vvv

var grid : Node2D = null
var grid_coord = [] # DEFUNCT just in case self-reference to find itself through grid
var center_grid_coord : Vector2 # center coordinate of block
var shipBody

export var saved = false

func _ready():
	set_hitbox_collision_shapes()
	
#	if saved:
#		load_in()
	pass

func set_hitbox_collision_shapes():
	for node in get_children():
		if (node is CollisionShape2D) and (node.name == hitbox_names_string):
			hitbox_collision_shapes.append(node)
			node.disabled = true
	pass

# TODO give full coordinates for deletion (or should it recreate from local?)
func on_added_to_grid(center_coord, block, grid):
	
	# vars from grid
	self.grid = grid
	self.center_grid_coord = center_coord
	shipBody = grid.shipBody
	
	# grid signals
	grid.connect("save_blocks", self, "on_save_blocks")

# SAVING AND LOADING ===========================================================
#TODO do some c# shit to make this not garbage

func on_save_blocks(name, folder):
	
	# new folder
	
	var directory = Directory.new()
	directory.open(folder)
	directory.make_dir(self.name)
	directory.change_dir(self.name)
	var new_folder = directory.get_current_dir()
	
	# save self 
	
	var address = new_folder + "/" + self.name + ".tscn"
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save(address, packed_scene)
	
	saved = true

func load_in():
	storage.load_data()
