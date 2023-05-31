class_name DefaultGun
extends GunBase 


onready var muzzleFX = $MuzzleFX
onready var timer = $Timer


func _ready():
	pass


func fire():
	.fire()
	_show_muzzleFX()
	timer.start()


func _show_muzzleFX():
	muzzleFX.visible = true

func _hide_muzzleFX():
	muzzleFX.visible = false


func _on_Timer_timeout():
	_hide_muzzleFX()
