
# motor block 
class_name MotorBlock
extends PinBlockBase


# FIELDS ----------------------------------------------------------------------


export var torque_impulse = 10000
export var braking_impulse = 4000

onready var throttle_port : IOPort = $BlockSystems/PortManager/ThrottlePort
onready var reverse_port : IOPort = $BlockSystems/PortManager/ReversePort


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _physics_process(delta):
	
	if subShip: # has head
		
		# apply force
		
		# throttle 0-1
		var throttle = throttle_port.data / throttle_port.max_data
		var reverse = reverse_port.data / reverse_port.max_data
		
		throttle = throttle - reverse
		
		if throttle != 0: 
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
