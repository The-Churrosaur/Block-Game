
# holds cables for tracking and serialization reasons
# reconstructs cables and injects references
class_name IOCableManager
extends ShipSystem


# FIELDS -----------------------------------------------------------------------


# resource for instantiation
export var cable_scene : PackedScene

# asks blocksystems for port manager
export var port_system_id = "port_manager"


# holds the cable objects
# cable -> bool
onready var cables = {}


# CALLBACKS --------------------------------------------------------------------


# TODO think about how to trigger this more regularly
func _physics_process(delta):
	_transmit_cable_data()


# PUBLIC -----------------------------------------------------------------------


# -- SAVING LOADING


# called by manager -> ship
# ["cables"] -> array of cables, each element is : {sender_port, receiver_port} 
# each port is {"ship" -> name, "block" -> coord, "port" -> id}
func save_data() -> Dictionary:
	.save_data()
	
	var save_cables = []
	
	for cable in cables.keys():
		var cable_dict = {}
		cable_dict["sender_port"] = _get_address(cable.sender_port)
		cable_dict["receiver_port"] = _get_address(cable.receiver_port)
		save_cables.append(cable_dict)
	
	var dict = {}
	dict["cables"] = save_cables
	return dict


# load cables from dictionary
# called by manager -> ship
func load_data(dict):
	.load_data(dict)
	
	for cable in dict["cables"]:
		print("CABLE MANAGER LOADING CABLE: ", cable)
		_new_from_address(cable)


# -- ADD REMOVE CABLES


# insantiate new cable and add to dict
func new_cable(sender_port, receiver_port):
	
	if (sender_port == null) or (receiver_port == null):
		print("CABLEMANAGER, INVALID CABLE")
		return 
	
	var cable = cable_scene.instance()
	
	# TODO should this be somewhere better in the nodetree? 
	add_child(cable)
	
	cable.sender_port = sender_port
	cable.receiver_port = receiver_port
	
	sender_port.cable = cable
	receiver_port.cable = cable
	
	# listen for deletion
	cable.connect("_cable_cut", self, "_on_cable_cut")
	
	# check for overlap before adding self to dict
	var nudge = Vector2.ZERO
	for cable_other in cables.keys():
		nudge += _cable_elbow_nudge(cable, cable_other)
	cable.nudge = nudge
	
	cables[cable] = true
	
	print("CABLEMANAGER NEW CABLE")


func remove_cable(cable):
	
	cables.erase(cable)
	
	cable.sender_port.cable = null
	cable.receiver_port.cable = null
	
	cable.queue_free()


# PRIVATE ----------------------------------------------------------------------


# signal listener, listens to cables
func _on_cable_cut(cable):
	print("manager heard cable cut request")
	remove_cable(cable)


# -- SAVING LOADING


# calls new_cable after finding ports from addresses
# takes cable dict
func _new_from_address(dict):
	
#	print("CABLEMANAGER PORT ADDRESSES: ", dict["sender_port"])
	
	var sender_port = _get_port(dict["sender_port"])
	var receiver_port = _get_port(dict["receiver_port"])
	
#	print("CABLEMANAGER PORTS FROM ADDRESS: ", sender_port, ", ", receiver_port)
	
	new_cable(sender_port, receiver_port)


# from port address dict
func _get_port(dict):
	
#	print ("CBM SHIPBODY: ", shipBody)
#	print ("CBM PORT SHIP ID: ", dict["ship"])
	var ship = shipBody.get_ship_in_tree(dict["ship"])
#	print("PORT SHIP FOUND: ", ship)
	if ship == null: return null
	
#	print ("CBM BLOCK: ", dict["block"])
#	print (ship.grid.block_dict)
	var block = ship.get_block(dict["block"])
#	print("CBM BLOCK: ", block)
	if block == null: return null
	
	var port_manager = block.block_systems_manager.get_system(port_system_id)
	return port_manager.get_port(dict["port"])


# get address from port
# {"ship" -> ship_id, "block" -> coord, "port" -> id}
func _get_address(port : IOPort) -> Dictionary:
	
	var manager = port.manager
	var block = manager.block
	var ship = block.shipBody 
	
	var dict = {}
	
	dict["ship"] = ship.ship_id
	dict["block"] = block.center_grid_coord
	dict["port"] = port.port_id
	
	return dict


# -- DRAWING OVERLAPPING


# checks and returns any physically overlapping cables
# compares all cables' ports X and Y 

func _get_overlapping_cables(cable1 : IOCable) -> Array:
	
	var overlap = []
	var offset_width = cable1.offset_width
	
	for cable2 in cables.keys():
		if (
			_compare_port_overlap(cable1.sender_port, cable2.sender_port, offset_width)
		 or _compare_port_overlap(cable1.sender_port, cable2.receiver_port, offset_width)
		 or _compare_port_overlap(cable1.receiver_port, cable2.sender_port, offset_width)
		 or _compare_port_overlap(cable1.receiver_port, cable2.receiver_port, offset_width)
		): overlap.append(cable2)
	
	return overlap


# compares overlap between two ports
func _compare_port_overlap(port1: IOPort, port2: IOPort, offset_width) -> bool:
	
	var x1 = port1.global_position.x
	var y1 = port1.global_position.y
	var x2 = port2.global_position.x
	var y2 = port2.global_position.y
	
	if abs(x1 - x2) <= offset_width: return true
	if abs(y1 - y2) <= offset_width: return true
	
	return false


func _cable_elbow_nudge(var cable0, var cable1) -> Vector2:
	
	var nudge = Vector2.ZERO
	
	var tolerance = cable0.offset_width
	
	var elbow0 = Vector2(cable0.sender_port.global_position.x, cable0.receiver_port.global_position.y)
	var elbow1 = Vector2(cable1.sender_port.global_position.x, cable1.receiver_port.global_position.y)
	
	var x = abs(elbow0.x - elbow1.x) < tolerance
	var y = abs(elbow0.y - elbow1.y) < tolerance
	
	if x : nudge += Vector2(1,0)
	if y : nudge += Vector2(0,1)
	
	return nudge

# -- CABLE DATA TRANSMISSION


# transmits data on all cables
func _transmit_cable_data():
	for cable in cables.keys():
		cable.send_data()
