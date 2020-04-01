extends Node2D


func _ready():
	# launch test scene
	get_tree().change_scene("res://Scenes/TestScene.tscn")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
