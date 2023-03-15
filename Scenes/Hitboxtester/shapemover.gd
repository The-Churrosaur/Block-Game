
# for testing moving collisionshapes 

# FINDINGS:
# see below - method taken from 2020 build on github :(
# adding a collider child also adds the shape to the physics server/shape_owners

class_name shapemover
extends Node2D


# FIELDS -----------------------------------------------------------------------


onready var shape = $CollisionShape2D
onready var body = $RigidBody2D
onready var holder = $KinematicBody2D


# CALLBACKS --------------------------------------------------------------------


func _ready():
	move_shape_to(shape, body, body.to_local(shape.position))
	pass


func _input(event):
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
#		body.get_child(1).position += Vector2(10,0)
		move_com_alt(get_global_mouse_position())


# PUBLIC -----------------------------------------------------------------------


func move_com_alt(global_pos: Vector2):
	# displacement in body frame of reference
	var displacement = body.to_local(global_pos)
	body.position = global_pos
	
	for child in body.get_children():
		if child is CollisionShape2D:
			child.position -= displacement
	
	

func move_shape_to(col_shape : CollisionShape2D, 
				   body : CollisionObject2D, 
				   pos : Vector2):
	
	# TESTING
	
	var shape = col_shape.shape
	var new_shape = RectangleShape2D.new()
	new_shape.extents = Vector2(10,5)
	var id = body.create_shape_owner(body)
	body.shape_owner_add_shape(id, new_shape)
	
	return
	
	
	
	
	var shape_2d = col_shape.shape
	
	# add collisionshape2d as child
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape_2d
	collision_shape.position = pos
	
	body.add_child(collision_shape)
	collision_shape.owner = body
	
	
	var shape_owners = body.get_shape_owners()
	
	
	for i in shape_owners:
		print("shape owner: ", i)
		var shape_count = body.shape_owner_get_shape_count(i)
		print("shape count: ", shape_count)
		for j in shape_count:
			print(body.shape_owner_get_shape(i, j))
		
	






# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


