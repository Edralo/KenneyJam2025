extends Node3D

@export var zombie_prefab: PackedScene


func _on_timer_timeout() -> void:
	var zombie = zombie_prefab.instantiate()
	var zombie_spawn_locations = $SpawnPath/SpawnLocation
	zombie_spawn_locations.progress_ratio = randf()
	
	var player_position = $Player.position
	zombie.initialize(zombie_spawn_locations.position, player_position)
	add_child(zombie)
