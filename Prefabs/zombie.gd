extends CharacterBody3D

@export var speed = 2

func initialize(start_position, target_position):
	look_at_from_position(start_position, target_position, Vector3.UP, true)
	velocity = Vector3.MODEL_FRONT * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(_delta: float) -> void:
	move_and_slide()
