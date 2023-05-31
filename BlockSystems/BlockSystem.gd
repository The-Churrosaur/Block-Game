

# base class for block systems
# gets system elements of type in editor and stores 

# TODO convert port/fuelport managers and calling functions

class_name BlockSystem
extends Node


# FIELDS ----------------------------------------------------------------------


# unique string
export var system_id : String

# name of element ID's ie. port_id, tank_id
# for dictionary keying
export var element_id_field : String

# paths to all elements
# TODO update other managers (shipsystem, blocksystem manager to do this)
export (Array, NodePath) var element_paths


# holds all managed elements (ports, fuel tanks etc)
onready var elements = {}


# injected by manager
var block = null


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# get elements from path, put into dict by id
	for path in element_paths:
		var element = get_node(path)
		var element_id = element.get(element_id_field)
		elements[element_id] = element


# PUBLIC -----------------------------------------------------------------------


# -- ELEMENT ACCESS


# get specific element by id
func get_element(id : String):
	if elements.has(id): return elements[id]
	return null


# get all elements
func get_elements() -> Array:
	var array = []
	for element in elements.values() : array.append(element)
	return array


# -- LOADING AND SAVING
# -- called by manager, called by block, saves to block data


# override me
func get_save_data() -> Dictionary:
	
	var dict = {}
	
	# get save data from all elements in 'elements' subdict
	# id -> element data
	
	var elements_dict = {}
	
	for element_id in elements:
		
		var element = elements[element_id]
		
		if element.has_method("get_save_data"):
			elements_dict[element_id] = element.get_save_data()
	
	dict["elements"] = elements_dict
	return dict


# also override me
func load_saved_data(dict : Dictionary):
	
	# load data to elements
	
	if dict.has("elements"):
		
		var elements_data = dict["elements"]
		for id in elements_data:
			
			print("blocksystem elements: ", id)
			
			var element = elements[id]
			if element.has_method("load_saved_data"):
				elements[id].load_saved_data(elements_data[id])


# PRIVATE ----------------------------------------------------------------------
