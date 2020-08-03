extends LineEdit

func _ready():
	
	connect("text_entered",self,"on_text_entered")
	
	pass

func on_text_entered(var text):
	owner.main_ship.save(text)
	pass
