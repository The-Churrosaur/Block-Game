
# Fuel tank UI element
# display pressure / max pressure
# display fuel mass

class_name FuelTankGauge
extends Node2D


# FIELDS ----------------------------------------------------------------------


export var fuel_tank_path : NodePath

export var pressure_bar_path : NodePath
export var mass_display_path : NodePath 

onready var fuel_tank = get_node(fuel_tank_path)
onready var pressure_bar = get_node(pressure_bar_path)
onready var mass_display = get_node(mass_display_path)


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# listen for tank changes
	fuel_tank.connect("fuel_amount_changed", self, "_on_fuel_amount_changed")
	
	# initial values
	_update_bars(fuel_tank.initial_amount, fuel_tank.initial_pressure)


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func _on_fuel_amount_changed(fuel_amount, fuel_pressure):
	_update_bars(fuel_amount, fuel_pressure)


func _update_bars(amount, pressure):
	pressure_bar.percent_visible = pressure
	mass_display.text = "MASS: " + str(amount)


# -- SUBSECTION


