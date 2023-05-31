class_name PinBlockBase
extends PortBlockBase

# spawns subship and pins when added to grid
# saves location of ship resource
# maybe TODO have the loader initiate loading subships idk

# if false, doesn't spawn a subship
export var use_subShip_resource = true

export var default_subShip_resource : Resource
export var default_pinHead_coord = Vector2(0,0)

onready var ship_loader = get_node("/root/ShipLoader")

var pinHead_coord = null
var subShip_resource = null
var subShip_id = null
var subShip_resource_path = null

var subShip = null
var pinHead = null
var pinJoint = null

var queue_pin = false
var queue_repos = false

# communicates up to shipbody
signal subShip_pinned(subShip, pinBlock, pinHead)
signal subShip_removed(subShip, pinBlock, pinHead)


func _ready():
	._ready()
	
	pinJoint = $PinJoint2D
	
	print("pinjoint loading!")


func _physics_process(delta):
	
	if pinHead != null:
		
#		print("MAGLOCK HAS PINHEAD: ", pinHead, pinHead.name)
		
		if queue_repos: reposition_subShip(pinHead)
		if queue_pin: pin_subShip()


func _input(event):
	
	# test input
	if event.is_action_pressed("ui_home"):
		setup_load_subship()
	
	pass

func post_load_setup():
	.post_load_setup()
	# wow I hate this so much but it works for now TODO TODO
#	yield(get_tree().create_timer(0.0001), "timeout")
#	setup_load_subship()

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	connect("subShip_pinned", shipBody, "on_new_subShip")
	connect("subShip_removed", shipBody, "on_subShip_removed")
	shipBody.connect("ship_com_shifted", self, "on_ship_com_shifted")
	
	
	print("PINBLOCK ADDED TO GRID: USE SUBSHIP? ", use_subShip_resource)
	if use_subShip_resource: setup_load_subship()

func on_removed_from_grid(center_coord, block, grid):
	.on_removed_from_grid(center_coord, block, grid)
	
	# TODO are you sure you want to delete this subship?
	# can return false here
	
	if subShip: emit_signal("subShip_removed", subShip, self, pinHead)

func setup_load_subship():
	
	# load subship resource from path or default subship
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


# spawns and sets up subship
func create_subship_pinhead() -> Node2D: # returns pinhead
	
	# ship
	# TODO place in tree through level singleton
	# PLACING UNDER ROOT CAUSES THE PERSISTENCE
	var ship = ship_loader.load_ship(subShip_resource, get_tree().current_scene, false)
	
	# setup
	subShip_id = ship.ship_id
	ship.superShip = shipBody
	ship.connect("shipBody_saved", self, "on_subShip_saved")
	
	# pinhead
	var pinHead = ship.get_block(pinHead_coord)
	return pinHead


# attaches new subship
func attach(pinHead, repos = true): 
	
	print("attaching pinhead")
	# should be placed on grid before attaching
	
	# setup subship
	var ship = pinHead.shipBody
	if !ship.has_method("is_shipBody"): # quack quack
		print("pinHead has invalid shipBody")
		return false
	subShip = ship
	
	# move subship to current position
	# move subship to align pinhead with current position
#	reposition_subShip(pinHead)
	# THIS IS DONE IN PHYSICS PROCESS NOW (queue pin)
	
#	yield(get_tree().create_timer(0.0001), "timeout")
	
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
	if repos: queue_repos = true
#	pin_subShip()
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
	
	# well well well...
#	pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
#	print("anchor position: ", grid.anchor.global_position)
	
	pinJoint.node_a = shipBody.get_path()
	
#	print("pin position: ", pinJoint.global_position)
	pinJoint.node_b = subShip.get_path() # pin to subship
	
	queue_pin = false
	
	subShip.angular_velocity = 1.0 # for shits
	
	print("subship physics pinned")


# cleanly detach pinhead
func detach():
	
	if !subShip: 
		print("PINBLOCK no subship to detach")
		return
	
	print("PINBLOCK DETACHING")
	
	# physicially detatch
	pinJoint.queue_free()
	
	# clear subship references
	emit_signal("subShip_removed", subShip, self, pinHead)
	
	# clear from self
	subShip = null
	pinHead = null
	pinHead_coord = null


# pinhead reattaching ----------------------------------------------------------


func on_pin_grid_changed(pinHead, block):
	
	if block == pinHead: 
		print("PINBLOCK pinhead deleted! detaching")
		detach()
	
	reattach(pinHead)


func on_ship_com_shifted(old_pos, relative_displacement):
	reattach(pinHead)


# reattaches to pinHead position (for shifting subship)
func reattach(pinHead, repos = true):
	
	print("reattaching...")
	
	queue_pin = true
	if repos: queue_repos = true


func reposition_subShip(pinHead): 
	# first centers subship on self
	subShip.global_position = global_position
	
	# moves subship to place pinhead on old center
	shift_subship_pos_to_pinhead(pinHead)


# moves subship to place pinhead where com was
func shift_subship_pos_to_pinhead(pinHead):
	
	# get displacement of pinhead
	var disp
	
	# gets subship(com) -> pinhead in global coords
	if pinHead.get("pin_point"):
		disp = pinHead.pin_point.global_position - subShip.global_position
	else:
		disp = pinHead.global_position - subShip.global_position
	
	# moves subship inverse of this displacement
	subShip.position -= disp
	
	print("subship moved: ", disp)


# SAVING AND LOADING ===========================================================

func on_subShip_saved(ship, id, file):
	subShip_resource_path = file

func get_save_data() -> Dictionary:
	var dict = .get_save_data()
	
	dict["subShip_id"] = subShip_id
	dict["pinHead_coord"] = pinHead_coord
	dict["subShip_resource_path"] = subShip_resource_path
	
	return dict


