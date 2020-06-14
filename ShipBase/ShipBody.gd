# editor/physics wrapper for a block grid

class_name ShipBody
extends RigidBody2D

onready var grid = $GridBase

var block_collision_dict = {}
# CollisionShape2D -> Block
# tells blocks when they've gone cronch

# also holds references in reverse (Block -> Collisionshape)
# for deletion once the block has gone cronch
# TODO this feels inelegant af.

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
	
	# add block collisionShapes to the ship, log them in the dict
	
	for block_collider in block.hitbox_collision_shapes:
		var collider = CollisionShape2D.new()
		add_child(collider)
		collider.shape = block_collider.shape
		# preserves collider position relative to block
		collider.position = block.position + block_collider.position
		print(collider.position)
		block_collision_dict[collider] = block
		block_collision_dict[block] = collider
	
	mass += block.mass
	
	pass

func on_grid_block_removed(coord, block, grid):
	
	# remove block and collisionshape from dict, delete collisionshape
	
	var collider = block_collision_dict[block]
	block_collision_dict.erase(block)
	block_collision_dict.erase(collider)
	collider.queue_free() # mark for deletion
	
	mass -= block.mass
	
	pass

func on_force_requested(pos, magnitude, central):
	print("force requested")
	if central:
		add_central_force(magnitude)
	else:
		add_force(pos - position, magnitude)
	pass
