
# inheritable base for ship systems (ioports rn)
class_name ShipSystem
extends Node


export var system_id : String = "default"


# injected by manager
var shipBody = null


# -- SAVING AND LOADING 
# called by shipsystem manager


# override this to save data for this shipsystem 
func save_data() -> Dictionary:
	return {}


# override this to process data that you saved above
func load_data(dict : Dictionary):
	pass
