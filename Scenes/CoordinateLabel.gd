extends Label


func _process(delta):
	var pos = get_global_mouse_position()
	text = String(pos)
