
# sticky
# instead of instancing a subship on spawn, waits until given a ship

# TODO block offset to pick up from point instead of block center 

class_name MagLock
extends PinBlockBase


# FIELDS ----------------------------------------------------------------------




# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


# also connects
func set_subShip(ship : RigidBody2D, block : Block):
	
	# TODO offset
	pinHead_coord = block.center_grid_coord
	pinHead = block
	subShip = ship
	
	attach(pinHead)


# drop it (temp)
func drop_subShip():
	pinJoint.queue_free()


# override collision
func ship_body_entered(body, pos):
	.ship_body_entered(body, pos)
	
	if body.is_in_group("ShipBody"):
		var colliding_block = body.get_closest_block(global_position)
		set_subShip(body, colliding_block)


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION




func _on_Button_pressed():
	drop_subShip()
