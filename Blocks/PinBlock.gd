extends PinBlockBase

func _ready():
	# test connect to self
	# todo this is kind of lazy, think of best time to add connections
	call_deferred("test_connect")

func test_connect():
	if shipBody:
		shipBody.io_manager.add_connection(center_grid_coord, 0, center_grid_coord, 1)
		shipBody.io_manager.add_connection(center_grid_coord, 1, center_grid_coord, 0)

func _physics_process(delta):
	if subShip:
		# direction * power
		subShip.angular_velocity = io_box.get_input(1) * io_box.get_input(0)
	
	if Input.is_action_pressed("ui_left"):
		io_box.set_output(0,-1)
	elif Input.is_action_pressed("ui_right"):
		io_box.set_output(0,1)
	else:
		io_box.set_output(0,0)
	
	if Input.is_action_just_pressed("ui_accept"):
		if io_box.get_input(0) == 5:
			io_box.set_output(1, 1)
		else:
			io_box.set_output(1,5)
		
		$IOHud.toggle_display()
	
#	print("test", io_box.get_output(0))

