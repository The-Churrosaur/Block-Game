extends RigidBody2D

var collision_shape
var collision_shape2

func _ready():
	
	var rec = RectangleShape2D.new()
	rec.set_extents(Vector2(100,100))
	
	var rec2 = RectangleShape2D.new()
	rec2.set_extents(Vector2(100,100))
	
	var circ = CircleShape2D.new()
	circ.radius = 100
	
	collision_shape = CollisionShape2D.new()
	add_child(collision_shape)
	collision_shape.shape = rec
	
	collision_shape2 = CollisionShape2D.new()
	add_child(collision_shape2)
	collision_shape2.shape = circ
	collision_shape2.position += Vector2(0,400)
	
	contact_monitor = true
	contacts_reported = 1
	connect("body_shape_entered", self, "_on_body_shape_entered")
	
	pass

func _on_body_shape_entered(body_id, body, body_shape, local_shape):

	var hit_collision_shape = get_child(local_shape)
	print(hit_collision_shape)
	pass

func _process(delta):
	pass
