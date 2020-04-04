# wrapper for a ship grid

class_name ShipBase
extends Node2D


const grid_size = 64 # pixels
onready var grid = $GridBody/GridBase
onready var body = $GridBody


func _ready():
	pass
