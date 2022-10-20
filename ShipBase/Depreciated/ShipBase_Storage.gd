class_name ShipBase_Storage
extends StorageBase

export var grid_address = ""
export var subShip_paths = [] # nodepaths to subships

func get_data(parent):
	
	# subships
#	for i in parent.subShips.size():
#		if i > 0: # ship holds self as subship 0
#			subShip_paths.append(parent.get_path_to(parent.subShips[i]))
	
	pass

func set_data(parent):
	
	# subships
#	for path in subShip_paths:
#		parent.subShips.append(get_node(path))
	
	pass
