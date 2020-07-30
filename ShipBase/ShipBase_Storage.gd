class_name ShipBase_Storage
extends StorageBase

export var grid_address = ""
export var subShip_paths = "" # nodepaths to subships

func get_data(parent):
	
	# subships
	for ship in parent.subShips:
		subShip_paths.append(get_path_to(ship))
	
	pass

func set_data(parent):
	
	# subships
	for path in subShip_paths:
		parent.subShips.append(get_node(path))
	
	pass
