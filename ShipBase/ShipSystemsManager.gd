
# holds manages, and anonymously retrieves ship systems
class_name ShipSystemsManager
extends Node


# FIELDS ----------------------------------------------------------------------


# parent shipbody
export var shipBody_path : NodePath
onready var shipBody = get_node(shipBody_path)


# systems, id -> system
var systems = {}


# CALLBACKS --------------------------------------------------------------------


# returns system or null
func _ready():
	
	for child in get_children():
		if child is ShipSystem:
			systems[child.system_id] = child
			
			# setup
			child.shipBody = shipBody


# PUBLIC -----------------------------------------------------------------------


# returns system or null
func get_system(system_id : String):
	if !systems.has(system_id) : return null
	return systems[system_id]


# -- SAVING AND LOADING


# called by ship, collates savedata into system_id -> dictionary
func save_systems_data() -> Dictionary:
	
	var dict = {}
	for system in systems.values():
		dict[system.system_id] = system.save_data()
	
	return dict


func load_systems_data(dict : Dictionary):
	
	for id in dict.keys():
		var system = get_system(id)
		if system == null: continue
		system.load_data(dict[id])


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


