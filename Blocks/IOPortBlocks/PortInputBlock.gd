
# io input tester
class_name PortInputBlock
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


# until we get export hints for dicts these have to index match thx 
export(Array, String) var input_strings = ["ui_left", "ui_right"]
export(Array, NodePath) var port_paths

# input -> port
onready var ports = {}
onready var label = get_node("Node2D/VBoxContainer/Label")


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# add input->port by index
	for i in input_strings.size():
		ports[input_strings[i]] = get_node(port_paths[i])


func _process(delta):
	
	pass


func _input(event):
	
	for input in input_strings:
	
		if event.is_action_pressed(input):
			ports[input].set_data(100)
		if event.is_action_released(input):
			ports[input].set_data(0)
	


# PUBLIC -----------------------------------------------------------------------


func get_save_data() -> Dictionary:
	return .get_save_data()


func load_saved_data(dict : Dictionary):
	.load_saved_data(dict)


# PRIVATE ----------------------------------------------------------------------



# -- SUBSECTION


