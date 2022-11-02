# semi-temp?

class_name IOString
extends Node2D

onready var line = $Line2D
onready var button = $VBoxContainer/Button
onready var label = $VBoxContainer/Label

# all below should be injected by manager on startup

# to delete from manager
var manager
var out_coord
var out_port
var out_ship

# to draw line
var in_block
var out_block


func _ready():
	line.add_point(0)
	line.add_point(1)


func _process(delta):
	
#	if !(in_block and out_block): return
	
	var in_pos = in_block.global_position
	var out_pos = out_block.global_position
	
	var mid = in_pos + (out_pos - in_pos) / 2 
	position = mid
	
	line.set_point_position(0, in_pos)
	line.set_point_position(1, out_pos)
	
	print("strings processing")
