class_name JointBlock
extends Block

export var joint_path : NodePath = "Joint"
export var new_ship_resource : Resource
# location of default connection block
export var new_ship_block_pos = Vector2(0,0)

onready var ship_loader = get_node("/root/ShipLoader")
onready var joint = get_node(joint_path)

var subship : RigidBody2D
var subship_name : String # make this guid or something later
var connected_block : Node2D
var connected_block_pos : Vector2 # ditto here, but would require fast get by id in grid

func _ready():
	pass
	
func _physics_process(delta):
	if subship != null:
#		subship.linear_velocity = Vector2(10,10)
#		print(subship.position)
		pass

func _input(event):
	
	# test input
	if event.is_action_pressed("ui_home"):
		spawn_new_subship()

func spawn_new_subship():
	
	connected_block_pos = new_ship_block_pos
	# TODO place in tree through level singleton
	subship = ship_loader.load_ship(new_ship_resource, get_tree().root)
	
	# for threaded load
#	ship_loader.connect("ship_loaded", self, "on_ship_loaded")
	
	add_subship(subship)

# wait for ship to load in (threaded), then set up
func on_ship_loaded(ship):
	if ship == subship:
		# hacky and bad TODO why does it not move earlier
		add_subship(ship)

func add_subship(ship : RigidBody2D):
	# setup ship vars
	subship_name = subship.name
	connected_block = subship.grid
	
	# get connected block
	connected_block = subship.get_block(connected_block_pos)
	
	pin_ship()

func position_subship_to_block():
	
	var block_pos = subship.to_local(connected_block.global_position)
	print("jointblock pos: ",block_pos, connected_block.position + subship.grid.position)
	subship.global_position = global_position - block_pos
	print("JOINTBLOCK POSITION: ", global_position, subship.global_position, connected_block.global_position)

func pin_ship():
	position_subship_to_block()
	print("PINNING SHIP")
	print("JOINTBLOCK POSITION: ", global_position, subship.global_position, connected_block.global_position)
	joint.node_a = joint.get_path_to(shipBody)
	joint.node_b = joint.get_path_to(subship)
	
	# test
	subship.angular_velocity += 1

func get_save_data() -> Dictionary:
	var dict = .get_save_data()
	
	dict["subship_name"] = subship_name
	dict["connected_block_pos"] = connected_block_pos
	
	return dict
