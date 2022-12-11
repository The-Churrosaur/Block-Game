
# set as head on wheel rotor
class_name WheelHead
extends PinHeadBase


export var wheel_hitbox_path : NodePath

export var pin_path : NodePath
export var wheel_body_path : NodePath

onready var wheel_hitbox : CollisionShape2D = get_node(wheel_hitbox_path)

onready var pin : Joint2D = get_node(pin_path)
onready var wheel_body : RigidBody2D = get_node(wheel_body_path)


func _ready():
	pass


func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	# test pinning
#	wheel_body.global_position = global_position
#	var ship_path = shipBody.get_path()
#	pin.set_node_a(ship_path)
#	print("WHEELHEAD pinning WHEEL")
#
	# test hitbox appending
#	var shape_owners = shipBody.get_shape_owners()
#	var shape = wheel_hitbox.get_shape()
#	print("WHEEEEEEEEEEEEEEEL HITBOX: ", shape, shape_owners)
#	print(shipBody.shape_owner_get_shape_count(1))
#	shipBody.shape_owner_add_shape(shape_owners[1], shape)
#	print(shipBody.shape_owner_get_shape_count(1))
	
#	wheel_hitbox.global_position = global_position
#	wheel_hitbox.owner = shipBody
#	shipBody.add_child(wheel_hitbox)
#
#	print("WHEEEEEEEEEEEEEEL HITBOX ADDED: ", wheel_hitbox.global_position)
#
	pass
