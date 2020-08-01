extends RigidBody2D

func _ready():
	
	#add_torque(10000)
	pass

func _process(delta):
	if (Input.is_action_just_pressed("ui_lclick")):
		
