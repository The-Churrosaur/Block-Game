# pure serializable container for ship-as-collection-of-blocks

class_name ShipSaveResource
extends Resource

# pre-store all types of blocks for quick instantiation
export var block_types : Dictionary

# array of dicts: where all the blocks are (coordinates are internal)
export var blocks : Array
 
