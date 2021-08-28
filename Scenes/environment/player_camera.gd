class_name PlayerCamera
extends Node2D

export var camera_path : NodePath = "PlayerCamera"
export var player_path : NodePath
export var shaker_path : NodePath = "PlayerCamera/ScreenShaker"
export var follow_lerp = 0.1
export var follow_lerp_angle = 0.1
export var follow_on_magwalk = true
export var jump_to_camera = true

onready var camera = get_node(camera_path)
onready var player : KinematicBody2D  = get_node(player_path)
onready var shaker = get_node(shaker_path)
var following_rotation = true

func _ready():
	player.connect("entered_platform", self, "on_platform_entered")
	player.connect("left_platform", self, "on_platform_left")

func _process(delta):
	
	# follow player
	position = lerp(position, player.position, follow_lerp)
	
	# follow rotation
	if following_rotation:
		rotation = lerp_angle(rotation, player.rotation, follow_lerp_angle)

func on_platform_entered(platform, normal):
	if !follow_on_magwalk: following_rotation = false

func on_platform_left():
	
	# to test feel, this is bad
	if jump_to_camera: player.rotation = rotation
	
	if !follow_on_magwalk: following_rotation = true

