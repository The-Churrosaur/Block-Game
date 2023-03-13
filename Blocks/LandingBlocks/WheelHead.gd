
# wheel block
# changes subship friction settings etc on ready
class_name WheelHead
extends PinHeadBase


# FIELDS ----------------------------------------------------------------------


export var physics_material : PhysicsMaterial


# CALLBACKS --------------------------------------------------------------------


func _ready():
	._ready()
	
	if !shipBody: return
	
	shipBody.physics_material_override = physics_material


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


