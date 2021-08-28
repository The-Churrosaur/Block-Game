extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# thank you anonz https://www.reddit.com/r/godot/comments/emnpwk/is_there_a_way_to_get_the_collision_position_from/

func _get_collision_points() -> Array:
	var all_collision_points := []
	
	for body in get_overlapping_bodies():
		for body_owner_id in body.get_shape_owners():
			for body_shape_id in body.shape_owner_get_shape_count(body_owner_id):
				var body_owner = body.shape_owner_get_owner(body_owner_id)
				var body_shape_2d = body.shape_owner_get_shape(body_owner_id, body_shape_id)
				var body_owner_global_transform = body_owner.global_transform
				var collision_points = _get_collision_points_with_shape(body_shape_2d, body_owner_global_transform)
				if collision_points:
					for point in collision_points:
						all_collision_points.append(point)
	
	return all_collision_points


func _get_collision_points_with_shape(other_shape: Shape2D, other_global_transform: Transform2D) -> Array:
	var all_collision_points := []
	
	for owner_id in get_shape_owners():
		for shape_id in shape_owner_get_shape_count(owner_id):
			var owner = shape_owner_get_owner(owner_id)
			var shape_2d = shape_owner_get_shape(owner_id, shape_id)
			var owner_global_transform = owner.global_transform
			var collision_points = shape_2d.collide_and_get_contacts(owner_global_transform,
												other_shape,
												other_global_transform)
			if collision_points:
				for point in collision_points:
					all_collision_points.append(point)
	
	return all_collision_points
