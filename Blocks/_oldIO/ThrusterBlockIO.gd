class_name ThrusterBlockIO
extends IOBlock


export var magnitude = 10

export(NodePath) onready var flame_sprite = get_node(flame_sprite) as Sprite 

signal emit_force(pos, mag, central)


func _ready():
	pass


func _process(delta):
	if (io_box.get_input(0) > 0.5):
		fire_thruster()
		flame_sprite.visible = true
	else:
		flame_sprite.visible = false


func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	connect("emit_force", shipBody, "on_force_requested")


func fire_thruster():
	var force = Vector2.UP.rotated(rotation) * magnitude
	emit_signal("emit_force", position, force, false)
