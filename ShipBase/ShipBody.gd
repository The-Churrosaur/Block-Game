# editor/physics wrapper for a block grid

class_name ShipBody
extends RigidBody2D

export var save_directory = "res://Ships"

onready var grid = $GridBase
# ShipBody changes position with COM because godot
# grid position moves with ShipBody BUT
# grid position remains relative to ShipBody at original scene origin

# use grid position for ship local coordinates/origin
var grid_origin setget ,grid_origin
func grid_origin():
	grid_origin = grid.global_position
	return grid_origin

#TODO since it's all bunk, encapsulating node slaved to grid?

var block_collision_dict = {}
# CollisionShape2D -> Block
# tells blocks when they've gone cronch

# also holds references in reverse (Block -> Collisionshape)
# for deletion once the block has gone cronch

# TODO this feels inelegant af.
# - is holding hitboxes on the ship necessary? 
# - single polygon that switches owners (collider has to be direct child)

signal on_clicked(shipBody)

func _ready():
	grid.connect("block_added", self, "on_grid_block_added")
	grid.connect("block_removed", self, "on_grid_block_removed")
	input_pickable = true
	pass

func _unhandled_input(event):

	# when clicked, emits signal that has been clicked
	
	if event.is_action("ui_mclick"):
		print("ship: input mclick ", name)
		emit_signal("on_clicked", self)
		#get_tree().set_input_as_handled()
		
	
	pass

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
	
	pass

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
		add_force(pos - position, magnitude)
	pass

func save(name):
	var address = save_directory + "/" + name + ".tscn"
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save(address, packed_scene)
	
	print(name + " saved")
	
	pass
