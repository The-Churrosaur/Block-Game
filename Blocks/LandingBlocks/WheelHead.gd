
# wheel block
# changes subship friction settings etc on ready
class_name WheelHead
extends PinHeadBase


# FIELDS ----------------------------------------------------------------------


export var physics_material : PhysicsMaterial


# CALLBACKS --------------------------------------------------------------------


func _ready():
	._ready()
	
	# bad but eh for now
	yield(get_tree(),"idle_frame")
	
	if !shipBody: return
	
	print("wheelhead OVERRIDING SHIP MATERIAL")
	shipBody.physics_material_override = physics_material


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


