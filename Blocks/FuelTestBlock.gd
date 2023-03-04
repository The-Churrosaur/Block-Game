
# test fuel tank
class_name FuelTestBlock
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


onready var line_edit = $Node2D/VBoxContainer/LineEdit
onready var fuel_tank = $BlockSystems/FuelTankManager/FuelTank


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func _on_LineEdit_text_entered(new_text):
	print("text entered")
	fuel_tank.add_gas(float(new_text))


# -- SUBSECTION





