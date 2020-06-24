extends LineEdit

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	pass

func on_text_entered(var text):
	var packed_scene = load("res://Ships/" + text + ".tscn")
	var new_ship = packed_scene.instance()
	owner.add_child(new_ship)
	new_ship.position = Vector2(500,500)
	pass
