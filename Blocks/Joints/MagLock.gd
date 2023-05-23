
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
	
	# manually set up pinblock fields
	pinHead_coord = block.center_grid_coord
	pinHead = block
	subShip = ship
	
	# connect signals
	pinHead.grid.connect("block_added", self, "on_grid_changed")
	pinHead.grid.connect("block_removed", self, "on_grid_changed")
	
	attach(pinHead, false)


# drop it (temp)
func drop_subShip():
	print("MAGBLOCK DROPPING SHIP")
	detach()
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


func _try_lock_subShip(ship, pos = Vector2.ZERO):
	
	if !lock_enabled: return
	
	var colliding_block = ship.get_closest_block(global_position)
	set_subShip(ship, colliding_block)


# -- SETUP HELPERS

# manually tells pinblock parent when subship is updated
# (in lieu of pinhead block)
func _on_grid_changed(coord, block, grid, update_com):
	on_pin_grid_changed(pinHead, block)

# -- SUBSECTION




func _on_Button_pressed():
	drop_subShip()


func _on_Area2D_body_entered(body):
	
	if !shipBody: return # block/ship is not loaded yet
	
	if (body != shipBody) and body.is_in_group("ShipBody"):
		
		print("MAGLOCK AREA BODY ENTERED: ", body, " MY SHIPBODY IS: ", shipBody)
		_try_lock_subShip(body)
