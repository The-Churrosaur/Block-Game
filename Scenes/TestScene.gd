extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const test_block = preload("res://Blocks/GunBlock.tscn")
onready var test_grid = $ShipBase/GridBody/GridBase


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func _process(delta):
	
	if (Input.is_action_just_pressed("ui_lclick")):
		
		var block = test_block.instance()
		test_grid.add_block_at_point(block, get_global_mouse_position())
		
	pass
