extends Node

export var new_ship_path = "res://ShipBase/ShipBody.tscn"
onready var ship_template = load(new_ship_path)

var loading_thread : Thread
var ship
var start_time

signal ship_loaded(ship)

func load_ship(var ship_save : Resource, var target_parent : Node) -> Node2D:
	
	# load ship
	print("LOADING SHIP")
	ship = load(new_ship_path).instance()
	target_parent.add_child(ship)
	
	start_time = OS.get_ticks_msec()
	
	# threaded loading works, but with some werid behavior for subships et al.
	
	# loads from save onto new ship in thread
#	loading_thread = Thread.new()
#	loading_thread.start(self, "thread_load", ship_save)
	
	thread_load(ship_save)
	
	return ship

func thread_load(var ship_save : Resource):
	ship_save.loadShip(ship)
	print("SHIP LOADING TIME func: ", OS.get_ticks_msec() - start_time)
	emit_signal("ship_loaded", ship)

func _exit_tree():
	loading_thread.wait_to_finish()
