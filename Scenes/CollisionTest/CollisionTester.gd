extends RigidBody2D

onready var ship = get_parent().get_node("ShipBase")
var collision_shape

func _ready():
	pass

func _process(delta):
	
	if (Input.is_action_just_pressed("ui_lclick")):
		stealshape()
		push()
	pass

func stealshape():
	var colliders = ship.get_children()
	print(colliders)
	
	var shape = ship.collision_shape.shape
	collision_shape = CollisionShape2D.new()
	add_child(collision_shape)
	collision_shape.shape = shape

func push():
	print("pushing")
	add_central_force(Vector2(0,-200))
