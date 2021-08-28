extends KinematicBody2D

var velocity = Vector2(100,100)

func _physics_process(delta):
	velocity = move_and_slide_with_snap(velocity, Vector2(0,20))
