class_name LootSpawner
extends Node2D

export var loot_scene : PackedScene = preload("res://Scenes/environment/health_pickup.tscn")
export var loot_amount = 1
export var spawn_radius = 10

func spawn_loot(pos = global_position):
	
	for i in loot_amount:
		
		var loot = loot_scene.instance()
		
		var x = rand_range(-spawn_radius, spawn_radius)
		var y = rand_range(-spawn_radius, spawn_radius)
		var pos_offset = Vector2(x,y)
		
		loot.global_position = pos + pos_offset
		# use level singleton later
		get_tree().root.add_child(loot)
