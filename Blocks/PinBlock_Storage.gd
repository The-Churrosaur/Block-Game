class_name PinBlock_Storage
extends StorageBase

export var subShip_name = ""

func get_data(parent):
	subShip_name = parent.subShip_name

func set_data(parent):
	parent.subShip_name = subShip_name
