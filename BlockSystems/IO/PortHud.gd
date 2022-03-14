extends MarginContainer

signal button(port_number, state, is_input)

onready var button = $VBoxContainer/CheckBox
onready var label = $VBoxContainer/Label

var port_number
var port_name
var is_input

func _ready():
	button.connect("toggled", self, "on_button")

func set_port(p_num, p_name, i_in):
	port_number = p_num
	port_name = p_name
	label.text = p_name + ": " + String(p_num)
	is_input = i_in

func on_button(state):
	emit_signal("button", port_number, state, is_input)
