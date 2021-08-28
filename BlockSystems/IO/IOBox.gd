class_name IOBox
extends Node

# port-indexed arrays
# contain dictionaries with name, value, activated this tick etc.
# set in editor 
export var inputs = []
export var outputs = []

export var block_path : NodePath

onready var block = get_node_or_null(block_path)
onready var manager = null

func _ready():
	# tool
#	for i in inputs.size():
#		inputs[i] = {"name":"","value":0.0}
#
#	for i in outputs.size():
#		outputs[i] = {"name":"","value":0.0}
	
	pass

func _process(delta):
	pass

# get port from name
func get_output_port(port_name : String):
	for i in outputs.size():
		var output = outputs[i]
		if output["name"] == port_name: return i
	return null

func get_input_port(port_name : String):
	for i in inputs.size():
		var input = inputs[i]
		if input["name"] == port_name: return i
	return null

func set_output(port, value):
	if port is String: set_output(get_output_port(port), value)
	else: outputs[port]["value"] = value
#	print(manager)
	if manager: 
		manager.output(block.center_grid_coord, port, value)

func get_output(port):
	if port is String: get_output(get_output_port(port))
	else: return outputs[port]["value"]

func set_input(port, value):
	if port is String: set_input(get_input_port(port), value)
	else: inputs[port]["value"] = value
#	print("input set: ", port, value)

func get_input(port):
	if port is String: get_input(get_input_port(port))
	else: 
#		print("input get: ", port)
		return inputs[port]["value"]

# todo invisible api input for manager?
