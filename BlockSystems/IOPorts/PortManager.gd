
# tracks ports on this block for routing
# store ports as children of this node
class_name PortManager
extends BlockSystem


# FIELDS -----------------------------------------------------------------------


# listened to by tool
signal port_button_pressed(port, block)

# ports, filled from children on ready
onready var ports = {}


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# get children as ports and set up ports
	for child in get_children():
		if child is IOPort:
			ports[child.port_id] = child
			
			# setup
			child.connect("port_button_pressed", self, "_on_port_button")
			child.manager = self
		
			# FORWARDS COMPATIBILITY: also puts ports into elements{} and paths
			# get_element, get_elements, save data etc. should work
			
			var id = child.port_id
			if !elements.has(id):
				elements[id] = child
			var path = get_path_to(child)
			if !element_paths.has(path):
				element_paths.append(path)


# PUBLIC -----------------------------------------------------------------------


func get_port(port : String):
	if ports.has(port): return ports[port]
	return null


# get all ports
func get_ports() -> Array:
	var array = []
	for port in ports.values() : array.append(port)
	return array


# call this when port tool is selected
# TODO track state and toggle
func tool_selected():
	
	print("portmanager, tool selected, ports: ", ports)
	
	for port in ports.values():
		port.tool_selected()


# call this when port tool is deselected
func tool_deselected():
	
	for port in ports.values():
		port.tool_deselected()
	


# PRIVATE ----------------------------------------------------------------------


# propagates signal upwards to selector tool (tool is listener)
func _on_port_button(port):
	emit_signal("port_button_pressed", port, block)
	
