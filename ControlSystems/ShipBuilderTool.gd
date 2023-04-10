class_name ShipBuilderTool
extends Node2D

# unique identifier
export var tool_id = "default_tool"

export var active = false

var scene = null

# call me ;)
func setup(current_scene):
	scene = current_scene
	scene.connect("ship_clicked", self, "on_ship_reported_clicked")

func on_toggle_input(state):
	set_active(state)

func set_active(state):
	active = state
	print("tool set: ", name, ", ", active)

# listens for ships self-reporting being clicked
func on_ship_reported_clicked(ship, block):
#	print("BUILDER TOOL: ship reported clicked, ", ship)
	pass

# attempts to manually find ships at position
func find_ships_at(global_pos) -> Array: 
	var hits = []
	var state = get_world_2d().direct_space_state
	var intersections = state.intersect_point(global_pos)
	for hit in intersections:
		if hit.collider is ShipBody: hits.append(hit.collider)
	return hits
