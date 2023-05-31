
# inheritable base for blocks that have ioports on them 
class_name PortBlockBase
extends Block


# FIELDS ----------------------------------------------------------------------


export var port_manager_path : NodePath = "BlockSystems/PortManager"

onready var port_manager = get_node(port_manager_path)


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


# tell manager to cut all cables on removal
# TODO this should be in the system manager 
# make this class redundant so we don't force inheritance

func on_removed_from_grid(center_grid_coord, block, grid):
	.on_removed_from_grid(center_grid_coord, block, grid)
	
	var ports = port_manager.get_ports()
	for port in ports: port.cut_cable()


# -- SUBSECTION


