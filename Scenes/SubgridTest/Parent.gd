extends RigidBody2D

func _ready():
	add_central_force(Vector2(200,0))
	#apply_central_impulse(Vector2(200,0))
	pass
