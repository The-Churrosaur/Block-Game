extends MarginContainer

signal button(port_number, state)

onready var button = $VBoxContainer/CheckBox
onready var label = $VBoxContainer/Label

var port_number
var port_name

func _ready():
	button.connect("toggled", self, "on_button")

func set_port(p_num, p_name):
	port_number = p_num
	port_name = p_name
	label.text = p_name + ": " + String(p_num)

func on_button(state):
	emit_signal("button", port_number, state)
