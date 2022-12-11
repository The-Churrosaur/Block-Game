class_name BodyPinBase
extends IOBlock

# Simplified version of pinblockbase, merely pins physicsbody of choice 
# encapsulates to fix all the weird bugs with dynamic pinning
# used for wheel currently
# TODO make pinblockbase extend this

export var pin_body_path : NodePath

onready var pin_body = get_node(pin_body_path)

var pinHead = null
var pinJoint = null

var queue_pin = false

# communicates up to shipbody

func _ready():
	._ready()
	
	pinJoint = $PinJoint2D
	
	print("pinjoint loading!")


func _input(event):
	pass


func post_load_setup():
	.post_load_setup()
	# wow I hate this so much but it works for now TODO TODO
	yield(get_tree().create_timer(0.0001), "timeout")
	attach(pin_body)


func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)


func on_removed_from_grid(center_coord, block, grid):
	.on_removed_from_grid(center_coord, block, grid)


func attach(pinHead): 
	print("attaching pinhead")
	# should be placed on grid before attaching
	
	reposition_pin(pinHead)
	self.pinHead = pinHead
	queue_pin = true

	return true

func pin_subShip():
	
	if (pinJoint is PinJoint2D):
		pinJoint.free()
	
	pinJoint = PinJoint2D.new()
	add_child(pinJoint)
	pinJoint.name = "PinJoint2D" # fine godot have it your way
	pinJoint.disable_collision = true
	
	pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
	print("anchor position: ", grid.anchor.global_position)
#	print("pin position: ", pinJoint.global_position)
	pinJoint.node_b = pin_body.get_path() # pin to subship
	
	queue_pin = false
	
#	subShip.angular_velocity = 1.0 # for shits
	
	print("pinbody physics pinned")

# pinhead reattaching ----------------------------------------------------------

func on_pin_grid_changed(pinHead):
	reattach(pinHead)
	pass

# reattaches to pinHead position (for shifting subship)
func reattach(pinHead):
	
	print("reattaching...")
	
	queue_pin = true

func reposition_pin(pinHead): 
	# first centers subship on self
	pin_body.global_position = get_parent().to_global(position)
	
	# moves subship to place pinhead on old center
	shift_subship_pos_to_pinhead(pinHead)

# moves subship to place pinhead on old center
func shift_subship_pos_to_pinhead(pinHead):
	# shifts subship along inverse of pinhead relative position vector 
	var from_subship = pin_body.position + pinHead.position 
	print("subship repos: ", from_subship)
	pin_body.position -= from_subship

func _physics_process(delta):
	if (queue_pin):
#		print("POSITION", global_position, subShip.position)
		pin_subShip()

# SAVING AND LOADING ===========================================================
