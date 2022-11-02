# informational UI element, appears when hovered

class_name HoverNotif
extends Node2D


export var hover_area_path : NodePath
export var hidden_info_path : NodePath
export var text_path : NodePath

onready var hover_area : CollisionObject2D = get_node(hover_area_path)
onready var hidden_info : Control = get_node(hidden_info_path)
onready var text : Label = get_node(text_path)


func _ready():
	hover_area.connect("mouse_entered", self, "on_hovered")
	hover_area.connect("mouse_exited", self, "on_hover_left")


func on_hovered():
	hidden_info.visible = true


func on_hover_left():
	hidden_info.visible = false


func set_text(info : String):
	text.text = info
