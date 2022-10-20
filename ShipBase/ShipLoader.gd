extends Node

export var new_ship_path = "res://ShipBase/ShipBody.tscn"
onready var ship_template = load(new_ship_path)
onready var ship_loader = Ship_SaverLoader_GDS.new() # TODO temp

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
	
	# doing this here instead of in save res for flexibility
	ship.post_load_block_setup()
	
	return ship

func thread_load(var ship_save : Resource):
	ship_loader.load_ship(ship, ship_save)
	
	print("SHIP LOADING TIME func: ", OS.get_ticks_msec() - start_time)
	emit_signal("ship_loaded", ship)

func _exit_tree():
	loading_thread.wait_to_finish()
