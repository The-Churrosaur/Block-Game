class_name PinBlock_Storage
extends StorageBase

export var subShip_address = ""
export var shipBody_path = ""

func get_data(parent):
	shipBody_path = get_path_to(parent.shipBody)
	var dir = Directory.new()

func set_data(parent):
	shipBody_path = get_node(shipBody_path)
