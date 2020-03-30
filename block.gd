class_name Block
extends Node2D

const size_grid = [Vector2(0,0)] # relative grid of block positions
# ie. a 1x2 spire would be [0,0 , 0,1]

# owned by grid, no touch vvv

var grid_coord = [] # just in case self-reference to find itself through grid
var center_grid_coord : Vector2 # center coordinate of block


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
