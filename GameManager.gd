extends Node

# Singleton to manage game state, including held coaster parts
var held_coaster_part = null

func is_holding_coaster_part() -> bool:
	return held_coaster_part != null

func get_held_coaster_part():
	return held_coaster_part

func set_held_coaster_part(part_data):
	held_coaster_part = part_data

func clear_held_coaster_part():
	held_coaster_part = null

# Structure for coaster part data:
# {
#     "scene": PackedScene,
#     "size": int,
#     "name": String
# }
