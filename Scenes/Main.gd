extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# launch test scene
	get_tree().change_scene("res://Scenes/TestScene.tscn")
#	get_tree().change_scene("res://Scenes/SandBox.tscn")
#	get_tree().change_scene("res://Scenes/SlideTest/SlideTest.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
