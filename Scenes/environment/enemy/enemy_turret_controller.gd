class_name EnemyTurretController
extends EnemyController

export var shoot_distance = 2000

func on_area_detected(body):
	if body == target_manager.get_target_node(target_manager.PLAYER):
		acquire_target(body)

func on_area_lost(body):
	if body == target:
		acquire_target(body)

func on_player_hit(body):
	.on_player_hit(body)
	print("TURRET HIT")

func process_logic():
	
	# basic per-frame logic
	if target != null:
		
		# aim towards target
		weapon.target = target.global_position
		
		# face towards target
		if !character.on_platform:
			character.rotation = PI + (target.global_position - character.global_position).angle()
		
		lead_target()
		
		var distance_sq = (target.global_position - character.global_position).length_squared()
		if distance_sq < shoot_distance * shoot_distance:
			weapon.pull_trigger()
		else:
			weapon.release_trigger()

func on_decision_timer():
	pass
