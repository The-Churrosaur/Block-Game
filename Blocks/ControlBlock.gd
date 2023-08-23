extends IOBlock

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		io_box.set_output(0,1)
	if event.is_action_released("ui_accept"):
		io_box.set_output(0,0)
	
	if event.is_action_pressed("ui_right"):
		io_box.set_output(1,1)
	if event.is_action_pressed("ui_left"):
		io_box.set_output(1,-1)
