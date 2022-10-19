# GDSCRIPT replacement for nativescript loader/saver
# takes location and creates serialized folder
# build ship into skeleton

# manager for resource (old saver was encapsulated resource with own functions)

# TODO should this be a singleton or scene localized or what

class_name Ship_SaverLoader_GDS
extends Node2D

# returns file
func save(ship : Node2D, name : String, directory : String) -> String:
	
	# manage resource
	var save_resource = ShipSaveResource.new()
	var resource_types = save_resource.block_types
	var resource_blocks = save_resource.blocks
	
	# EXTRACT SHIP DATA
	
	# get grid dict
	var grid = ship.grid
	if grid == null: return "ERROR"
	var grid_dict = grid.block_dict
	
	# get com offset
	var grid_displacement = grid.get_position()
	
	print("shipsave saving! " + name + " in: " + directory)
	
	# NAVIGATE TO DIRECTORY
	
	# navigate directory
	var dir = Directory.new()
	dir.open(directory)

	# check if file already exists, append name
	if dir.dir_exists(name):
	
		print("Save already exists, renaming");
		name = name + "_1";
		# TODO properly append numbers use regex lol
	

	# make folder
	dir.make_dir(name);
	
	# make subship folder 
	dir.change_dir(name);
	dir.make_dir("SubShips"); # TODO case issues? 

	# create file
	var file = directory + name + "/" + name + ".tres";
	
	# UPDATE RESOURCE FROM SHIP

	# RECURSIVELY SAVE SUBSHIPS
	save_subShips(ship, directory + name + "/SubShips/")
	
	# save blocks
	# TODO appending to array may be slow - consider resizing in advance
	
	# get blocks (nodes)
	var blocks = grid_dict.values()
	# iterate through dict
	for block in blocks:
		# get save data from node
		var block_data = block.get_save_data()
		# store block
		resource_blocks.append(block.get_save_data()) # save data from node
		# store type
		resource_types[block_data["type"]] = true
	
	# SAVE RESOURCE TO DISK
	
	print("saving to disc: " + file)
	ResourceSaver.save(file, save_resource)
	
	return file;


# helper
func save_subShips(ship : Node2D, directory : String):
	
	# iterate through subships, save
	
	# get dict
	var subShip_dict = ship.subShips
	if subShip_dict.empty():
		print("Ship saver: no subships")
		return
	
	# get ships
	var subShips = subShip_dict.values();
	
	# iterate
	for subShip in subShips:
		
		# don't re-save self
		if subShip.name == ship.name : continue
		
		# call save with [ship.name, file]
		print("saving subship: " + subShip.name);
		subShip.save(subShip.name, directory)


func load_ship(ship_base : Node2D) -> Node2D:
	return Node2D.new()

