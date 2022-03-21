extends IOBlock

# input 0 is switch, inverts inputs 2-5

func _physics_process(delta):
	
	if io_box.get_input(0):
		for i in range (1,io_box.inputs.size() - 1):
			io_box.set_output(i, io_box.get_input(i) * -1)
