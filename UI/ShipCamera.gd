
# simple camera, follows target
class_name ShipCamera
extends Node2D


# FIELDS ----------------------------------------------------------------------


export var camera_path : NodePath = "Camera2D"
export var lerp_weight = 0.5
export var zoom_mult = 1.2
export var zoom_time = 1

onready var camera = get_node(camera_path)
onready var zoom_tween = $Zoomtween

onready var target : Node2D = null


# CALLBACKS --------------------------------------------------------------------


func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	
	_follow_target(delta)


func _input(event):
	
	# zoom
	
	if (event.is_action_pressed("ui_scroll_down")):
		zoom_to(camera.zoom * zoom_mult)
	
	if (event.is_action_released("ui_scroll_up")):
		zoom_to(camera.zoom / zoom_mult)

# PUBLIC -----------------------------------------------------------------------


func set_target(new_target):
	target = new_target
	print("target set: ", target)


func zoom_to(target_zoom, time = zoom_time):
	
	zoom_tween.interpolate_property(camera, 
										"zoom", 
										camera.zoom, 
										target_zoom, 
										time, 
										Tween.TRANS_SINE, 
										Tween.EASE_IN_OUT)
	
	zoom_tween.start()


# PRIVATE ----------------------------------------------------------------------


func _follow_target(delta):
	if target == null : return
	global_position = lerp(global_position, target.global_position, 
							lerp_weight * delta)


# -- SUBSECTION


