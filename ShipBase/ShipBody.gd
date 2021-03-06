# physics and editor wrapper for a block grid

# TODO, do things with an assigned hash shipID instead of by name 

class_name ShipBody
extends RigidBody2D

export var save_directory = "res://Ships/"
export var given_name = ""
export var default_mass = 0.01

onready var ship_save = load("res://ShipBase/ShipSave.gdns").new()
func call_test(param):
	print("method called: ", param)

onready var storage = $ShipBase_Storage
onready var grid = $GridBase
# ShipBody changes position with COM because godot
# grid position moves with ShipBody BUT
# grid position remains relative to ShipBody at original scene origin

# use grid position for ship local coordinates/origin
var grid_origin setget ,grid_origin
func grid_origin():
	#grid_origin = grid.global_position
	return grid_origin


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
signal shipBody_saved(shipBody, name, file)

# dict of subships, node paths repopulated on load
var subShips = {}
# name -> ship
func get_subShips():
	return subShips

func _ready():
	
	# test gdns 
#	ship_save.test(self, self)
#	print("shipsave blockspath: ", ship_save.blocksFilepath)
	
	print("NEW SHIP READY")
	
	# just in case
	if grid != null:
		connect_to_grid(grid)
	
	input_pickable = true
	
	subShips[name] = self;
	print("subships: ", subShips)

func connect_to_grid(grid):
	grid.connect("block_added", self, "on_grid_block_added")
	grid.connect("block_removed", self, "on_grid_block_removed")

func _unhandled_input(event): # test func

	# when clicked, emits signal that has been clicked
	
	if event.is_action("ui_mclick"):
		print("ship: input mclick ", name)
		emit_signal("on_clicked", self)
		#get_tree().set_input_as_handled()

func is_shipBody() -> bool: # lul
	return true

func on_new_subShip(ship, pinBlock, pinHead): # called by pinblocks
	print("ship:", self, "new subship received: ", ship)
	subShips[ship.name] = ship
	print("subships:", subShips)

func on_subShip_removed(ship, pinBlock, pinHead):
	subShips.erase(ship.name)
	print("SUBSHIP REMOVED, ship: ", name, " subships ",subShips)

func _integrate_forces(state):
#	int_forces_reposition()
	pass

# RIGIDBODY HELPERS -===========================================================

# DEFUNCT - set position is fine, issue is physics timer vs. update timer

## sets flags, updates position in _integrate_forces()
#var reposition = false
#var repos_target : Vector2
#
#func reposition(pos : Vector2):
#	reposition = true
#	repos_target = pos
#
## call this in _integrate_forces
#func int_forces_reposition():
#	if (reposition):
#		position = repos_target
#		print("RB REPOS: ", position, global_position)
#		reposition = false

# BLOCK PLACEMENT ==============================================================

func on_grid_block_added(coord, block, grid, update_com):
	
	# edit COM/position, append mass
	
	if update_com : update_com(block)
#	print("after com update: ", global_position)
	
	# add block collisionShapes to the ship, log them in the dict
	# depreciated, probably do this through tilemap
	
#	for block_collider in block.hitbox_collision_shapes:
#		var collider = CollisionShape2D.new()
#		grid.add_child(collider)
#		collider.owner = self
#		collider.shape = block_collider.shape
#
#		# preserves collider position relative to block
#		collider.position = block.position + block_collider.position
#		print("collider pos:", collider.position)
#
#		block_collision_dict[collider] = block
#		block_collision_dict[block] = collider

func update_com(block, invert = false): # also updates mass
	if !(block is Block):
		return
	
	print("BLOCK ADDED: ", block.name)
	
	if (invert):
		block.mass *= -1
	
	var combined_mass
	if (mass < 1): # rounds out editor minimum for empty grid
		combined_mass = block.mass
	else:
		combined_mass = mass + block.mass
	
	var block_vec = grid.position + block.position # from here (from ship)
	
	# relative COM calculation
	var com_relative
	# if mass is zero TODO
	assert(combined_mass > 0)
	if combined_mass <= 0:
		# TODO something here
		return 
	else:
		# relative COM = m2x2 / total
		var com_x = block.mass * block_vec.x / combined_mass
		var com_y = block.mass * block_vec.y / combined_mass
		
		# round out float errors
		com_x = round(com_x)
		com_y = round(com_y)
		
		com_relative = Vector2(com_x, com_y)
	
#	print("com vec: ", com_relative)
#	print("old grid pos: ", grid.position, grid.global_position)
#	print("grid mass: ", mass)
#	print("old ship position", position, global_position)
	
	# rotationally, both grid and com vec are in reference frame under ship
	grid.position -= com_relative
	
	# put com vector in reference frame alongside ship
	var com_rotated = com_relative.rotated(rotation)
	position += com_rotated
	
	mass = combined_mass
	
#	print("new mass: ", mass)
#	print("block: ",block.position, block.global_position)
#	print("mass: ", block.mass)
#	print("mass shifting ship position", position, global_position)
#	print("grid position: ", grid.position, grid.global_position)


func on_grid_block_removed(coord, block, grid, update_com):
	
	# update com in reverse
	
	if update_com: update_com(block, true)
	
	# remove block and collisionshape from dict, delete collisionshape
	# depreeeeeeeeeeeeeeciated
	
#	var collider = block_collision_dict[block]
#	block_collision_dict.erase(block)
#	block_collision_dict.erase(collider)
#	collider.queue_free() # mark for deletion

# gets block from coordinate
func get_block(coord : Vector2):
	return grid.block_dict[coord]

# INGAME LOGIC =================================================================

func on_force_requested(pos, magnitude, central = false):
	print("force requested")
	if central:
		add_central_force(magnitude)
	else:
		add_force(grid.position + pos, magnitude)
	pass

# SAVING AND LOADING ===========================================================

func save(name = self.name, dir = save_directory):
	
	# set self name (for reference and loading)
	self.name = name
	given_name = name # probably redundant
	print("ship saving: " + name)
	
	var file = ship_save.save(self, name, dir)
	emit_signal("shipBody_saved", self, name, file)

#func save_as_subShip(dir = save_directory, name = self.name):
#	pass
#
#signal saving_ship(ship, dir)
#signal saved (name, address)
#signal save_to_storage(ship)
#
#func save_old(name, dir = save_directory):
#
#	# set self name (for reference and loading)
#	self.name = name
#	given_name = name
#	print("ship saving: " + name)
#
#	# navigate a directory, make new folder
#
#	var directory = Directory.new()
#	directory.open(dir)
#	directory.make_dir(name) 
#	directory.change_dir(name)
#	var folder = directory.get_current_dir()
#
#	# make auxiliary folders
#	directory.make_dir("SubShips")
#
#	# announce
#	emit_signal("saving_ship", self, folder)
#
#	# start chain of children saving 
#	# -> save grid -> save blocks
#	grid.save(folder)
#
#	# save ship data
#	print("ship storage: " + storage.name)
#	storage.save(self, folder)
#	print("storage saved")
#	# save scene under folder
#
#	var address = folder + "/" + name + ".tscn"
#	var packed_scene = PackedScene.new()
#	packed_scene.pack(self)
#	ResourceSaver.save(address, packed_scene)
#
#	emit_signal("saved", name, address)
#	print(name + " saved")
#
#func load_in_old(folder):
#
#	# reset mass before reloading grid/blocks
#	mass = default_mass
#
#	# set name
#
#	# load grid
#
#	# seach and destroy false grid
#	grid = $GridBase
#	if (grid != null):
#		grid.free() # not queue_free() since queue would fire after resetting
#
#	# load grid (+ add child and get grid reference)
#	var grid_packed = load(folder + "/GridBase.tscn")
#	grid = grid_packed.instance()
#	add_child(grid)
#	grid.owner = self
#	connect_to_grid(grid)
#
#	# tell grid to load in
#	grid.load_in(folder, self)
#	print("!!!grid new:", grid, position, grid.position, grid.global_position)
#	# load storage
#
#	# remove false storage
#	storage = $ShipBase_Storage
#	if (storage != null):
#		storage.free()
#
#	# load storage
#	var storage_packed = load(folder + "/" + name + "_storage.tscn")
#	storage = storage_packed.instance()
#	add_child(storage)
#
#	# get stored data
#	storage.load_data(self)
#
#	# testo
#	print("loaded", global_position)
