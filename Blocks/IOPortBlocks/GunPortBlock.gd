
# pew
class_name GunPortBlock
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


export var port_path : NodePath 

onready var port = get_node(port_path)
onready var gun = $DefaultGunBase
onready var muzzleFX = $MuzzleFX


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	
	if port.data > 0: gun.pull_trigger()
	else: gun.release_trigger()


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------



# -- SUBSECTION


