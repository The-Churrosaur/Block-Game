
# holds two ports and propagates data from A to B on command
class_name IOCable
extends Node2D

# FIELDS -----------------------------------------------------------------------


# to request removal from the manager
signal _cable_cut(cable)

# visual line
onready var line = $Line2D

onready var segment_1 = $Area2D/SegmentShape1
onready var segment_2 = $Area2D/SegmentShape2

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
	
	# check null
	if (receiver_port == null) or (sender_port == null): return 
	
	# check active
	if !(receiver_port.is_active) or !(sender_port.is_active): return
	
	receiver_port.set_data(sender_port.get_data())
	
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
	line.set_point_position(2, to_local(joint))
	line.set_point_position(4, to_local(receive_pos))
	
	# set segments
	
	
	
	# check collisions and set elbows
	
	var colliding = _check_collisions()
	
	if colliding.empty(): 
		line.set_point_position(1, to_local(send_pos))
		line.set_point_position(3, to_local(receive_pos))
	
	else:
		pass
	
	button.set_global_position(joint) 


# returns colliding cables
func _check_collisions() -> Array:
	
	var colliding = []
	
	return colliding
	
	


# for fun
func _line_color(data):
	
	var red = 255 * data / 100
	line.default_color.r8 = red
