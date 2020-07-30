class_name PinBlock
extends Block

export var default_subShip = "pinblock_default"
export var ships_folder = "res://Ships"
# path from ship directory
export var subShips_filepath = "/SubShips"
var subShip_name
var subShip_address

var subShip = null
onready var pinJoint = $PinJoint2D

var queue_pin = false

func _ready():
	._ready()
	
	print("loading!")

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	create_pin_subShip()

func create_pin_subShip(default = true, ship = null):
	
	if shipBody is ShipBody:
		
		# if no arg, set up default subship
		if (default):
			var address = ships_folder + "/" + default_subShip
			var template = load(address + "/" + default_subShip + ".tscn")
			ship = template.instance()
			ship.load_in(address)
		
		subShip = ship
		add_child(subShip) # note this makes subgrid child of block
		subShip.global_position = global_position # blocks' position
		
		# TODO relative position for loaded subships
		
		subShip.angular_velocity = 1.0 # for shits
		queue_pin = true
		
	else:
		print("pinblock: base shipbody not found")
		return false

func _process(delta):
	if (queue_pin):
		pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
		pinJoint.node_b = subShip.get_path()
		queue_pin = false

# SAVING AND LOADING =============================================================

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
	
	# instance and load subship
	subShip_address = ship_folder + subShips_filepath + "/" + subShip_name 
	var template = load(subShip_address + "/" + subShip_name + ".tscn")
	var ship = template.instance()
	ship.load_in(subShip_address) # load vars
	create_pin_subShip(false, ship)
