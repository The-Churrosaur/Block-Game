
# inherits from portmanager
# track fuelports

class_name FuelPortManager
extends PortManager


# FIELDS -----------------------------------------------------------------------



# CALLBACKS --------------------------------------------------------------------

func _ready():
	._ready()
	
	print("fuelports: ", ports)


# PUBLIC -----------------------------------------------------------------------


func tool_selected():
	.tool_selected()
	
	print("fuelport: tool selected. ports: ", ports)


# PRIVATE ----------------------------------------------------------------------

