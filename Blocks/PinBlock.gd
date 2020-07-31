class_name PinBlock
extends Block

export var default_subShip = "pinblock_default"
export var default_pinHead = "PinHeadBase" 
# relative path from subship node

export var ships_folder = "res://Ships"
export var subShips_filepath = "/SubShips" # filepath from ship directory

var subShip = null
var pinHead = null
onready var pinJoint = $PinJoint2D

# by default from exports - overwritten in load_in()
onready var subShip_name = default_subShip
onready var subShip_address = ships_folder + "/" + default_subShip
onready var pinHead_name = default_pinHead

var queue_pin = false

# communicates up to shipbody
signal subShip_pinned(subShip, pinBlock, pinHead)
signal subShip_removed(subShip, pinBlock, pinHead)

func _ready():
	._ready()
	
	print("loading!")

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	connect("subShip_pinned", shipBody, "on_new_subShip")
	connect("subShip_removed", shipBody, "on_subShip_removed")
	
	var pinHead = create_subship_pinhead()
	attach(pinHead)
	
	# listen for subship grid changes
	pinHead.connect("pin_grid_changed", self, "on_pin_grid_changed")

func on_removed_from_grid(center_coord, block, grid):
	.on_removed_from_grid(center_coord, block, grid)
	
	# TODO are you sure you want to delete this subship?
	# can return false here
	
	emit_signal("subShip_removed", subShip, self, pinHead)

func create_subship_pinhead() -> Node2D: # returns pinhead
	# ship
	var template = load(subShip_address + "/" + subShip_name + ".tscn")
	var ship = template.instance()
	ship.load_in(subShip_address)
	
	# pinhead
	var pinHead = ship.grid.get_node(pinHead_name)
	return pinHead

func attach(pinHead): 
	print("attaching pinhead")
	# should be placed on grid before attaching
	
	if !pinHead is PinHead:
		print("invalid pinHead")
		return false
	
	# setup subship
	var ship = pinHead.shipBody
	if !ship.has_method("is_shipBody"):
		print("pinHead has invalid shipBody")
		return false
	subShip = ship
	add_child(subShip) # note this makes subgrid child of block
	print(shipBody.get_path_to(subShip))
	subShip.global_position = global_position # blocks' position
	
	# setup pinhead (after ship placed in nodetree) 
	self.pinHead = pinHead
	pinHead_name = pinHead.name
	
	# TODO relative position for loaded subships
	
	#subShip.angular_velocity = 1.0 # for shits
	queue_pin = true
	
	emit_signal("subShip_pinned", subShip, self, pinHead)
	return true

# pinhead reattaching ----------------------------------------------------------

func on_pin_grid_changed(pinHead):
	reattach(pinHead)

# reattaches to pinHead position (for shifting subship)
func reattach(pinHead):
	
	# detach from subship
	pinJoint.node_b = grid.anchor.get_path()
	reposition_subShip(pinHead)
	
	queue_pin = true

func reposition_subShip(pinHead):
	# shifts subship along inverse of pinhead relative position vector 
#	var from_subship = subShip.grid.position + pinHead.position 
#	subShip.position -= from_subship
	
	var dif = pinHead.global_position - subShip.global_position
	subShip.position -= dif

func _process(delta):
	if (queue_pin):
		pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
		pinJoint.node_b = subShip.get_path()
		queue_pin = false

# SAVING AND LOADING ===========================================================

func on_save_blocks(folder, ship_folder):
	# parent func called below
	
	# subship name
	# set before calling parent func, saving name to file
	subShip_name = "subShip_" + self.name
	
	# save subship
	subShip.save(subShip_name, ship_folder + subShips_filepath)
	
	# save self, storage
	.on_save_blocks(folder, ship_folder)

func load_in(folder, grid, ship_folder, old_name):
	.load_in(folder, grid, ship_folder, old_name)
	# storage loaded:
	# - subShip_name
	
	# instance and load subship
	subShip_address = ship_folder + subShips_filepath + "/" + subShip_name 


