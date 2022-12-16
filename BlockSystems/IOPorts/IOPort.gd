
# physical and data representation of a port
# blind, read from and written to by cables and parent block logic
class_name IOPort
extends Node2D


# FIELDS -----------------------------------------------------------------------


# -- SIGNALS


# hooked up to manager
signal port_button_pressed(port)


# unique name
export var port_id : String

# display name 
export var port_display_name : String = port_id

# input or output
# allow reading, writing or both
export var is_input = false
export var is_output = false

# the data associated with this port
onready var data = 0.0

# occupying cable (injected by cable)
# also used for determing availability
onready var cable = null

# this port's manager (injected by manager)
var manager= null 


# -- UI


# area for registering selection DEPREC
onready var select_area = $Area2D

# selection button
onready var select_button = $Button

# label
onready var label = $Label
onready var label2 = $Label2


# CALLBACKS --------------------------------------------------------------------


func _ready():
	label.text = port_display_name
	select_button.connect("pressed", self, "_on_button_pressed")


# PUBLIC -----------------------------------------------------------------------


# called by manager when selection tool is activated

func tool_selected():
	select_button.visible = true


func tool_deselected():
	select_button.visible = false


# for testing purposes rn
func set_label(text):
	label2.text = text


# PRIVATE ----------------------------------------------------------------------


func _on_button_pressed():
	emit_signal("port_button_pressed", self)
