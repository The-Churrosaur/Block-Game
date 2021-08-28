class_name PinHeadBase
extends Block

# notifies pinblock
signal pin_grid_changed(pinHead)

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	# listen for grid changes/ship movement
	grid.connect("block_added", self, "on_grid_changed")
	grid.connect("block_removed", self, "on_grid_changed")

func on_grid_changed(coord, block, grid, update_com):
	emit_signal("pin_grid_changed", self)
