
class_name ShipStorage
extends Resource

export var block_types = []
export var blocks = []

func add_block(block):
	
	# iterate through block types, if no match, append
	# TODO make this more efficient for many types of blocks
	var t = block.class_type
	var new_type = true
	
	for type in block_types:
		if t == type:
			new_type = false
			break
	if new_type:
		add_type(block)

func add_type(block):
	block_types.append(block.type)
