extends Node2D

onready var camera = $CameraBase
var current_ship


func on_new_ship(ship):
	
	if current_ship: current_ship.deselect_ship()
	
	current_ship = ship
	ship.select_ship()
	
	camera.set_target(ship)
	camera.zoom_to(Vector2.ONE, 5)
