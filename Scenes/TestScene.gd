extends Node2D


var test_block = null
var display_block = null
var block_template = null
onready var test_ship = $ShipBody1
onready var test_grid = test_ship.grid


# Called when the node enters the scene tree for the first time.
func _ready():
	test_ship.connect("on_clicked", self, "on_ship_clicked")
	pass # Replace with function body.

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
	
	if (Input.is_action_just_pressed("ui_lclick")):
		
		if block_template is PackedScene:
			var block = block_template.instance()
			test_grid.add_block_at_point(block, get_global_mouse_position())
	
	if (Input.is_action_just_pressed("ui_rclick")):
		
		test_grid.remove_block_at_point(get_global_mouse_position())
	
	if (Input.is_action_just_pressed("ui_cancel")):
		print("saving")
		test_ship.save("saveTest")
	
	pass
