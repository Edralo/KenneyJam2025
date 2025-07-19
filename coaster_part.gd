extends Node3D

# Reference to the end point where the next coaster part should be placed
@export var end_point: Node3D

# Reference to the path that the wagon should follow through this coaster part
@export var coaster_path: Path3D

# Area3D to detect when the wagon enters this coaster part
@onready var detection_area: Area3D
