extends IOBlock

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		io_box.set_output(0,1)
	elif event.is_action_released("ui_accept"):
		io_box.set_output(0,0)

func _physics_process(delta):
	
	# strafe
	var lr_vel = 0
	if Input.is_action_pressed("ui_right"):
		lr_vel += 1
	if Input.is_action_pressed("ui_left"):
		lr_vel -= 1
	io_box.set_output(1,lr_vel)
