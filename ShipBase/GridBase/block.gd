class_name Block
extends Node2D

# relative grid of block positions
const size_grid = [Vector2(0,0)] 
# ie. a 1x2 spire would be [0,0 , 0,1]

# array of collisionshapes, populated on load
var hitbox_collision_shapes = [] 
export var hitbox_names_string = "Hitbox"

export var mass = 100

# owned by grid, no touch vvv

var grid : Node2D = null
var grid_coord = [] # DEFUNCT just in case self-reference to find itself through grid
var center_grid_coord : Vector2 # center coordinate of block


func _ready():
	set_hitbox_collision_shapes()
	pass

func set_hitbox_collision_shapes():
	for node in get_children():
		if (node is CollisionShape2D) and (node.name == hitbox_names_string):
			hitbox_collision_shapes.append(node)
			node.disabled = true
	pass

# TODO give full coordinates for deletion (or should it recreate from local?)
func on_added_to_grid(center_coord, block, grid):
	self.grid = grid
	self.center_grid_coord = center_coord
	pass
