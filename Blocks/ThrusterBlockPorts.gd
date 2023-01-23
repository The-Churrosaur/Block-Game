
# 
class_name ThrusterBlockPorts
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


export var magnitude = 10

export(NodePath) onready var flame_sprite = get_node(flame_sprite) as Sprite 
export(NodePath) onready var trigger_port = get_node(trigger_port) as IOPort
export(NodePath) onready var particles = get_node(particles) as CPUParticles2D

signal emit_force(pos, mag, central)


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	if (trigger_port.data > 0):
		fire_thruster()
		flame_sprite.visible = true
		particles.emitting = true
	else:
		flame_sprite.visible = false
		particles.emitting = false


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	connect("emit_force", shipBody, "on_force_requested")


func fire_thruster():
	var force = Vector2.UP.rotated(global_rotation) * magnitude
	emit_signal("emit_force", position, force, false)


# -- SUBSECTION


