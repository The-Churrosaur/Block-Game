class_name PinBlock
extends Block

var subShip_template = preload("res://Ships/turretBase.tscn") # default

export var subShip_address = ""
export var subShip_saved = false

# TODO make some kind of system out of this
# just do this shit, it chains all the way down
export var shipBody_address = ""
export var shipBody_saved = false

var subShip = null
onready var pinJoint = $PinJoint2D

var queue_pin = false

func _ready():
	._ready()
	
	print("loading!")
	print(shipBody_address)
	
	var dir = Directory.new()
	
	# set saved shipbody on load
	
	if (shipBody_saved):
		shipBody = get_node_or_null(shipBody_address)
		if(shipBody == null):
			print("shipbody address invalid")
		print("shipbody loaded:")
		print(shipBody)
		grid = shipBody.grid
	
	# if valid subship address, sets subShip template, spawns
	
	if (subShip_saved):
		if (dir.file_exists(subShip_address)):
			subShip_template = load(subShip_address)
			create_pin_subShip()
	
	# TODO - ALL ON_ADDED_TO_GRID REFERENCES ARE WIPED WITH SAVE/LOAD

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	# get relative path of shipBody

	shipBody_address = get_path_to(shipBody)
	shipBody_saved = true
	
	create_pin_subShip()

func create_pin_subShip():
	
	if shipBody is ShipBody:
		
		# set up subship
		
		subShip = subShip_template.instance()
		
		# to get address when saved
		subShip.connect("saved", self, "on_subship_saved") 
		
		add_child(subShip) # note this makes subgrid child of block
		subShip.global_position = global_position # blocks' position
		
		# subship vars TODO make factory/is necessary?
		shipBody.connect("save_subships", subShip, "save_as_subship")
		
		subShip.angular_velocity = 1.0 # for shits
		
		queue_pin = true
		
	else:
		print("pinblock: base shipbody not found")
		return false

func on_subship_saved(name, address):
	subShip_address = address
	subShip_saved = true

func _process(delta):
	if (queue_pin):
		pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
		pinJoint.node_b = subShip.get_path()
		queue_pin = false
