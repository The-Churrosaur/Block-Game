# base class for load/save storage objects
# all paths are relative
# receives commands from parent
# has power to edit parent to save/load

class_name StorageBase
extends Node2D

var parent
export var parent_path = ""
export var data_saved = false

# gets parent data and saves to file
func save(parent, folder):
	save_data(parent)
	
	# save self to disc
	
	var address = folder + "/" + parent.name + "_storage.tscn"
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save(address, packed_scene)

# gets parent data
func save_data(parent):
	
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
