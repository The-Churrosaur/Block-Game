
# specialized rotor, spawns a wheel
class_name WheelBlock
extends PinBlockBase



func _physics_process(delta):
	if subShip:
		# direction * power
		subShip.apply_torque_impulse(io_box.get_input(1) * io_box.get_input(0) * 10000)
#
#		# braking force
		var relative_velocity = subShip.angular_velocity - shipBody.angular_velocity
		subShip.apply_torque_impulse(relative_velocity * -4)

		pass
