class_name GunBlock
extends Block

onready var gun = $DefaultGunBase

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		gun.fire(null, true, true)
	pass
