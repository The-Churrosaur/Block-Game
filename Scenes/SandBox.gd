extends Node2D

onready var camera = $CameraBase
var current_ship


func on_new_ship(ship):
	current_ship = ship
	camera.set_target(ship)
	camera.zoom_to(Vector2.ONE, 5)
