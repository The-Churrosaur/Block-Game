extends LineEdit

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	pass

signal change_ship(ship)

func on_text_entered(var text):
	var packed_scene = load("res://Ships/" + text + "/" + text + ".tscn")
	var new_ship = packed_scene.instance()
	owner.add_child(new_ship)
	new_ship.position = Vector2(500,500)
	
	emit_signal("change_ship", new_ship)
	owner.test_ship = new_ship
	owner.test_grid = new_ship.grid
	
	pass
