
# inherits from portmanager
# track fuelports

class_name FuelPortManager
extends PortManager


# FIELDS -----------------------------------------------------------------------



# CALLBACKS --------------------------------------------------------------------


# only hold fuelports instead of all ioports
func _ready():
	
	# get children as ports and set up ports
	for child in get_children():
		if child is FuelPort:
			ports[child.port_id] = child
			
			# setup
			child.connect("port_button_pressed", self, "_on_port_button")
			child.manager = self


# PUBLIC -----------------------------------------------------------------------




# PRIVATE ----------------------------------------------------------------------

