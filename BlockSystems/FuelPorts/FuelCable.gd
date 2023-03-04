
# holds two fuelports and a 'resistance' value 
# calculates fuel flow as pressure difference between ports / resistance
# and pushes flow to ports

# FYI 'sender' 'receiver' dichotomy is purely vesitigial from ioports
# and just used for identification
# flow can go both ways depending on pressure delta

class_name FuelCable
extends IOCable

# FIELDS -----------------------------------------------------------------------


export var resistance = 3


# CALLBACKS --------------------------------------------------------------------


func _ready():
	._ready()
	
	# double check ports are fuelports
	# should hopefully be caught by tool already
	var not_fuel = !(sender_port is FuelPort) or !(receiver_port is FuelPort)
	assert(not_fuel, "Fuel Cable not attached to fuelports")


# PUBLIC -----------------------------------------------------------------------


# overriding send_data to calculate and send fuel
func send_data():
	
	# check null
	if (receiver_port == null) or (sender_port == null): return 
	
	# check active
	if !(receiver_port.is_active) or !(sender_port.is_active): return
	
	var p1 = sender_port.get_tank_pressure()
	var p2 = receiver_port.get_tank_pressure()
	var pressure_delta = p1 - p2
	
	var flow = pressure_delta / resistance
	
	# positive: sender->receiver
	# negative: reciever->sender
	
#	print("FUEL CABLE SENDING DATA: ", flow, " ", self)
	
	# being cute and using the sign for directionality
	sender_port.add_tank_fuel(-flow)
	receiver_port.add_tank_fuel(flow)
	
	# color by flow
	_line_color(flow)


# PRIVATE ----------------------------------------------------------------------


# also temp
func _line_color(data):
	
	var red = 255 * data / 100
	line.default_color.g8 = red
