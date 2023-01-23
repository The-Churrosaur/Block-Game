
# holds two ports and propagates data from A to B on command
class_name IOCable
extends Node2D

# FIELDS -----------------------------------------------------------------------


# to request removal from the manager
signal _cable_cut(cable)

# visual line
onready var line = $Line2D

# temp
onready var button = $Button

# block reference
# injected by manager
var sender_port : IOPort
var receiver_port : IOPort


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# connect button
	button.connect("button_down", self, "_on_button")

func _process(delta):
	
	# draw line
	_set_lines()


# PUBLIC -----------------------------------------------------------------------


# sends from input to output
func send_data():
	if (receiver_port == null) or (sender_port == null): return 
	receiver_port.data = sender_port.data
	
	_line_color(sender_port.data)


# requests cut cable
func cut_cable():
	emit_signal("_cable_cut", self)


# PRIVATE ----------------------------------------------------------------------


# manages the button, tempish
func _on_button():
	print("button pressed")
	cut_cable()


# -- DRAWING


func _set_lines():
	
	var send_pos = sender_port.global_position
	var receive_pos = receiver_port.global_position
	
	# mid
	var joint = Vector2(send_pos.x, receive_pos.y)
	
#	print(send_pos, receive_pos, joint)
	
	# draw line
	line.set_point_position(0, to_local(send_pos))
	line.set_point_position(1, to_local(joint))
	line.set_point_position(2, to_local(receive_pos))
	
	button.set_global_position(joint) 


# for fun
func _line_color(data):
	
	var red = 255 * data / 100
	line.default_color.r8 = red
