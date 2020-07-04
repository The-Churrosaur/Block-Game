class_name ShipBase_Storage
extends StorageBase

export var grid_address = ""

func get_data(parent):
	grid_address = get_path_to(parent.grid)
	print(grid_address)

func set_data(parent):
	print(grid_address)
	parent.grid = get_node(grid_address)
	print(parent.grid)
