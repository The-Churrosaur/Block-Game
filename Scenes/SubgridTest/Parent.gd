extends RigidBody2D

signal ree


func _ready():
	#add_central_force(Vector2(200,0))
	apply_central_impulse(Vector2(200,0))
	connect("ree",self,"test")
	
	pass

func _integrate_forces(state):
	if (Input.is_action_just_pressed("ui_lclick")):
		mode = MODE_KINEMATIC
		emit_signal("ree")
		mode = MODE_RIGID

func test():
	position = Vector2(100,0)
