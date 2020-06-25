class_name PinBlock
extends Block


const subShip_template = preload("res://Ships/turretBase.tscn")

var shipBody = null
var subShip = null
onready var pinJoint = $PinJoint2D

var queue_pin = false

func _ready():
	pass

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	# quack quack
	var ship
	if grid is GridBase:
		ship = grid.shipBody
	if ship is ShipBody:
		shipBody = ship
	
	create_pin_subShip()

func create_pin_subShip():
	
	if shipBody is ShipBody:
		
		subShip = subShip_template.instance()
		add_child(subShip) # note this makes subgrid child of block
		shipBody.set_as_owner(subShip)
		subShip.supergrid = grid
		subShip.global_position = global_position
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
