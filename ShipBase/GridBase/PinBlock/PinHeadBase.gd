class_name PinHeadBase
extends Block

# notifies pinblock
signal pin_grid_changed(pinHead, changed_block)

export var pin_point_path : NodePath = "PinPoint"

# pinblock will pin this ship at the position of the pinpoint node
onready var pin_point = get_node(pin_point_path)

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	# listen for grid changes/ship movement
	grid.connect("block_added", self, "on_grid_changed")
	grid.connect("block_removed", self, "on_grid_changed")

func on_grid_changed(coord, block, grid, update_com):
	emit_signal("pin_grid_changed", self, block)
