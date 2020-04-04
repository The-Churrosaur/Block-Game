class_name Block
extends Node2D

const size_grid = [Vector2(0,0)] # relative grid of block positions
# ie. a 1x2 spire would be [0,0 , 0,1]
var hitbox_collision_shapes = []

export var hitbox_names_string = "Hitbox"

# owned by grid, no touch vvv

var grid : Node2D
var grid_coord = [] # just in case self-reference to find itself through grid
var center_grid_coord : Vector2 # center coordinate of block


func _ready():
	set_hitbox_collision_shapes()
	pass # Replace with function body.

func set_hitbox_collision_shapes():
	for node in get_children():
		if node.name == hitbox_names_string:
			hitbox_collision_shapes.append(node)
			node.disabled = true
	pass
