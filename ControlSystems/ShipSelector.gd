class_name ShipSelector
extends ShipBuilderTool

signal new_ship_selected(ship)

func _unhandled_input(event):
	
	if event.is_action_pressed("ui_lclick") and active:
		var ship 
		ship = select_new_ship(get_global_mouse_position(), scene.current_ship)
		print("Selector selected new ship: ", ship)
		emit_signal("new_ship_selected", ship)

func select_new_ship(pos, old_ship):
	var ships = find_ships_at(pos)
	print("Selector finding new ship: ", ships)
	
	# get first ship that is not currently selected
	for ship in ships:
		if ship != old_ship:
			return ship
