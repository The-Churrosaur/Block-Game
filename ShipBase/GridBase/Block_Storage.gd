class_name Block_Storage
extends StorageBase

export var grid_path = ""
export var center_grid_coord : Vector2
export var shipBody_path = ""
export var saved_name = ""

# currently half redundant
func get_data(parent):
	center_grid_coord = parent.center_grid_coord
	saved_name = parent.name


func set_data(parent):
	parent.center_grid_coord = center_grid_coord
	parent.saved_name = saved_name

