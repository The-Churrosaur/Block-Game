
# stores block systems for monitoring and retrieval
class_name BlockSystemsManager
extends Node2D


# dict of systems
onready var systems = {}


func _ready():
	pass
	
	# get children as systems


# returns system or null
func get_system(system_id : String):
	if !systems.has(system_id) : return null
	return systems[system_id]
