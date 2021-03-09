extends Node2D


var test_block = null
var display_block = null
var block_template = null
onready var test_ship
onready var test_grid

onready var main_ship = test_ship
var subShip = 0

var block_facing = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# test loading ship from tscn
	var packed = load("res://ShipBase/ShipBody.tscn")
	test_ship = packed.instance()
	add_child(test_ship)
	print("test ship", test_ship)
	test_grid = test_ship.grid
	print(test_grid)
	main_ship = test_ship
	
	test_ship.connect("on_clicked", self, "on_ship_clicked")
	
	main_ship.position = Vector2(500,500)

func on_ship_clicked(shipBody):
	print("scene: shipclicked")
	if shipBody is ShipBody:
		test_ship = shipBody
		test_grid = shipBody.grid
	else:
		print("ship clicked: no shipbody returned")

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
		
		test_ship = new_ship
		test_grid = new_ship.grid
		
		print("subship selected: ", test_ship.name)

