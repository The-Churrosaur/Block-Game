
# input displays, output emits
class_name PortBlockTester
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


onready var out_port = $BlockSystems/PortManager/IOPortOUT
onready var in_port = $BlockSystems/PortManager/IOPortIN

onready var output_label = $VBoxContainer/Label
onready var slider = $VBoxContainer/HSlider
onready var input_label = $Inlabel


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	
	# send slider to output
	out_port.data = slider.value
	
	# display results
	output_label.text = str(slider.value)
	input_label.text = str(in_port.data)



# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


