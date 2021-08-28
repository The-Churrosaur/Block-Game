
class_name ik_2d
extends Node2D

# adjust rotation of two given nodes to hit target node
# assumes nodes are parented shoulder -> elbow -> hand

export var shoulder_path : NodePath
export var elbow_path : NodePath
export var hand_path : NodePath
export var target_path : NodePath

export var lengths_on_startup = false
export var calculate_ik = true

onready var shoulder : Node2D = get_node(shoulder_path)
onready var elbow : Node2D = get_node(elbow_path)
onready var hand : Node2D = get_node(hand_path)
onready var target : Node2D = get_node(target_path)

var length_a : float # shoulder to elbow
var length_b : float # elbow to hand

var shoulder_offset_angle : float # difference of arm angle from zero
var elbow_offset_angle : float

func _ready():
	if lengths_on_startup : call_deferred("set_lengths")

func _physics_process(delta):
	if calculate_ik: calculate()

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		calculate()
#		print(shoulder.rotation)

func set_target(t : Node2D):
	target = t

# set arm lengths, offsets from current position
func set_lengths():
	
	length_a = (shoulder.global_position - elbow.global_position).length()
	length_b = (elbow.global_position - hand.global_position).length()
	print("lengths: ", length_a, ", ", length_b)
	
	shoulder_offset_angle = elbow.global_position.angle_to_point(shoulder.global_position)
	var elbow_relative = shoulder.position + elbow.position
	shoulder_offset_angle = elbow_relative.angle_to_point(shoulder.position)
	print(shoulder_offset_angle)
#	shoulder_offset_angle -= shoulder.rotation
	print(shoulder.rotation)
	print("shoulder offset: ", shoulder_offset_angle)
	
	elbow_offset_angle = hand.global_position.angle_to_point(elbow.global_position)
	elbow_offset_angle -= (elbow.rotation + shoulder_offset_angle)
	print("elbow offset: ", elbow_offset_angle)

# calculate rotations
func calculate():
	
	if target == null : return
#	print("calculating ik")
	
	# get c^2
	var length_c_2 = (shoulder.global_position - target.global_position).length_squared()
	var length_c = sqrt(length_c_2)
	var length_a_2 = length_a * length_a
	var length_b_2 = length_b * length_b
	
	# cap
	if length_c > length_b + length_a:
		length_c = length_b + length_a
		length_c_2 = length_c * length_c
	
	# elbow
	var cos_C = (length_a_2 + length_b_2 - length_c_2) / (2 * length_a * length_b)
	elbow.rotation = PI - acos(cos_C)
	elbow.rotation -= elbow_offset_angle
	# flip if scale flipped
	if elbow.global_scale.y <= 0:
		elbow.rotation = - elbow.rotation
	
	# shoulder
	
	var cos_B = (length_a_2 + length_c_2 - length_b_2) / (2 * length_a * length_c)
	
	# point to target (by rotation, relative to parent)
	var target_relative = shoulder.get_parent().to_local(target.global_position)
	shoulder.rotation = shoulder.position.angle_to_point(target_relative)
	# offset by result
	shoulder.rotation -= acos(cos_B)
	shoulder.rotation += PI
	shoulder.rotation -= shoulder_offset_angle
	# flip if scale flipped
	if shoulder.global_scale.y <= 0:
#		print("scale flipped")
		shoulder.rotation = - shoulder.rotation

