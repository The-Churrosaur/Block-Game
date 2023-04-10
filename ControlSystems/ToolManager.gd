
# building tool manager
# stores and delegates tool usage
# also manages currently selected ship

class_name ToolManager
extends Node



# FIELDS ----------------------------------------------------------------------



export (Array, NodePath) var tool_paths


# id -> tool, populated from paths on ready
var tools = {}

# selected ship to work on
var selected_ship : ShipBody



# CALLBACKS --------------------------------------------------------------------



func _ready():
	
	# populate tool dict
	for path in tool_paths:
		var node = get_node_or_null(path)
		if node is ShipBuilderTool: tools[node.tool_id] = node



func _process(delta):
	pass



# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


