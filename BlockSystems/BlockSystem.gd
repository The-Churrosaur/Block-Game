

# base class for block systems, just for id for now
class_name BlockSystem
extends Node


# unique string
export var system_id : String


# injected by manager
var block = null


# -- LOADING AND SAVING
# -- called by manager, called by block, saves to block data


# override me
func get_save_data() -> Dictionary:
	return {}


# also override me
func load_saved_data(dict : Dictionary):
	pass

