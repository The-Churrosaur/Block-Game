extends LineEdit

var loader

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	loader = get_node("/root/ShipLoader")


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
	
	res.ping()
	
	var ship = loader.load_ship(res, owner)
	
	ship.position = Vector2(700,500)
	ship.linear_velocity += Vector2(10,0)
	
	owner.add_child(ship)
	owner.test_ship = ship
	owner.test_grid = ship.grid
	owner.main_ship = ship
