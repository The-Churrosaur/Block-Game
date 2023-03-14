class_name TestBlock
extends Block

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selfblock


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	# for testing purposes
#	if event.is_action_pressed("ui_accept"):
#		print(selfblock)
	
	pass

func post_load_setup():
	.post_load_setup()
	# test load times
	# result is negligible
#	selfblock = grid.get_block(center_grid_coord)
#	print(selfblock)
	pass
