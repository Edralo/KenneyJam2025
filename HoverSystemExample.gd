# Example usage script for the coaster part hover system
# This demonstrates how to set a coaster part as "held" for replacement

extends Node

# Example function to simulate picking up a coaster part from inventory
func pick_up_coaster_part(part_scene: PackedScene, size: int, part_name: String):
	var part_data = {
		"scene": part_scene,
		"size": size,
		"name": part_name
	}
	GameManager.set_held_coaster_part(part_data)
	print("Picked up coaster part: ", part_name)

# Example function to drop the held coaster part
func drop_coaster_part():
	if GameManager.is_holding_coaster_part():
		var held_part = GameManager.get_held_coaster_part()
		print("Dropped coaster part: ", held_part.get("name", "Unknown"))
		GameManager.clear_held_coaster_part()

# Example of how to load and hold a coaster part
func _ready():
	# Example: Load a coaster part scene and set it as held
	# Replace "res://path/to/your/coaster_part.tscn" with actual path
	# var coaster_scene = preload("res://Assets/Rollecoaster Package/coaster-mouse-corner-large.glb")
	# pick_up_coaster_part(coaster_scene, 1, "Large Corner")
	pass

# You can bind this to input events in your game
func _input(event):
	if event.is_action_pressed("drop_item"):  # Define this input action in your project
		drop_coaster_part()
