extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TestGrid.add_block(Vector2(-1,0),$TestGrid/BlockBase)
	$TestGrid.add_block(Vector2(1,0),$TestGrid/BlockBase2)
	$TestGrid.add_block(Vector2(0,0),$TestGrid/BlockBase3)
	$TestGrid.position_blocks()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
