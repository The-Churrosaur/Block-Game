
# UI node for block health bar
class_name BlockHealthBar
extends Control


# FIELDS ----------------------------------------------------------------------


onready var progress_bar = $MarginContainer/TextureProgress


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


func set_health(current, total):
	progress_bar.max_value = total
	progress_bar.value = current


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


