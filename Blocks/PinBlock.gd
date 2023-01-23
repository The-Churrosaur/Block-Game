extends PinBlockBase

func _ready():
	pass



func _physics_process(delta):
	if subShip:
		# direction * power
#		subShip.apply_torque_impulse(io_box.get_input(1) * io_box.get_input(0) * 10000 +1)
#
#		# braking force
		var relative_velocity = subShip.angular_velocity - shipBody.angular_velocity
		subShip.apply_torque_impulse(relative_velocity * -4)
		
#		print(subShip.applied_torque)

		
#		print(self, io_box)
#		print(self, io_box.inputs)

		pass

	# debug - test connection on self
	
#	print(io_box.get_input(0))
#	print(io_box.get_output(0))
	
#	if Input.is_action_pressed("ui_left"):
#		io_box.set_output(0,-1)
#	elif Input.is_action_pressed("ui_right"):
#		io_box.set_output(0,1)
#	else:
#		io_box.set_output(0,0)
#
#	if Input.is_action_just_pressed("ui_accept"):
#		if io_box.get_input(0) == 5:
#			io_box.set_output(1, 1)
#		else:
#			io_box.set_output(1,5)
#
#	if Input.is_action_just_pressed("ui_end"):
#		$IOHud.toggle_display()
	
#	print("test", io_box.get_output(0))
	pass

func _input(event):
#	if event.is_action_pressed("ui_alt_select"):
#		print("pinblock connecting")
#		test_connect()
		
	pass
