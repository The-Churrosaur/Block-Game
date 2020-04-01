# Fires a projectile out the barrel under a number of parameters
class_name GunBase
extends Node2D

var projectiles = [preload("res://WeaponBase/ProjectileBase.tscn")] # TODO temp
# if I knew how to type you to projectiles I would
var projectile_index = 0

var muzzle_pos : Vector2 = Vector2(0,0) # TODO: make this all read from projectile
var muzzle_velocity = 100 # pixels/second
var deviation = 0.1 # radians

var current_projectile

func fire(specific_projectile : Projectile = null, add_velocity = true, deviate = true):
	var current_projectile
	
	# can fire an already instantiated specific_projectile 
	if specific_projectile != null:
		current_projectile = specific_projectile
	# or instantiate new projectile
	else:
		current_projectile = projectiles[projectile_index].instance()
	
	add_child(current_projectile)
	# quick learning note: 
	# my understanding is that instanced nodes exist in the aether
	# until they are adopted as children
	
	# convert projectile to kinematic and launch it
	# then convert back to rigid

	current_projectile.mode = RigidBody2D.MODE_KINEMATIC
	
	current_projectile.position = muzzle_pos
	
	var deviation = 0
	if deviate:
		deviation = deviate_projectile(current_projectile)
	
	if add_velocity:
		add_velocity_projectile(current_projectile, deviation)
	
	current_projectile.mode = RigidBody2D.MODE_RIGID
	
	current_projectile.fire_from(self)
	self.current_projectile = current_projectile
	
	pass

func deviate_projectile(projectile : Projectile):
	
	# base implementation returns random angle within deviation
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var rot = rand.randf_range(-deviation, deviation)
	return rot
	pass

func add_velocity_projectile(projectile : Projectile, deviation = 0):
	var vec = transform.x.rotated(deviation + global_rotation)
	projectile.linear_velocity += vec * muzzle_velocity
	pass

func _ready():
	pass

func _process(delta):
	pass
