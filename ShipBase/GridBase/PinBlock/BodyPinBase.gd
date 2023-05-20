class_name BodyPinBase
extends PortBlockBase

# currently doesn't work

# Simplified version of pinblockbase, merely pins physicsbody of choice 
# encapsulates to fix all the weird bugs with dynamic pinning
# used for wheel currently
# TODO make pinblockbase extend this

export var pin_target_path : NodePath
onready var pin_target : PhysicsBody2D = get_node(pin_target_path)

# where block will attempt to keep target
# block -> target
var pin_offset : Vector2

var pinJoint = null

var queue_pin = false



func _ready():
	._ready()
	
	pinJoint = $PinJoint2D
	
	print("bodypin loading!")
	
	if pin_target: set_pin_target(pin_target)


func _physics_process(delta):
	if (queue_pin):
#		print("POSITION", global_position, subShip.position)
		reposition_target(pin_target)
		pin_target()


func _input(event):

	pass

func post_load_setup():
	.post_load_setup()
	# wow I hate this so much but it works for now TODO TODO
#	yield(get_tree().create_timer(0.0001), "timeout")
#	setup_load_subship()

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)


func on_removed_from_grid(center_coord, block, grid):
	.on_removed_from_grid(center_coord, block, grid)
	
	# TODO are you sure you want to delete this subship?
	# can return false here


# public
func set_pin_target(target : PhysicsBody2D):
	pin_target = target
	pin_offset = target.global_position - global_position 


func pin_target():
	
	if (pinJoint is PinJoint2D):
		pinJoint.free()
	
	pinJoint = PinJoint2D.new()
	add_child(pinJoint)
	pinJoint.name = "PinJoint2D" # fine godot have it your way
	pinJoint.disable_collision = true
	
	# well well well...
#	pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
#	print("anchor position: ", grid.anchor.global_position)
	
	pinJoint.node_a = shipBody.get_path()
	
#	print("pin position: ", pinJoint.global_position)
	pinJoint.node_b = pin_target.get_path() # pin to subship
	
	queue_pin = false


# pinhead reattaching ----------------------------------------------------------


func on_pin_grid_changed(pinHead):
	reattach(pin_target)


func on_ship_com_shifted(old_pos, relative_displacement):
	reattach(pin_target)


# reattaches to pinHead position (for shifting subship)
func reattach(pinHead):
	
	print("reattaching...")
	
	queue_pin = true


func reposition_target(pinHead): 
	# first centers subship on self
	pin_target.global_position = global_position
	
	# moves target to place pinhead on old center
	shift_target_pos_to_offset(pin_target)


# moves subship to place pinhead where com was
func shift_target_pos_to_offset(target):
	
	pin_target.global_position = global_position + pin_offset



# SAVING AND LOADING ===========================================================


func get_save_data() -> Dictionary:
	var dict = .get_save_data()
	
	
	
	return dict


