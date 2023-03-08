
# pinblock block functionality
# base extends portblock since, eh, (multiple inheritance pls)
extends PinBlockBase


# FIELDS ----------------------------------------------------------------------


export var torque_impulse = 1000
export var braking_impulse = 400

onready var throttle_port : IOPort = $BlockSystems/PortManager/IOPort


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _physics_process(delta):
	
	if subShip: # has head
		
		# apply force
		
		# throttle 0-1
		var throttle = throttle_port.data / throttle_port.max_data
		if throttle_port.data > 0: 
			subShip.apply_torque_impulse(torque_impulse * throttle)
		
		# braking force
#		var relative_velocity = subShip.angular_velocity - shipBody.angular_velocity
#		subShip.apply_torque_impulse(relative_velocity * -braking_impulse)
		
#		print(subShip.applied_torque)


func _input(event):
#	if event.is_action_pressed("ui_alt_select"):
#		print("pinblock connecting")
#		test_connect()
		
	pass
