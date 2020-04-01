# high velocity meme
class_name Projectile
extends RigidBody2D

var muzzle_velocity
var deviation

# owned by shooter, no touch
var shooter = null

# called when the projectile is fired
func fire_from(gun): # should be typed gunbase, but circular reference
	shooter = gun

# teleport rigidbody in integrate_forces
var teleport_target : Vector2
var teleport = false
func teleport_to(pos : Vector2):
	teleport_target = pos
	teleport = true

func _integrate_forces(state):
	
	# teleport override
	if teleport:
		position = teleport_target
	pass

func _ready():
	pass

