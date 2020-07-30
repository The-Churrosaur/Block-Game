#physics wrapper for a block grid

class_name ShipBody
extends RigidBody2D

export var save_directory = "res://Ships"
onready var storage = $ShipBase_Storage
export var given_name = ""

onready var grid = $GridBase
# ShipBody changes position with COM because godot
# grid position moves with ShipBody BUT
# grid position remains relative to ShipBody at original scene origin

# use grid position for ship local coordinates/origin
var grid_origin setget ,grid_origin
func grid_origin():
	grid_origin = grid.global_position
	return grid_origin

#TODO some way to serialize vvv

var block_collision_dict = {}
# CollisionShape2D -> Block
# tells blocks when they've gone cronch

# also holds references in reverse (Block -> Collisionshape)
# for deletion once the block has gone cronch

# TODO this feels inelegant af.
# - is holding hitboxes on the ship necessary? 
# - single polygon that switches owners (collider has to be direct child)
# - performance of individual block hitboxes?
# - find collision point then manually calculate

var supergrid = null

signal on_clicked(shipBody)

func _ready():
	
	grid.connect("block_added", self, "on_grid_block_added")
	grid.connect("block_removed", self, "on_grid_block_removed")
	
	input_pickable = true

func _unhandled_input(event):

	# when clicked, emits signal that has been clicked
	
	if event.is_action("ui_mclick"):
		print("ship: input mclick ", name)
		emit_signal("on_clicked", self)
		#get_tree().set_input_as_handled()

func on_grid_block_added(coord, block, grid):
	
	# edit COM/position, append mass
	
	update_com(block)
	
	# add block collisionShapes to the ship, log them in the dict
	
	for block_collider in block.hitbox_collision_shapes:
		var collider = CollisionShape2D.new()
		grid.add_child(collider)
		collider.owner = self
		collider.shape = block_collider.shape
		
		# preserves collider position relative to block
		collider.position = block.position + block_collider.position
		print(collider.position)
		
		block_collision_dict[collider] = block
		block_collision_dict[block] = collider

func update_com(block, invert = false): # also updates mass
	if !(block is Block):
		return
	
	if (invert):
		block.mass *= -1
	
	if (mass <= 0.02): # editor limit
		mass = 0 
	
	var coord_abs = block.global_position
	var com_x = (position.x * mass) + (coord_abs.x * block.mass)
	var com_y = (position.y * mass) + (coord_abs.y * block.mass)
	
	mass += block.mass
	com_x /= mass
	com_y /= mass
	var com = Vector2(com_x,com_y)
	
	grid.global_position += (position - com)
	position = com
	
	print (block.global_position)
	print (position)

func on_grid_block_removed(coord, block, grid):
	
	# update com in reverse
	
	update_com(block, true)
	
	# remove block and collisionshape from dict, delete collisionshape
	
	var collider = block_collision_dict[block]
	block_collision_dict.erase(block)
	block_collision_dict.erase(collider)
	collider.queue_free() # mark for deletion
	
	pass

func on_force_requested(pos, magnitude, central = false):
	print("force requested")
	if central:
		add_central_force(magnitude)
	else:
		add_force(grid.position + pos, magnitude)
	pass

# SAVING AND LOADING ===========================================================

signal saving_ship(ship, dir)
signal saved (name, address)
signal save_to_storage(ship)

func save(name, dir = save_directory):
	
	# set self name (for reference and loading)
	self.name = name
	given_name = name
	print("ship saving: " + name)
	
	# navigate a directory, make new folder
	
	var directory = Directory.new()
	directory.open(dir)
	directory.make_dir(name) 
	directory.change_dir(name)
	var folder = directory.get_current_dir()
	
	# make auxiliary folders
	directory.make_dir("SubShips")
	
	# announce
	emit_signal("saving_ship", self, folder)
	
	# start chain of children saving 
	# -> save grid -> save blocks
	grid.save(folder)
	
	# save ship data
	print("ship storage: " + storage.name)
	storage.save(self, folder)
	
	# save scene under folder
	
	var address = folder + "/" + name + ".tscn"
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save(address, packed_scene)
	
	emit_signal("saved", name, address)
	print(name + " saved")

func load_in(folder):
	
	# load grid
	
	# seach and destroy false grid
	grid = $GridBase
	if (grid != null):
		grid.free() # not queue_free() since queue would fire after resetting
	
	# load grid (+ add child and get grid reference)
	var grid_packed = load(folder + "/GridBase.tscn")
	grid = grid_packed.instance()
	add_child(grid)
	
	# tell grid to load in
	grid.load_in(folder, self)
	
	# load storage
	
	# remove false storage
	storage = $ShipBase_Storage
	if (storage != null):
		storage.free()
	
	# load storage
	var storage_packed = load(folder + "/" + name + "_storage.tscn")
	storage = storage_packed.instance()
	add_child(storage)
	
	# get stored data
	storage.load_data(self)
	print(storage.grid_address) # test loaded
