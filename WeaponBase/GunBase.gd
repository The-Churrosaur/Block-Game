# Fires a projectile out the barrel under a number of parameters
class_name GunBase
extends Node2D



# FIELDS =======================================================================



export var block_path : NodePath
export var muzzle_path : NodePath
export var add_velocity = true # adds ship's current velocity to projectile
export var deviate = true
export var deviation = 0.1 # radians
export var shot_impulse = 1000
export var projectile_resource : PackedScene
export var semi_auto = true
export var gun_loaded = true # one in the chamber?
# todo - magazines feed projectile resources

onready var block = get_node(block_path)

onready var muzzle_node = get_node(muzzle_path)
onready var muzzle_pos : Vector2 = muzzle_node.position 

var current_projectile



# CALLBACKS ====================================================================



func _ready():
	pass

func _process(delta):
	pass



# PUBLIC =======================================================================


# runs loader simulation (encapsulate?)
# for now just semi-auto

func pull_trigger():
	
	if gun_loaded: 
		fire()
		gun_loaded = false


func release_trigger():
	gun_loaded = true


func fire():
	
	var projectile : RigidBody2D = projectile_resource.instance()
	
	# TODO make this a scene-level child
	add_child(projectile)
	# quick learning note: 
	# my understanding is that instanced nodes exist in the aether
	# until they are adopted as children
	
	projectile.position = muzzle_pos
	
	# get deviation angle
	var deviation = 0
	if deviate:
		deviation = _get_deviation()
	
	# add self velocity
	if add_velocity:
		projectile.linear_velocity += block.shipBody.linear_velocity
	
	# kick impulse in deviated direction
	var direction = global_transform.x.rotated(deviation) 
	projectile.apply_central_impulse(direction * shot_impulse)
	
	# tell projectile its been fired
	projectile.fire(self)
	self.current_projectile = projectile



# PRIVATE ======================================================================



func _get_deviation():
	
	# base implementation returns random angle within deviation
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var rot = rand.randf_range(-deviation, deviation)
	return rot

