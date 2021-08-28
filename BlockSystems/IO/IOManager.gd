# assumption: connections are always from one A to one B 
# splits etc. done by specific boxes, create new connections

class_name IOManager
extends Node

export var ship_path : NodePath
onready var ship = get_node(ship_path)

# dictionary of connections
# output -> input
# outputs and inputs are arrays of form [coordinate, port]
onready var connections = {}

# called by blocks to propagate output to any connections
func output(coord, port, value) -> bool:
	if connections.has([coord, port]):
		var in_coord = connections[[coord, port]][0]
		var in_port = connections[[coord, port]][1]
		# get iobox
		# set value
		var block = ship.get_block(in_coord)
		if block.io_box:
			block.io_box.set_input(in_port, value)
			return true
	return false

# add cut connections

func add_connection(output_coord, output_port, input_coord, input_port):
	connections[[output_coord, output_port]] = [input_coord, input_port]

func remove_connection(output_coord, output_port, input_coord, input_port):
	connections.erase([output_coord, output_port])
