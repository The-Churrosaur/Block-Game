class_name SceneSwitcher
extends Button

export var scene : String

func _pressed():
	get_tree().change_scene(scene)
