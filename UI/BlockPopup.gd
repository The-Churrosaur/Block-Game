
# block information and options menu - popup panel

# breaks node convention a little bit: 
# is not the node's parent but operates directly on the node (read/write fields)
# and operates anonymously to the node

class_name BlockPopup
extends PopupPanel


# FIELDS ----------------------------------------------------------------------


# -- UI
onready var block_name_label = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer2/LabelTitle
onready var block_desc_label = $MarginContainer/MarginContainer/VBoxContainer/LabelDesc


var block


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


func show_popup(new_block = null):
	if new_block != null : block = new_block
	
	block_name_label.text = block.display_name
	block_desc_label.text = block.description
	
	popup(Rect2(block.global_position, Vector2(100,100)))


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


