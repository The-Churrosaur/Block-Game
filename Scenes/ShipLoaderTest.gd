extends LineEdit

var loader

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	loader = get_node("/root/ShipLoader")


# hacky TODO 
func _is_pos_in(checkpos:Vector2):
	var gr=get_global_rect()
	return (checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and 
			checkpos.x<gr.end.x and checkpos.y<gr.end.y)

func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position):
		release_focus()


signal change_ship(ship)


func on_text_entered(var text):
#	var address = "res://Ships/" + text + "/"
#	var packed_scene = load(address + "/" + text + ".tscn")
#	var new_ship = packed_scene.instance()
#	owner.add_child(new_ship)
#	new_ship.load_in(address)
#	new_ship.position = Vector2(1100,500)
#
#	emit_signal("change_ship", new_ship)
#	owner.test_ship = new_ship
#	owner.test_grid = new_ship.grid
#	owner.main_ship = new_ship
	
	var address = "res://Ships/" + text + "/" + text + ".tres"
	
	var res = ResourceLoader.load(address)
	print("ship save loaded: ", address)
	
	var ship = loader.load_ship(res, owner, false, Vector2(700,500))
	owner.on_new_ship(ship)
	
	print("grid position: ", ship.grid.position)

