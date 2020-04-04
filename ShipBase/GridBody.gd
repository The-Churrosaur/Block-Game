# physics wrapper for a block grid
class_name GridBody
extends RigidBody2D

onready var grid = $GridBase

var block_collision_dict = {}
# CollisionShape2D -> Block
# tells blocks when they've gone cronch

func _ready():
	grid.connect("block_added",self, "on_grid_block_added")
	pass

func on_grid_block_added(coord, block):
	
	# add block collisionShapes to the ship, log them in the dict
	
	for block_collider in block.hitbox_collision_shapes:
		var collider = CollisionShape2D.new()
		add_child(collider)
		collider.shape = block_collider.shape
		# TODO preserve collider position relative to block
		collider.position = coord * grid.grid_size
		print(collider.position)
		block_collision_dict[collider] = block
	pass
