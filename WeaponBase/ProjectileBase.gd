# high velocity meme
class_name Projectile
extends RigidBody2D


onready var trail = $Line2D
onready var timer = $Timer

var firing_point

export var damage = 50


# injected by shooter, no touch
var shooter = null

# called when the projectile is fired
func fire(gun): 
	shooter = gun
	firing_point = global_position
	timer.start()



# teleport rigidbody in integrate_forces
var teleport_target : Vector2
var teleport = false
func teleport_to(pos : Vector2):
	teleport_target = pos
	teleport = true


func kill():
	queue_free()


func _integrate_forces(state):
	
	# teleport override
	if teleport:
		position = teleport_target
	pass


func _physics_process(delta):
	
	trail.set_point_position(0, to_local(firing_point))

func _ready():
	pass



func _on_Timer_timeout():
	kill()


func _on_ProjectileBody_body_entered(body):
	print("projectile hit")
	kill()
