class_name PinBlock
extends Block


const subShip_template = preload("res://ShipBase/ShipBody.tscn")
const pinhead_template = preload("res://Blocks/GunBlock.tscn") 

var shipBody = null
var subShip = null
var pinJoint = null


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
	
	pinJoint = PinJoint2D.new()
	add_child(pinJoint)
	
	if shipBody is ShipBody:
		
		subShip = subShip_template.instance()
		subShip.position = global_position
		shipBody.add_child(subShip)
		
		pinJoint.node_a = shipBody.get_path()
		pinJoint.node_b = subShip.get_path()
		
		var subgrid = subShip.grid
		if subgrid is GridBase:
			var block = pinhead_template.instance()
			subgrid.add_block_at_point(block, global_position)
		else:
			print("pinblock: subgrid not found")
			return false
		
		subShip.add_torque(1000000) # for shits


		
	else:
		print("pinblock: base shipbody not found")
		return false
	
	pass
