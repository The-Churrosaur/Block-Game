class_name GridBase_Storage
extends StorageBase

export var shipBody_address = ""

# TODO serialize block dict

func get_data(parent):
	shipBody_address = get_path_to(parent.shipBody)

func set_data(parent):
	parent.shipBody = get_node(shipBody_address)
