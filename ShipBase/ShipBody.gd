# physics and editor wrapper for a block grid

# TODO, do things with an assigned hash shipID instead of by name 

class_name ShipBody
extends RigidBody2D

export var save_directory = "res://Ships/"
export var display_name = "MyShip" # set by player, ingame name
export var default_mass = 0.01

onready var ship_save = load("res://ShipBase/ShipSave.gdns").new()
func call_test(param):
	print("method called: ", param)

onready var save_name = display_name + "0"

onready var storage = $ShipBase_Storage
onready var grid = $GridBase
# ShipBody changes position with COM because godot
# grid position moves with ShipBody BUT
# grid position remains relative to ShipBody at original scene origin

onready var tilemap : TileMap = $ShipTileMap

# TODO ship systems 
onready var io_manager = $IOManager

# use grid position for ship local coordinates/origin
var grid_origin setget ,grid_origin
func grid_origin():
	#grid_origin = grid.global_position
	return grid_origin

var supergrid = null

# most recent collision, updated every tick
var collision_pos : Vector2
var collision_normal : Vector2

signal on_clicked(shipBody, block)
signal shipBody_saved(shipBody, name, file)
signal new_subShip(shipBody, subShip, pinBlock)

# dict of subships, node paths repopulated on load
var subShips = {}
# name -> ship
func get_subShips():
	return subShips
var subShip_counter = 0

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
	
	# collision handling
	connect("body_shape_entered", self, "on_body_shape_entered")
	
	# setup systems / children 
	# currently just io
	io_manager.setup(self)

func connect_to_grid(grid):
	grid.connect("block_added", self, "on_grid_block_added")
	grid.connect("block_removed", self, "on_grid_block_removed")

func _integrate_forces(state):
#	int_forces_reposition()
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		# it appears this is actually getting global position? is it?
		collision_pos = state.get_contact_local_position(0)
		collision_normal = state.get_contact_local_normal(0)
	pass

#func _input_event(viewport, event, shape_idx): # test func
#
#	# when clicked, emits signal that has been clicked
#
#	if event.is_action("ui_lclick"):
#		print("ship: input click ", self)
#		print("at: ", get_global_mouse_position())
#		var clicked_block = grid.get_blockFromPoint(get_global_mouse_position())
#		emit_signal("on_clicked", self, clicked_block)
#		#get_tree().set_input_as_handled()

# look, ^he's being a shit so we're here now
# TODO this would be far more elegant under the picker instead of the pickee
func _unhandled_input(event):
	
	if event.is_action("ui_lclick"):
		
		# query the physics server for click
		var state = get_world_2d().direct_space_state
		var intersections = state.intersect_point(get_global_mouse_position())
		for hit in intersections:
			if hit.collider == self:
				print("ship: input click ", self)
				print("at: ", get_global_mouse_position())
				var clicked_block = grid.get_blockFromPoint(get_global_mouse_position())
				emit_signal("on_clicked", self, clicked_block)

func is_shipBody() -> bool: # lul
	return true

func on_new_subShip(ship, pinBlock, pinHead): # called by pinblocks
	print("ship:", self, "new subship received: ", ship)
	# hacky, but keeps names unique for now
	ship.name = name + "_subship" + str(subShip_counter) + "_" + ship.name
	subShips[ship.name] = ship
	print("subships:", subShips)
	subShip_counter += 1
	
	emit_signal("new_subShip", self, ship, pinBlock)

func on_subShip_removed(ship, pinBlock, pinHead):
	subShips.erase(ship.name)
	print("SUBSHIP REMOVED, ship: ", name, " subships ",subShips)
	subShip_counter -= 1

# BLOCK PLACEMENT ==============================================================

func on_grid_block_added(coord, block, grid, update_com):
	
	# edit COM/position, append mass
	if update_com : update_com(block)

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

# gets block from coordinate
func get_block(coord : Vector2):
	if grid.block_dict.has(coord):
		return grid.block_dict[coord]
	else:
		 return null

func post_load_block_setup():
	grid.post_load_block_setup()

# INGAME LOGIC =================================================================

func on_force_requested(pos, magnitude, central = false):
	print("force requested")
	if central:
		add_central_force(magnitude)
	else:
		add_force(grid.position + pos, magnitude)
	pass

func on_body_shape_entered (body_id, body, body_shape, local_shape):
	
	# get block coord from tilemap
	# rotation messes this up, temp disabled
#	var pos = collision_pos + collision_normal
#	var coord = tilemap.world_to_map(tilemap.to_local(pos))
#
#	# get block from grid
#	var block = grid.block_dict[coord]
#
#	print("ship body entered", pos, coord, block)
#
#	# notify block
#	block.ship_body_entered(body, pos)
	
	pass

# SAVING AND LOADING ===========================================================

func save(name = self.name, dir = save_directory):
	
	# set self name (for reference and loading)
	self.name = name
	display_name = name # probably redundant
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
#	display_name = name
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
