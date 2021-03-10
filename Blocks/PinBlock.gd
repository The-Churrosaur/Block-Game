class_name PinBlock
extends Block

# spawns subship and pins when added to grid
# saves location of ship resource
# maybe TODO have the loader initiate loading subships idk

export var default_subShip_resource : Resource
export var default_pinHead_coord = Vector2(0,0)

onready var ship_loader = get_node("/root/ShipLoader")

var pinHead_coord = null
var subShip_resource = null
var subShip_name = null
var subShip_resource_path = null

var subShip = null
var pinHead = null
var pinJoint = null

var queue_pin = false

# communicates up to shipbody
signal subShip_pinned(subShip, pinBlock, pinHead)
signal subShip_removed(subShip, pinBlock, pinHead)

func _ready():
	._ready()
	
	pinJoint = $PinJoint2D
	
	print("pinjoint loading!")

func _input(event):
	
	# test input
	if event.is_action_pressed("ui_home"):
		setup_load_subship()

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	connect("subShip_pinned", shipBody, "on_new_subShip")
	connect("subShip_removed", shipBody, "on_subShip_removed")

func on_removed_from_grid(center_coord, block, grid):
	.on_removed_from_grid(center_coord, block, grid)
	
	# TODO are you sure you want to delete this subship?
	# can return false here
	
	emit_signal("subShip_removed", subShip, self, pinHead)

func setup_load_subship():
	
	# load saved subship from path or default subship
	if pinHead_coord == null: 
		pinHead_coord = default_pinHead_coord
	if subShip_resource_path == null: 
		print("default resource path")
		subShip_resource = default_subShip_resource
	else:
		subShip_resource = ResourceLoader.load(subShip_resource_path)
		print("PINBLOCK: loaded subship resource: ", subShip_resource_path, subShip_resource)
	
	var pinHead = create_subship_pinhead()
	attach(pinHead)
	
	# listen for subship grid changes
	pinHead.connect("pin_grid_changed", self, "on_pin_grid_changed")

func create_subship_pinhead() -> Node2D: # returns pinhead
	
	# ship
	# TODO place in tree through level singleton
	var ship = ship_loader.load_ship(subShip_resource, get_tree().root)
	
	# setup
	subShip_name = ship.name
	ship.connect("shipBody_saved", self, "on_subShip_saved")
	
	# pinhead
	var pinHead = ship.get_block(pinHead_coord)
	return pinHead

func attach(pinHead): 
	print("attaching pinhead")
	# should be placed on grid before attaching
	
	if !pinHead is PinHead:
		print("invalid pinHead")
		return false
	
	# setup subship
	var ship = pinHead.shipBody
	if !ship.has_method("is_shipBody"): # quack quack
		print("pinHead has invalid shipBody")
		return false
	subShip = ship
	
	# move subship to current position
	# move subship to align pinhead with current position
	reposition_subShip(pinHead)
	
	# TODO
#	print("?!?!", global_position, subShip.global_position, subShip.grid.global_position)
#	for block in subShip.grid.block_dict.values():
#		print(block.center_grid_coord, block.position, block.global_position)
#	print(subShip.grid.get_parent())
	
	# setup pinhead field
	self.pinHead = pinHead
	pinHead_coord = pinHead.center_grid_coord
	
#	print("***AJDSFKASpre-pin position: ", pinJoint.global_position, global_position)
	queue_pin = true
#	subShip.angular_velocity = 1
	
	emit_signal("subShip_pinned", subShip, self, pinHead)
	return true

func pin_subShip():
	
	if (pinJoint is PinJoint2D):
		pinJoint.free()
	
	pinJoint = PinJoint2D.new()
	add_child(pinJoint)
	pinJoint.name = "PinJoint2D" # fine godot have it your way
	pinJoint.disable_collision = true
	
	pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
	print("anchor position: ", grid.anchor.global_position)
#	print("pin position: ", pinJoint.global_position)
	pinJoint.node_b = subShip.get_path() # pin to subship
	
	queue_pin = false
	
	subShip.angular_velocity = 1.0 # for shits
	
	print("subship physics pinned")

# pinhead reattaching ----------------------------------------------------------

func on_pin_grid_changed(pinHead):
	reattach(pinHead)
	pass

# reattaches to pinHead position (for shifting subship)
func reattach(pinHead):
	
	print("reattaching...")
	
	queue_pin = true

func reposition_subShip(pinHead): 
	# first centers subship on self
	subShip.global_position = get_parent().to_global(position)
	
	# moves subship to place pinhead on old center
	shift_subship_pos_to_pinhead(pinHead)

# moves subship to place pinhead on old center
func shift_subship_pos_to_pinhead(pinHead):
	# shifts subship along inverse of pinhead relative position vector 
	var from_subship = subShip.grid.position + pinHead.position 
	print("subship repos: ", from_subship)
	subShip.position -= from_subship

func _physics_process(delta):
	if (queue_pin):
#		print("POSITION", global_position, subShip.position)
		pin_subShip()

# SAVING AND LOADING ===========================================================

func on_subShip_saved(ship, name, file):
	subShip_resource_path = file

func get_save_data() -> Dictionary:
	var dict = .get_save_data()
	
	dict["subShip_name"] = subShip_name
	dict["pinHead_coord"] = pinHead_coord
	dict["subShip_resource_path"] = subShip_resource_path
	
	return dict


