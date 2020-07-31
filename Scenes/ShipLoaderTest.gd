extends LineEdit

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	pass

signal change_ship(ship)

func on_text_entered(var text):
	var address = "res://Ships/" + text + "/"
	var packed_scene = load(address + "/" + text + ".tscn")
	var new_ship = packed_scene.instance()
	new_ship.load_in(address)
	
	owner.add_child(new_ship)
	new_ship.position = Vector2(1100,500)
	
	emit_signal("change_ship", new_ship)
	owner.test_ship = new_ship
	owner.test_grid = new_ship.grid
	owner.main_ship = new_ship
	
	pass
