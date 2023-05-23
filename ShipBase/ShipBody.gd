# physics and editor wrapper for a block grid, the big salami

# TODO, do things with an assigned shipID instead of by name maybe?
# please please

# TODO this class is a visual mess


class_name ShipBody
extends RigidBody2D



# FIELDS =======================================================================


export var editor_mode = false

export var save_directory = "res://Ships/"
export var display_name = "MyShip" # set by player, ingame name
# UNIQUE, set by player or by root ship for subships
# used for save directory
export var ship_id : String 
export var default_mass = 0.01

export var selected = false

#onready var ship_save = load("res://ShipBase/ShipSave.gdns").new()
# TESTING GDSCRIPT
onready var ship_save = Ship_SaverLoader_GDS.new()

func call_test(param):
	print("method called: ", param)

#onready var save_name = display_name + "0"
#onready var storage = $ShipBase_Storage

# ship specific subship ID
# local address to find subships (used for cables etc)

# 0 for base ship, subships iterate, 0001 for second subship thrice nested
# injected by parent ship on prompting from pinblock
# TODO maybe this is terrible
onready var subShip_id = 0

onready var grid = $GridBase
# ShipBody changes position with COM because godot
# grid position moves with ShipBody BUT
# grid position remains relative to ShipBody at original scene origin

onready var tilemap : TileMap = $ShipTileMap

# DEPREC
onready var io_manager = $IOManager

onready var ship_systems = $ShipSystems

# use grid position for ship local coordinates/origin
var grid_origin setget ,grid_origin
func grid_origin():
	#grid_origin = grid.global_position
	return grid_origin

# most recent collision, updated every tick
var collision_pos : Vector2
var collision_normal : Vector2

# -- COLLISION SHAPES

# dictionary of collision shapes: shape->block
var collision_shapes = {}

# reverse dictionary of collision shapes: block->array of shapes
# used on block removal, this whole system is kept anonymous from block
var block_collisions = {}

# connects shape owners on shipbody to collision shapes
# for onbodyenter
var collider_shape_owners = {}

# -- SIGNALS

signal on_clicked(shipBody, block, event)
signal shipBody_saved(shipBody, name, file)
signal new_subShip(shipBody, subShip, pinBlock)
signal ship_com_shifted(old_pos, relative_displacement)
signal ship_destroyed(shipBody)

var superShip = null
var is_subShip = false

# dict of subships, node paths repopulated on load
var subShips = {}
# ship_id -> ship
# TODO, subships save parent ship as a valid subship maybe
func get_subShips():
	return subShips
var subShip_counter = 0

# loaded information
# store at block building pass to use for systems / connection pass
var loaded_data : Dictionary



# CALLBACKS ====================================================================



func _ready():
	
	print("NEW SHIP READY")
	
	# just in case
	if grid != null:
		grid.connect("block_added", self, "on_grid_block_added")
		grid.connect("block_removed", self, "on_grid_block_removed")
		grid.connect("grid_empty", self, "on_grid_empty")
	
	input_pickable = true
	
#	subShips[name] = self;
#	print("subships: ", subShips)
	
	# collision handling
	connect("body_shape_entered", self, "on_body_shape_entered")
	
	# setup systems / children 
	# currently just io
	io_manager.setup(self)
	
	
	# ??? TODO
	inertia = 0


func _integrate_forces(state):
#	int_forces_reposition()
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		# it appears this is actually getting global position? is it?
		collision_pos = state.get_contact_local_position(0)
		collision_normal = state.get_contact_local_normal(0)
	pass

func _on_ShipBody_input_event(viewport, event, shape_idx):
	print("SHIPBODY INPUT EVENT: shape_idx ", shape_idx)
	

func _print_shape_owners():
	print("")
	print("shape owners: ", get_shape_owners())
	for i in get_shape_owners():
		var owner_owner = shape_owner_get_owner(i)
		print(i, ": owner_owner: ", owner_owner)
		print("----", shape_owner_get_shape(i, 0))
		if collision_shapes.has(owner_owner):
			print("----block: ", collision_shapes[owner_owner])
		else:
			print("----no block")
	
	print("")


# collider input callback
# finds and tells blocks when clicked
func _input_event(viewport, event, shape_idx):
#	print("\nSHIPBODY INPUT CALLBACK. shape_idx: ", shape_idx)
	
#	_print_shape_owners()
	
	# get block from shape owner index, see collision section
#	print("shape owner shape count: ", shape_owner_get_shape_count(shape_idx))
	var collider = shape_owner_get_owner(shape_idx)
#	print("collider: ", collider)
	if collision_shapes.has(collider):
		var block = collision_shapes[collider]
		emit_signal("on_clicked", self, block, event)
	else:
		print("SHIPBODY INPUT CALLBACK SHAPE NOT IN COLLISION DICT: ", collider)


# TODO breaks when hitbox > grid 
func _unhandled_input(event):
	
	# this works but is a little haphazard, 
	# currently doing input above
	
#	if event.is_action("ui_lclick"):
#
#		# query the physics server for click
#		var state = get_world_2d().direct_space_state
#		var intersections = state.intersect_point(get_global_mouse_position())
#		for hit in intersections:
#			if hit.collider == self:
#				print("ship: input click ", self)
#				print("at: ", get_global_mouse_position())
#				var clicked_block = grid.get_blockFromPoint(get_global_mouse_position())
#				if clicked_block == null: return
#				emit_signal("on_clicked", self, clicked_block)
#				print("signal emitted")
	
	pass


func is_shipBody() -> bool: # quack quack quack
	return true


# -- SUBSHIPS AND ROOT SHIP 


func get_rootShip() -> ShipBody:
	if superShip == null: return self
	else: return superShip.get_rootShip()


# ONLY returns current level subships
func get_subShip(id) -> ShipBody:
	if id == ship_id: 
		return self
	else:
		return subShips.get(id)


# returns any lower level subhip
# recursive dfs
func get_subShip_recursive(id) -> ShipBody:
	
	if id == ship_id: return self

	for s in subShips.values():
		var out = s.get_subShip_recursive(id)
		if out != null: return out
	
	return null


# get any ship in tree, traverses to root then finds subship
func get_ship_in_tree(id) -> ShipBody:
	return get_rootShip().get_subShip_recursive(id)


func on_new_subShip(ship, pinBlock, pinHead): # called by pinblocks
	
	print("ship:", self, "new subship received: ", ship)
	
	# repeats will trigger on new subships (from pinblock)
	if subShips.has(ship.ship_id):
		ship.ship_id = new_subShip_ship_id(ship)
	
	subShips[ship.ship_id] = ship
	ship.superShip = self
	ship.is_subShip = true
	
	# TODO this will break ships that are saved when a subship is selected
	
	# append subShip id
	# TODO? currently overriden on each load
	ship.subShip_id = str(subShip_id) + str(subShip_counter)
	
	print("subships:", subShips)
	print("subships:", subShips)
	subShip_counter += 1
	
	# add self to subship's subships
#	ship.subShips[name] = self
	# BAD, causes infinite loop in saving
		
	emit_signal("new_subShip", self, ship, pinBlock)


func on_subShip_removed(ship, pinBlock, pinHead):
	subShips.erase(ship.name)
	print("SUBSHIP REMOVED, ship: ", name, " subships ",subShips)
	subShip_counter -= 1


# hacky, but keeps ids  unique for now
func new_subShip_ship_id(ship) -> String:
	return ship_id + "_subship" + str(subShip_counter) + "_" + ship.ship_id


# called by supership when moved (new block)
func on_superShip_moved(super):
	grid.on_superShip_moved(super)
	# just useful for now


# moves ship AND ALL SUBSHIPS to target pos
 


# BLOCK PLACEMENT ==============================================================



func on_grid_block_added(coord, block, grid, update_com):
	
	# add shapes
	add_block_colliders(block)
	
	# edit COM/position, append mass
	if update_com : update_com(block)


# append block colliders to ship
func add_block_colliders(block):
	
	var shapes = []
	for shape in block.hitbox_collision_shapes:
		var new_shape = add_shape(shape, shape.global_position, block.rotation)
#		print("shape placing position: ", position+block.position+shape.position)
#		print("shape old position: ", shape.global_position)
		shapes.append(new_shape)
		
		# disable shape on block
		shape.queue_free()
		
		# add each shape to dict
		collision_shapes[new_shape] = block
	
	# add all shapes to block dict
	block_collisions[block] = shapes


func remove_block_colliders(block):
	
	# remove from dicts
	var colliders = block_collisions[block]
	for collider in colliders:
		collision_shapes.erase(collider)
	block_collisions.erase(block)
	
	# delete
	for collider in colliders:
		remove_child(collider)
		collider.queue_free()
	
	# belabored sigh...
	# call deferred or the physics engine complains
	call_deferred("rejigger_shapes")


# appends a collisionshape to the ship
# creates and returns new collisionshape2D as child
# pos is global position (a little inelegant, think about this TODO)
func add_shape(col_shape : CollisionShape2D, pos : Vector2, block_rot) -> CollisionShape2D:
	
#	print("shipbody adding shape: ", col_shape)
	
	var shape_2d = col_shape.shape
	
	# add collisionshape2d as child
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape_2d
	collision_shape.position = .to_local(pos)
	collision_shape.rotation = block_rot
	
	add_child(collision_shape)
	collision_shape.owner = self
	
	return collision_shape


# unparents and reparents all collision shapes
# this is slow, and tedious and bad BUT
# TODO report bug
# stops rigidbody from returning nonsensical shape owner indexes after deletion
func rejigger_shapes():
	
	print("rejiggering colliders")
	
	for collider in collision_shapes.keys():
		remove_child(collider)
	for collider in collision_shapes.keys():
		add_child(collider)
	
#	_print_shape_owners()

# moves grid, also updates mass, and updates colliders
# returns old position
# everything that moves when the grid moves is in here for now
func update_com(block, invert = false): # also updates mass
	if !(block is Block):
		return
	
	print("BLOCK UPDATING COM: ", block.name)
	
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
	
	# move colliders along with grid
	for collider in collision_shapes.keys():
#		print("shifting collider: ", collider)
		collider.position -= com_relative
	
	var old_pos = position
	
	# put com vector in reference frame alongside ship
	var com_global = com_relative.rotated(rotation)
	position += com_global
	
	mass = combined_mass
	
#	print("new mass: ", mass)
#	print("block: ",block.position, block.global_position)
#	print("mass: ", block.mass)
#	print("mass shifting ship position", position, global_position)
#	print("grid position: ", grid.position, grid.global_position)
	
	
	# tells whoever else needs to know that we moved
	# ie. pinblocks
	emit_signal("ship_com_shifted", old_pos, com_relative)
	
	return old_pos


func on_grid_block_removed(coord, block, grid, update_com):
	
	print("SHIPBODY REMOVING BLOCK: ", block)
	
	# update com in reverse
	
	if update_com: update_com(block, true)
	
	remove_block_colliders(block)


# gets block from coordinate
func get_block(coord : Vector2):
	if grid.block_dict.has(coord):
		return grid.block_dict[coord]
	else:
		 return null


# kinda slow, iterates to find closest block to point
func get_closest_block(global_coord : Vector2):
	
	var closest_distance
	var closest = null
	
	for block in grid.block_dict.values():
		var distance = block.global_position.distance_squared_to(global_coord)
		if (closest == null) or (distance < closest_distance):
			closest_distance = distance
			closest = block
	
	return closest


func post_load_block_setup():
	grid.post_load_block_setup()


# INGAME LOGIC =================================================================


func destroy_self():
	print("SHIP SELF-DESTRUCTING")
	emit_signal("ship_destroyed", self)
	queue_free()


# selected by player
func select_ship():
	selected = true
	modulate = Color(0.7,1,1,1)


func deselect_ship():
	selected = false
	modulate = Color(1,1,1,1)


func on_force_requested(pos, magnitude, central = false):
	if central:
		apply_central_impulse(magnitude)
	else:
		apply_impulse(grid.position + pos, magnitude)
	pass


# COLLISIONS
# fyi, local_shape returns shapeowner index
func on_body_shape_entered (body_id, body, body_shape, local_shape):
	
	if body == self: return
	
#	print("SHIPBODY SHAPE ENTERED ", body)
	
	# get shape
	var shape = shape_owner_get_shape(local_shape, 0)
	
	# gets collisionobject2d from shapeowner!
	var collider = shape_owner_get_owner(local_shape)
	
	# get block from dict
	var block = null
	if collision_shapes.has(collider):
		
		block = collision_shapes[collider]
#		print("HIT SHAPE/BLOCK: ", block)
		
		# notify block
		block.ship_body_entered(body, null)
	else:
		print("shape not found in dict")
	
	# call ship collision
	if body.is_in_group("ShipBody"): body.ship_ship_collision(self, block)
		
	pass


# called by colliding ship when collision detected
# a little coupley
func ship_ship_collision(other_ship, block):
	pass


# by grid
func on_grid_empty(grid):
	if !editor_mode: destroy_self()


# SAVING AND LOADING ===========================================================


func save(id, dir = save_directory):
	
	# set self name (for reference and loading)
	name = id
	ship_id = id
	print("ship saving: " + id)
	
	var file = ship_save.save(self, id, dir)
	emit_signal("shipBody_saved", self, id, file)


# specify data to be serialized here, same as for blocks
func get_save_data() -> Dictionary :
	
	var data = {}
	
	data["name"] = self.name
	data["id"] = ship_id
	data["displacement"] = grid.get_position() # relative to ship
	data["mass"] = mass
	data["io_connections"] = io_manager.connections
	data["subShip_counter"] = subShip_counter
	data["subShip_id"] = subShip_id
	data["is_subShip"] = is_subShip
	
	# all shipsystems under the shipsystem manager saved here
	# as a dict of dicts
	data["ship_systems"] = ship_systems.save_systems_data()
	
	return data


# specify what to do with returned data
# called by loader after blocks are loaded
func load_saved_data(data : Dictionary):
	
	# store data for later use (connections pass)
	loaded_data = data
	
	# make sure this is loaded first so that other systems can reference it
	name = data["name"]
	name = str(name) # PLEASE
	
	ship_id = data["id"]
	subShip_id = data["subShip_id"]
	
	mass = data["mass"]
	
	# get deprecated mf
	# restore iomanager connections
#	io_manager.connections = data["io_connections"]
#	print("IO MANAGER CONNECTIONS RESTORED")
#	print(io_manager.connections)

	
	# restore subship counter to properly track new subships
	subShip_counter = data["subShip_counter"]
	
	# restore this to know if this ship is root/base case
	is_subShip = data["is_subShip"]
	print("THIS SHIP IS SUBSHIP: ", is_subShip)
	
	# restore collider positions from displacement
	for collider in collision_shapes:
		collider.position += data["displacement"]
	
	# if this ship is the root, do systems connection pass
	if !is_subShip: load_systems_after_blocks()


# called only by main ship after all blocks and subship blocks have been 
# recursively loaded in (for ie. io connections across ships)
func load_systems_after_blocks():
	
	print("SHIP LOADING SYSTEMS")
	
	# restore data for shipsystems
	ship_systems.load_systems_data(loaded_data["ship_systems"])
	
	for ship in subShips.values(): ship.load_systems_after_blocks() 

