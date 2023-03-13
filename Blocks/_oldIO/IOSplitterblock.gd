extends IOBlock

# replicates input 0 to all outputs

func _physics_process(delta):
	
		for i in range (io_box.inputs.size() - 1):
			io_box.set_output(i, io_box.get_input(0))

