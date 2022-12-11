
# holds cables for tracking and serialization reasons
# reconstructs cables and injects references
class_name IOCableManager
extends ShipSystem

# FIELDS -----------------------------------------------------------------------


# resource for instantiation
export var cable_scene : PackedScene


# holds the cable objects
# cable -> bool
onready var cables = {}


# CALLBACKS --------------------------------------------------------------------


# TODO think about how to trigger this more regularly
func _physics_process(delta):
	_transmit_cable_data()


# PUBLIC -----------------------------------------------------------------------


# saving and loading


# save cables to dictionary
# ["cables"] -> array of cables with: sender_port, receiver_port 
func save_cables() -> Dictionary:
	
	var cables = []
	
	for cable in cables.keys():
		var cable_dict = {}
		cable_dict["sender_port"] = cable.sender_port
		cable_dict["receiver_port"] = cable.receiver_port
		cables.append(cable_dict)
	
	var dict = {}
	dict["cables"] = cables
	return dict


# load cables from dictionary
# called by ship
func load_cables(dict):
	
	for cable in dict["cables"]:
		_new_from_address(cable)


# add remove cables


# insantiate new cable and add to dict
func new_cable(sender_port, receiver_port):
	
	var cable = cable_scene.instance()
	cable.sender_port = sender_port
	cable.receiver_port = receiver_port
	
	cables[cable] = true
	
	print("CABLEMANAGER NEW CABLE")


func remove_cable(cable):
	cables.erase(cable)


# PRIVATE ----------------------------------------------------------------------


# calls new_cable after finding ports from addresses
# takes cable dict
func _new_from_address(dict):
	
	var sender_port = _get_port(dict["sender_port"])
	var receiver_port = _get_port(dict["receiver_port"])
	
	new_cable(sender_port, receiver_port)


# from port address dict
func _get_port(dict):
	
	var ship = shipbody.get_ship_in_tree(dict["ship"])
	if ship == null: return null
	
	var block = ship.get_block(dict["block"])
	if block == null: return null
	
	var port_manager = block.block_systems_manager.get_system("PortManager")
	return port_manager.get_port(dict["port"])


# transmits data on all cables
func _transmit_cable_data():
	for cable in cables.keys():
		cable.send_data()
