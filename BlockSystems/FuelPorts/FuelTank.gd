
# Stores gas amount and volume, ergo pressure 
# can be called to add/remove fuel
# todo multiple density gasses?

# TODO fuel manager hooked up to block manager saver/loader

class_name FuelTank
extends Node2D


# FIELDS ----------------------------------------------------------------------

# -- SIGNALS

signal fuel_amount_changed(new_amount, new_pressure)


# system id
export var fuel_tank_id : String

export var volume : float
export var max_pressure : float

export var initial_amount : float
export var initial_pressure : float

# 'amount of gas' - can be thought of as NRT, or mass of gass
# gass mass ass
var gas_amount = 0 
# 'pressure' -- amount / volume -- NRT / V
var pressure = 0


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


func add_gas(amount : float):
	_set_gas_pressure(gas_amount + amount)

func remove_gas(amount : float):
	_set_gas_pressure(gas_amount + amount)

func get_pressure() -> float:
	return pressure


# -- LOADING SAVING
# -- called by blocksystem


func get_save_data() -> Dictionary:
	
	var dict = {}
	
	dict["amount"] = gas_amount
	dict["pressure"] = pressure
	
	return dict

func load_saved_data(dict):
	
	gas_amount = dict["amount"]
	pressure = dict["pressure"]


# PRIVATE ----------------------------------------------------------------------


func _set_gas_pressure(amount : float):
	
	gas_amount = amount
	
	# mass / volume 
	pressure = gas_amount / volume
	
#	print("gas set: ", amount, " pressure: ", pressure, " max: ", max_pressure)
	
	emit_signal("fuel_amount_changed", gas_amount, pressure)


# -- SUBSECTION


