
# extends ioport
# holds export reference to a fuel tank
# can be queried to anonymously pull/push fuel into that fuel tank

class_name FuelPort
extends IOPort


# FIELDS -----------------------------------------------------------------------


# -- SIGNALS


export var fuel_tank_path : NodePath


onready var fuel_tank : FuelTank = get_node(fuel_tank_path)


# CALLBACKS --------------------------------------------------------------------





# PUBLIC -----------------------------------------------------------------------


func add_tank_fuel(amount : float):
	fuel_tank.add_gas(amount)


func remove_tank_fuel(amount : float):
	fuel_tank.remove_gas(amount)


func get_tank_pressure() -> float:
	return fuel_tank.get_pressure()


# -- LOADING/SAVING
# -- called by manager

func get_saved_data() -> Dictionary:
	return .get_saved_data()


# PRIVATE ----------------------------------------------------------------------



