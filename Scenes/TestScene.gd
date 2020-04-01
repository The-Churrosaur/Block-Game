extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const test_block = preload("res://Blocks/GunBlock.tscn")
onready var test_grid = $TestGrid
onready var test_gun = $GunBase


# Called when the node enters the scene tree for the first time.
func _ready():
	test_grid.add_block($TestGrid/BlockBase,[Vector2(-1,0)])
	test_grid.add_block($TestGrid/BlockBase2,[Vector2(1,0)])
	test_grid.add_block($TestGrid/BlockBase3,[Vector2(0,0)])
	test_grid.position_all_blocks()
	
	pass # Replace with function body.


func _process(delta):
	test_grid.rotate(0.01)
	
	if (Input.is_action_just_pressed("ui_lclick")):
		
		var block = test_block.instance()
		test_grid.add_block_at_point(block, get_global_mouse_position())
		
	pass
