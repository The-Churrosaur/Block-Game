class_name PinBlock_Storage
extends Block_Storage

export var subShip_name = ""
export var pinHead_name = ""

func get_data(parent):
	.get_data(parent)
	subShip_name = parent.subShip_name
	pinHead_name = parent.pinHead_name

func set_data(parent):
	.set_data(parent)
	parent.subShip_name = subShip_name
	parent.pinHead_name = pinHead_name
