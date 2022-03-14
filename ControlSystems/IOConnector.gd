extends Node2D

export var active = false

onready var hud = $CanvasLayer/HudDolly/IOHud
onready var hud_dolly = $CanvasLayer/HudDolly

var current_ship = null
var scene

var waiting = false # for signal from button

var coord_one = null
var port_one = null
var ship_one = null

var coord_two = null
var port_two = null
var ship_two = null

# flag -1 to exit
# default 0
signal end_waiting_for_port(port, flag)

func _ready():
	hud.connect("port_selected", self, "on_port_selected")

# call me ;)
func setup(current_scene):
	scene = current_scene
	scene.connect("ship_clicked", self, "on_ship_clicked")

func set_active(state):
	active = state
	print("io tool set: ", active)

# signal hooks into scene
func on_ship_clicked(ship, block):
	
	if !active or waiting: return
	
	current_ship = ship
	
	print("io tool registers ship click")
	
	# no coord one? then look for output
	if !coord_one:
		set_output(ship, block)
	
	else:
		# wary - will return while still yielding for a button
		set_input(ship, block)

func on_port_selected(port, state, is_input):
	emit_signal("end_waiting_for_port", port, 0)

func set_output(ship, block):
	print("setting output")
	if block is IOBlock:
		# set and open hud
		hud.set_io_box(block.io_box)
		hud.show_outputs(true)
		hud.show_inputs(false)
		hud.set_display(true)
		hud_dolly.global_position = block.global_position
		# wait until button is pressed
		# get signal ags in port_data
		waiting = true
		var port_data = yield(self, "end_waiting_for_port")
		waiting = false
		# set input info or cancel
		if port_data[1] < 0: 
			coord_one = null
			port_one = null
			print("Cancelling port input")
		else:
			coord_one = block.center_grid_coord
			port_one = port_data[0]
			print("port output set!")
		hud.set_display(false)
		hud.show_outputs(false)
		hud.reset_port_huds()

func set_input(ship, block):
	print("setting input")
	if block is IOBlock:
		# set and open hud
		hud.set_io_box(block.io_box)
		hud.show_inputs(true)
		hud.show_outputs(false)
		hud.set_display(true)
		hud_dolly.global_position = block.global_position
		# wait until button is pressed
		# get signal ags in port_data
		waiting = true
		var port_data = yield(self, "end_waiting_for_port")
		waiting = false
		# set input info
		if port_data[1] < 0: 
			coord_two = null
			port_two = null
			print("Cancelling port input")
		else:
			coord_two = block.center_grid_coord
			port_two = port_data[0]
			print("port input set!")
			# set connection
			set_connection()
			# reset all ports to reset for next and avoid mishap
			coord_one = null
			coord_two = null
			port_one = null
			port_two = null
			
		hud.set_display(false)
		hud.show_inputs(false)
		hud.reset_port_huds()

func set_connection():
	# out, in
	current_ship.io_manager.add_connection(
							coord_one, port_one, coord_two, port_two)

func _input(event):

	# cancel selection
	if event.is_action_pressed("ui_cancel"):
		print("cancelling")
		emit_signal("end_waiting_for_port", 0, -1)
