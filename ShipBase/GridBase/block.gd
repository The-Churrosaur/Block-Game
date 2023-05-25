
# the humble block
class_name Block
extends Node2D



# FIELDS -----------------------------------------------------------------------



enum block_facing_direction {UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3}

# relative grid of block positions
export(Array, Vector2) var size_grid = [Vector2(0,0)] 
# ie. a 1x2 spire would be [0,0 , 0,-1] (y values increase going down vvv)
# I would like this to be a const but it needs to be inherited
# injected into by editor helper
# IMPORTANT: relative to 0 rotation/facing, will rotate this

export var mass = 10
export var cost = 100

export var description = "A block, for building!"


# -- COLLISION AND DAMAGE


# velocity at which impact kablooie
# probably naiive think about this more later
export var destruction_velocity = 5
export var destructable = false

# health
export var health = 100
# damage threshold, velocity/physics tick
export var acceleration_limit = 1
# damage/tick multiplied by acceleration over limit
export var acceleration_damage_mult = 1


# unique identifier
export var class_type = "Block"
export(String) var display_name
export var tile_id = 0

export var enabled = true

export var popup_path : NodePath = "BlockPopup"


var block_facing : int = block_facing_direction.RIGHT



# -- COLLISION


# array of collisionshapes, read by ship
var hitbox_collision_shapes = [] 

# for populating the array
export (Array, NodePath) var hitbox_colliders

# keeping this for forwards compatibility I guess
# (legacy: populates hitbox array by name)
export var hitbox_string_old = "Hitbox"

var saved_name


# -- BLOCK SYSTEMS


export var block_systems_manager_path : NodePath
onready var block_systems_manager = get_node_or_null(block_systems_manager_path)


# -- INJECTED PARAMETERS
# -- injected by grid, no touch vvv


var grid : Node2D = null
var grid_coord = [] # DEFUNCT just in case self-reference to find itself through grid
var center_grid_coord : Vector2 # center coordinate of block
var shipBody : RigidBody2D
var block_id : int = 0


# -- UI


onready var popup : Popup = get_node(popup_path)


# overloads default to return specific block type 
# for serialization etc.
func get_class():
	return class_type



# CALLBACKS --------------------------------------------------------------------



func _ready():
	_sanitize_name()
	_set_hitbox_collision_shapes()



# PUBLIC -----------------------------------------------------------------------



# -- BLOCK PLACEMENT


func set_facing(facing : int):
	
	facing %= 4
	block_facing = facing
	
#	print("block facing: ", facing)
	
	if facing == 1:
		rotation = 0
	elif facing == 2:
		rotation = PI/2
	elif facing == 3:
		rotation = PI
	else:
		rotation = 3 * PI / 2


func rotate_facing_right():
	set_facing((block_facing + 1) % block_facing_direction.size())


func rotate_facing_left():
	set_facing((block_facing - 1) % block_facing_direction.size())


# TODO give full coordinates for deletion (or should it recreate from local?)
func on_added_to_grid(center_coord, block, grid):
	# vars from grid
	self.center_grid_coord = center_coord
	self.grid = grid
	shipBody = grid.shipBody
#	print("block added: shipbody: ", shipBody, " grid: ", self.grid)
	# grid signals
	grid.connect("save_blocks", self, "on_save_blocks")


func on_removed_from_grid(center_coord, block, grid):
	print("block remove called: ", self, " ", class_type)
	pass

# to convert stored id's into block references etc.
func post_load_setup():
	pass



# -- INGAME / COLLISION / DAMAGE



func enable_block():
	enabled = true


func disable_block():
	enabled = false


func damage_block(damage):
	
	health -= damage
	if health <= 0: grid.remove_block(center_grid_coord)
	
	


func heal_block(damage):
	health += damage 


# called by the ship, checks and inflicts damage
func accelerate(acceleration : Vector2):
	
	var dif = acceleration.length() - acceleration_limit
	if dif > 0:	damage_block(acceleration_damage_mult * dif)


# called by ship when this block is impacted
# currently cannot get pos
func ship_body_entered(body : CollisionObject2D, pos):
	
	if !destructable: return
	
	# temp collision by relative velocity
	var relative_vel 
	
	if body is StaticBody2D: 
		relative_vel = shipBody.linear_velocity
	elif body is KinematicBody2D or body is RigidBody2D:	
		relative_vel = shipBody.linear_velocity - body.linear_velocity
	
	if abs(relative_vel.length()) > destruction_velocity : 
		print("block exploded at: ", center_grid_coord)
		grid.remove_block(center_grid_coord)
	
	pass


func ship_clicked(event : InputEvent):
	if event.is_action_pressed("ui_lclick"):
		_set_popup()


# -- BLOCK SYSTEMS


func get_system(system_id : String):
	if !block_systems_manager : return null
	return block_systems_manager.get_system(system_id)


# -- SAVING AND LOADING 


# called by gridSave, gets dict of data to serialize
func get_save_data() -> Dictionary :
	
	var dict = {}
	
	dict["type"] = class_type # special name key for resource
	dict["pos"] = center_grid_coord # special name key for resource
	dict["facing"] = block_facing  # special name key for resource
	dict["address"] = filename # for loading
	dict["block_id"] = block_id
	
	# get data from system manager 
	if block_systems_manager != null:
		dict["systems"] = block_systems_manager.get_save_data()
	
	return dict


# called by loader returns saved dict
# called after block is initialized
func load_saved_data(dict : Dictionary):
	
	# pass data back to systems manager
	if block_systems_manager != null:
		print(name)
		block_systems_manager.load_saved_data(dict["systems"])



# PRIVATE ----------------------------------------------------------------------



# removes the @node@ from node name
# don't ask...
func _sanitize_name():
	var chars = name
	name = chars


func _set_hitbox_collision_shapes():
	
	# append from export list
	for path in hitbox_colliders:
		var node = get_node(path)
		if node is CollisionShape2D:
			hitbox_collision_shapes.append(node)
	
	
	# for forward compatibility
	for node in get_children():
		if (node is CollisionShape2D) and (node.name == hitbox_string_old):
			# if not already in array
			if !hitbox_collision_shapes.has(node):
				hitbox_collision_shapes.append(node)
	
	print("block: hitboxes set: ", hitbox_collision_shapes)


func _set_popup():
	if popup != null:
		popup.show_popup(self)


func _check_acceleration_damage():
	pass
