# TODO not currently in use, possibly unnecessary?

extends Node2D

var scene = null
var current_ship = null

var tools = []

# call me ;)
func setup_tools(current_scene):
	scene = current_scene
	
	for t in get_children():
		if t is ShipBuilderTool: 
			tools.append(t)
			t.setup(current_scene)
