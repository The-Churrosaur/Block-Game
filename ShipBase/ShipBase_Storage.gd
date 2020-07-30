class_name ShipBase_Storage
extends StorageBase

export var grid_address = ""

func get_data(parent):
	#grid_address = get_path_to(parent.grid)
	pass

func set_data(parent):
	#parent.grid = get_node(grid_address)
	pass
