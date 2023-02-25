
# cable tool for fuel cables
class_name FuelCabletool
extends IOCableTool


# FIELDS ----------------------------------------------------------------------





# CALLBACKS --------------------------------------------------------------------





# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


# plug in here and process pressed port only if port is fuelport
func _on_listening_pressed(port : IOPort, block : Block):
	if !(port is FuelPort): return
	._on_listening_pressed(port, block)


# -- SUBSECTION


