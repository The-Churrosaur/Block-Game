
# tool helper for block grid sizing
# injects the tilemap into the block size_grid

class_name BlockSizeHelper
tool
extends TileMap


# FIELDS ----------------------------------------------------------------------


export var block_path : NodePath

var block


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
#	connect("settings_changed", self, "_on_tilemap_changed")
	
	pass


func _process(delta):
	
	_on_tilemap_changed()
	
	pass


func _input(event):
#	if event.is_action_pressed("ui_lclick") or event.is_action_pressed("ui_rclick"):
#		_on_tilemap_changed()
	pass

# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func _on_tilemap_changed():
	
	block = get_node_or_null(block_path)
#	print(block_path, block)
	
	if block == null: return
	
	block.size_grid = get_used_cells()
	
#	print("cells: ", get_used_cells())
#	print("size grid: ", block.size_grid)


# -- SUBSECTION


