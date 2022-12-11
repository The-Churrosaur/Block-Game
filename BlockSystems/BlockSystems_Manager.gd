
# stores block systems for monitoring and retrieval
class_name BlockSystemsManager
extends Node2D


# parent block
export var block_path : NodePath = "../"

onready var block = get_node(block_path)

# dict of systems
onready var systems = {}


func _ready():
	
	# get children as systems and setup
	for child in get_children():
		if child is BlockSystem:
			systems[child.system_id] = child
			
			# setup
			child.block = block


# returns system or null
func get_system(system_id : String):
	if !systems.has(system_id) : return null
	return systems[system_id]
