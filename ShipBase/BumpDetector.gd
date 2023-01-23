
# detects when the ship hits something and does things with that
class_name BumpDetector
extends Node2D


# FIELDS ----------------------------------------------------------------------


export var ship_path : NodePath

onready var shipBody = get_node(ship_path)

onready var label = $Label
onready var particles = $CPUParticles2D


# CALLBACKS --------------------------------------------------------------------


func _ready():
	shipBody.connect("body_shape_entered", self, "_on_ship_body_entered")
	shipBody.connect("body_shape_exited", self, "_on_ship_body_exited")
	


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func _on_ship_body_entered(body_id, body, body_shape, local_shape):
	_on_hit()


func _on_ship_body_exited(body_id, body, body_shape, local_shape):
	pass


func _on_hit():
	
	label.visible = true
	particles.emitting = true	
	
	yield(get_tree().create_timer(2), "timeout")
	
	label.visible = false

# -- SUBSECTION


