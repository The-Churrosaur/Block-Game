
# io input tester
class_name PortInputBlock
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


export var line_path : NodePath
export var port_path : NodePath

onready var line : LineEdit = get_node(line_path)
onready var port : IOPort = get_node(port_path)

onready var label = get_node("Node2D/VBoxContainer/Label")

var input_string = null


# CALLBACKS --------------------------------------------------------------------


func _ready():
	line.connect("text_entered", self, "_on_line_entered")


func _process(delta):
	
	
	if input_string != null:
		label.text = input_string


func _input(event):
	
	if input_string == null: return
	
#	print(input_string)
	
	if event.is_action_pressed(input_string):
		port.data = 100
	
	if event.is_action_released(input_string):
		port.data = 0


# PUBLIC -----------------------------------------------------------------------


func get_save_data() -> Dictionary:
	
	var dict = .get_save_data()
	dict["input_string"] = input_string
	
	return dict


func load_saved_data(dict : Dictionary):
	
	if dict.has("input_string"): input_string = dict["input_string"]


# PRIVATE ----------------------------------------------------------------------


func _on_line_entered(text):
	input_string = text


# -- SUBSECTION


