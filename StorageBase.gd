# base class for load/save storage objects
# all paths are relative
# receives commands from parent
# has power to edit parent to save/load

class_name StorageBase
extends Node2D

var parent
export var parent_path = ""
export var data_saved = false

func save(parent):
	
	# resolve parent
	self.parent = parent
	parent_path = get_path_to(parent)
	
	get_data(parent)
	data_saved = true

func load_data(parent):
	if (!data_saved):
		print("No data saved")
		return
	else:
		set_data(parent)


func get_data(parent):
	# override this
	pass

func set_data(parent):
	#override this
	pass
