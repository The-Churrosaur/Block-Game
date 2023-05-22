
# sticky
# instead of instancing a subship on spawn, waits until given a ship

# TODO block offset to pick up from point instead of block center 

class_name MagLock
extends PinBlockBase


# FIELDS ----------------------------------------------------------------------


export var lock_enabled  = true


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
	
	attach(pinHead, false)


# drop it (temp)
func drop_subShip():
	pinJoint.queue_free()
	_disable_lock()


# override collision
func ship_body_entered(body, pos):
	.ship_body_entered(body, pos)
	
	if body.is_in_group("ShipBody"):
		_try_lock_subShip(body, pos)


# PRIVATE ----------------------------------------------------------------------


func _disable_lock():
	lock_enabled = false


func _enable_lock():
	lock_enabled = true


func _try_lock_subShip(ship, pos):
	
	if !lock_enabled: return
	
	var colliding_block = ship.get_closest_block(global_position)
	set_subShip(ship, colliding_block)


# -- SUBSECTION




func _on_Button_pressed():
	drop_subShip()
