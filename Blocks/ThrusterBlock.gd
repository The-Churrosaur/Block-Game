class_name ThrusterBlock
extends Block

var force = Vector2(100000,0)
var shipBody

signal emit_force(pos, mag, central)

func _ready():
	pass

func _process(delta):
	if (Input.is_action_just_pressed("ui_up")):
		emit_signal("emit_force", position, force, true)

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	shipBody = grid.shipBody
	connect("emit_force", shipBody, "on_force_requested")
