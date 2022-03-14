extends Node2D


onready var test_ship
onready var test_grid
onready var main_ship = test_ship
onready var io_tool = $IOPicker

onready var io_tool_button = $MarginContainer/VBoxContainer/HBoxContainer/IOToolButton

var subShip = 0
var block_facing = 0
var test_block = null
var display_block = null
var block_template = null

signal ship_clicked(ship, block)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# initial ship
	var packed = load("res://ShipBase/ShipBody.tscn")
	test_ship = packed.instance()
	on_new_ship(test_ship)
	select_ship(test_ship)
	
	main_ship.position = Vector2(500,500)
	
	# setup tools
	setup_tools()
	
	# connect buttons
	$MarginContainer/VBoxContainer/HBoxContainer/IOToolButton.connect(
		"toggled", self, "on_io_tool_button_toggled")

func select_ship(ship):
	
	# decolor old ship
	if test_ship:
		test_ship.modulate = Color(1,1,1,1)
	
	test_ship = ship
	print("hooking up ship to testscene: ", ship)
	test_grid = ship.grid
	main_ship = test_ship
	
	# color new ship
	test_ship.modulate = Color(1,0.7,0.7,0.7)

func on_new_ship(ship):
	add_child(ship)
	print("CONNECTING SIGNALS ", ship)
	ship.connect("on_clicked", self, "on_ship_clicked")
	ship.connect("new_subShip", self, "on_new_subShip")
	ship.input_pickable = true

func on_new_subShip(ship, subShip, pinBlock):
	on_new_ship(subShip)

# done here to give self information (signals) to children after self ready
func setup_tools():
	# just io rn
	io_tool.setup(self)

# attempt to switch to selected ship
func on_ship_clicked(shipBody, block):
	print("scene: shipclicked")
	if shipBody == test_ship:
		print("scene: current ship selected")
		return
	elif shipBody is ShipBody:
		select_ship(shipBody)
		print("switching to ship: ", test_ship)
	else:
		print("ship clicked: no shipbody returned")
	
	emit_signal("ship_clicked", shipBody, block)

func on_io_tool_button_toggled(state):
	io_tool.set_active(state)

func on_block_select_button_pressed(block):
	if block is PackedScene:
		block_template = block
		if display_block is Block:
			display_block.queue_free()
		display_block = block_template.instance()
		add_child(display_block)

func _process(delta):
	
	if display_block is Block:
		display_block.position = get_global_mouse_position()
	
	if (Input.is_action_just_pressed("ui_right")):
		block_facing += 1
		if display_block != null:
			display_block.set_facing(block_facing)
	
	if (Input.is_action_just_pressed("ui_left")):
		block_facing -= 1
		if display_block != null:
			display_block.set_facing(block_facing)
	
	if (Input.is_action_just_pressed("ui_lclick")):
		
		if block_template is PackedScene:
			var block = block_template.instance()
			test_grid.add_block_at_point(block, get_global_mouse_position(), block_facing)
	
	if (Input.is_action_just_pressed("ui_rclick")):
		
		test_grid.remove_block_at_point(get_global_mouse_position())
	
	if (Input.is_action_just_pressed("ui_cancel")):
		test_ship.save()
	
	if (Input.is_action_just_pressed("ui_focus_next")):
		# slow but we.
		var dict = main_ship.subShips
		var keys = dict.keys()
		var index = keys.find(test_ship.name) + 1
		
		var new_ship
		if (keys.size() > index):
			new_ship = dict[keys[index]]
		else:
			new_ship = dict[keys[0]]
		
		select_ship(new_ship)
		
		print("subship selected: ", test_ship.name)
	
	if (Input.is_action_just_pressed("ui_cancel")):
		if display_block is Block:
			display_block.queue_free()
			display_block = null
			block_template = null

