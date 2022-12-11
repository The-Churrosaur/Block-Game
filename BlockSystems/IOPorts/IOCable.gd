
# holds two ports and propagates data from A to B on command
class_name IOCable
extends Node2D

# FIELDS -----------------------------------------------------------------------


# visual line
onready var line = $Line2D

# temp
onready var button = $Button

# block reference
# injected by manager
var sender_port : IOPort
var receiver_port : IOPort


# CALLBACKS --------------------------------------------------------------------


func _process(delta):
	
	# draw line
	line.set_point_position(0, to_local(sender_port.global_position))
	line.set_point_position(1, to_local(receiver_port.global_position))


# PUBLIC -----------------------------------------------------------------------


# sends from input to output
func send_data():
	receiver_port.data = sender_port.data


# PRIVATE ----------------------------------------------------------------------
