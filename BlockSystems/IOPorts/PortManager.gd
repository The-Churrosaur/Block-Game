
# tracks ports on this block for routing
# store ports as children of this node
class_name PortManager
extends BlockSystem


# FIELDS -----------------------------------------------------------------------


# listened to by tool
signal port_button_pressed(port)

# ports, filled from children on ready
onready var ports = {}


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# get children as ports and set up ports
	for child in get_children():
		if child is IOPort:
			ports[child.port_id] = child
			child.connect("port_button_pressed", self, "_on_port_button")


# PUBLIC -----------------------------------------------------------------------


func get_port(port : String):
	if ports.has(port): return ports[port]
	return null


# call this when port tool is selected
func tool_selected(port_tool):
	
	for port in ports.values():
		port.tool_selected()


# call this when port tool is deselected
func tool_deselected():
	
	for port in ports.values():
		port.tool_deselected()
	


# PRIVATE ----------------------------------------------------------------------


# propagates signal upwards to selector tool (tool is listener)
func _on_port_button(port):
	emit_signal("port_button_pressed", port)
	
