class_name Block_Storage
extends StorageBase

export var grid_path = ""
export var center_grid_coord : Vector2
export var shipBody_path = ""

func get_data(parent):
	grid_path = get_path_to(parent.grid)
	center_grid_coord = parent.center_grid_coord
	shipBody_path = get_path_to(parent.shipBody)

func set_data(parent):
	parent.grid = get_node(grid_path)
	parent.center_grid_coord = center_grid_coord
	parent.shipBody = get_node(shipBody_path)
