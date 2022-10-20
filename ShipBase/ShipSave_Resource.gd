# pure serializable container for ship-as-collection-of-blocks

class_name ShipSaveResource
extends Resource

# pre-store all types of blocks for quick instantiation
# dict blocktype string -> bool
# TODO is this the best way to do this?
export var block_types : Dictionary

# array of dicts: where all the blocks are (coordinates are internal)
export var blocks : Array

# all other ship data specified in ship's get_save_data
export var ship_data : Dictionary
 
