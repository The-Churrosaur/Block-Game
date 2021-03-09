extends LineEdit

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	pass

func on_text_entered(var text):
	owner.main_ship.save(text)
#
#	var ship = owner.main_ship.ship_save.loadShip("res://ShipBase/ShipBody.tscn", "res://Blocks/")
#	owner.add_child(ship)
#	owner.test_ship = ship
#	owner.test_grid = ship.grid
#	owner.main_ship = ship
	pass
