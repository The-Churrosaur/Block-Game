
# for spawning ships into scenery at a given point
# spawns ship at this nodes' position 
# TODO visual display in editor, orientation

class_name ShipSpawner
extends Node2D


# FIELDS ----------------------------------------------------------------------


export(Resource) var ship_resource

onready var ship_loader = get_node("/root/ShipLoader")


# CALLBACKS --------------------------------------------------------------------


func _ready():
	call_deferred("spawn")


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


func spawn():
	var ship = ship_loader.load_ship(ship_resource, self, false, Vector2.ZERO)
	ship.rotation = rotation


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


