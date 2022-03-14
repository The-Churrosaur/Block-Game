class_name IOBox
extends Node

# TODO export dictionaries are static??!?!


# sorry I'll automate this later
export var initial_inputs = [{"name":"","value":0.0},
							 {"name":"","value":0.0},
							 {"name":"","value":0.0},
							 {"name":"","value":0.0},
							 {"name":"","value":0.0}]

export var initial_outputs = [{"name":"","value":0.0},
							  {"name":"","value":0.0},
							  {"name":"","value":0.0},
							  {"name":"","value":0.0},
							  {"name":"","value":0.0}]

export var block_path : NodePath

# port-indexed arrays
# contain dictionaries with name, value, activated this tick etc.
# deep copy copies dict (so we don't just reference the static export dict)
onready var inputs = initial_inputs.duplicate(true)
onready var outputs = initial_outputs.duplicate(true)

onready var block = get_node_or_null(block_path)
onready var manager = null

func _ready():
	# tool
#	for i in initial_inputs.size():
#		initial_inputs[i] = {"name":"","value":0.0}
#
#	for i in initial_outputs.size():
#		initial_outputs[i] = {"name":"","value":0.0}
	
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
