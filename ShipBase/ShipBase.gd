extends RigidBody2D

func _ready():
	var shape_owners = get_shape_owners()
	print(shape_owners)
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(500,100))
	shape_owner_add_shape(0, shape)
	pass
