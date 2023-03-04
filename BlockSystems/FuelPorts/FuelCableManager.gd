
# cable manager for fuel cables 
# stores, saves, triggers fuel transfer same as data cables
# note that fuel transfer rates are single movement / tick like data

class_name FuelCableManager
extends IOCableManager


# FIELDS -----------------------------------------------------------------------




# CALLBACKS --------------------------------------------------------------------




# PUBLIC -----------------------------------------------------------------------


func save_data():
	var dict = .save_data()
	print("FUELCABLEMANAGER SAVING: ", dict)
	return dict

func load_data(dict):
	print("FUELCABLEMANAGER LOADING: ", dict)
	.load_data(dict)


# PRIVATE ----------------------------------------------------------------------


