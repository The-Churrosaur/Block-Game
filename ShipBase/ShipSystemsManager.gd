
# holds manages, and anonymously retrieves ship systems
class_name ShipSystemsManager
extends Node


# FIELDS ----------------------------------------------------------------------


# systems, id -> system
var systems = {}


# CALLBACKS --------------------------------------------------------------------


# returns system or null
func _ready():
	
	for child in get_children():
		if child is ShipSystem:
			systems[child.system_id] = child
			
			# setup
			


# PUBLIC -----------------------------------------------------------------------


# returns system or null
func get_system(system_id : String):
	if !systems.has(system_id) : return null
	return systems[system_id]


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


