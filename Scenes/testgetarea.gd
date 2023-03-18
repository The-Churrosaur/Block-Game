
# 
class_name GetAreaTest
extends Area2D


# FIELDS ----------------------------------------------------------------------


onready var raycast = $RayCast2D


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
#	print(get_overlapping_areas())
	pass

func _physics_process(delta):
	if raycast.is_colliding():
#		print("raycast: ", raycast.get_collider())
		pass
	pass


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION




func _on_Area2D_area_entered(area):
	print("MOUSE ENTERED AREA: ", area)
