
# stores block systems for monitoring and retrieval
class_name BlockSystemsManager
extends Node2D


# FIELDS -----------------------------------------------------------------------


# parent block
export var block_path : NodePath = "../"

onready var block = get_node(block_path)

# dict of systems
onready var systems = {}


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# get children as systems and setup
	for child in get_children():
		if child is BlockSystem:
			systems[child.system_id] = child
			
			# setup
			child.block = block


# PUBLIC -----------------------------------------------------------------------


# returns system or null
func get_system(system_id : String):
	if !systems.has(system_id) : return null
	return systems[system_id]


# -- LOADING SAVING:
# -- callback from ship->block->here->system


# get save data from all systems
func get_save_data() -> Dictionary:
	
	var dict = {}
	for system in systems.values():
		dict[system.system_id] = system.get_save_data()
	
	return dict


# send saved data back to all systems
# should** be called by block after all systems are already loaded from children
func load_saved_data(dict : Dictionary):
	
	for system in systems.values():
		if dict.has(system.system_id):
			system.load_saved_data(dict[system.system_id])
