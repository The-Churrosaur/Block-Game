
# inheritable base for ship systems (ioports rn)
class_name ShipSystem
extends Node


export var system_id : String = "default"


# this should be injected by a supermanager (groan)
onready var shipbody = get_parent()

