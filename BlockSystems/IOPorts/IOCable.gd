
# holds two ports and propagates data from A to B on command
class_name IOCable
extends Node2D

# FIELDS -----------------------------------------------------------------------


# distance the elbows move to avoid overlapping lines
export var offset_width = 10

# to request removal from the manager
signal _cable_cut(cable)

# visual line
onready var line = $Line2D

# line overlap detection
onready var collider_1 = $Area2D/CollisionShape2D
onready var collider_2 = $Area2D/CollisionShape2D2
onready var area = $Area2D
onready var raycast_1 = $Area2D/RayCast2D
onready var raycast_2 = $Area2D/RayCast2D2

# temp
onready var button = $Button

# block reference
# injected by manager
var sender_port : IOPort
var receiver_port : IOPort

# how much to nudge the elbow, injected, normalized
var nudge = Vector2.ZERO


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# connect button
	button.connect("button_down", self, "_on_button")
	
	# why not
	line.default_color = Color(randf(), randf(), randf())

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
	
	var shape_1 = SegmentShape2D.new()
	var shape_2 = SegmentShape2D.new()
	
	shape_1.a = area.to_local(send_pos)
	shape_1.b = area.to_local(joint)
	shape_2.a = area.to_local(joint)
	shape_2.b = area.to_local(receive_pos)
	
	collider_1.shape = shape_1
	collider_2.shape = shape_2
	
	
	# set raycasts
	# using raycasts to detect areas because area/area detection is BROKEN
	# for dynamically created areas (sigh)
	
#	raycast_1.position = to_local(send_pos)
#	raycast_2.position = to_local(receive_pos)
#	raycast_1.cast_to(to_local(joint))
#	raycast_2.cast_to(to_local(joint))
	
	
	# check collisions and set elbows
	
	var colliding = _check_collisions()
	
	var nudge_joint = nudge * offset_width
	var nudge_send = Vector2(nudge_joint.x, 0)
	var nudge_receive = Vector2(0, nudge_joint.y)
	
	line.set_point_position(2, to_local(joint) + nudge_joint)
	line.set_point_position(1, to_local(send_pos) + nudge_send)
	line.set_point_position(3, to_local(receive_pos) + nudge_receive)
	
	button.set_global_position(joint) 


# returns colliding cables
func _check_collisions() -> Array:
	
	var colliding = []
	
	raycast_1.enabled = true
	raycast_2.enabled = true
	
	
	
#	print("COLLIDING CABLES! ", colliding)
	
	return colliding


# for fun
func _line_color(data):
	
	var red = 255 * data / 100
	line.default_color.r8 = red
