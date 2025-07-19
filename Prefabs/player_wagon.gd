extends PathFollow3D

@export var speed: float = 5.0
@onready var detection_area: Area3D
var current_coaster_part: Node3D = null
func _ready():
	# Find and connect detection area
	if not detection_area:
		for child in get_children():
			if child is Area3D:
				detection_area = child
				break
	
	# Check for initial coaster part after physics settles
	await get_tree().process_frame
	_find_initial_coaster_part()

func _find_initial_coaster_part():
	if not detection_area:
		return
	
	# Check for existing overlaps when starting
	var overlapping_areas = detection_area.get_overlapping_areas()
	
	# Find first valid coaster part
	for area in overlapping_areas:
		var coaster_part = area.get_parent()
		if _is_valid_coaster_part(coaster_part):
			_switch_to_coaster_path(coaster_part)
			return

func _is_valid_coaster_part(node: Node3D) -> bool:
	return node != null and node.has_method("get") and node.get("coaster_path") != null

func _process(delta):
	if get_parent() is Path3D:
		# Use exponential approach to prevent reaching exactly 1.0 and looping back
		var target_progress_ratio = 0.99
		progress_ratio = (progress_ratio + speed * delta) if (progress_ratio + speed * delta) < target_progress_ratio else target_progress_ratio
		if progress_ratio >= target_progress_ratio:
			call_deferred("_on_path_completed")

		#progress = (progress + speed * delta)


func _switch_to_coaster_path(coaster_part: Node3D):
	print("attempting to switch to coaster path: ", coaster_part.name)
	var new_path = coaster_part.get("coaster_path") as Path3D
	
	if not new_path or new_path == get_parent():
		return
	
	print("Switching to new coaster path: ", new_path.name)
	# Store previous coaster part to prevent going backwards
	current_coaster_part = coaster_part
	
	# Remove from current parent and add to new path
	if get_parent():
		get_parent().remove_child(self)
	
	print("Adding to new path: ", new_path.name)
	new_path.add_child(self)
	#callback to next frame
	progress_ratio = 0.0

func set_initial_path(path: Path3D, start_progress: float = 0.0):
	if get_parent() and get_parent() != path:
		get_parent().remove_child(self)
	
	path.add_child(self)
	progress = start_progress
	# Find the coaster part that owns this path
	var path_owner = path.get_parent()
	if path_owner and path_owner.has_method("get") and path_owner.get("coaster_path") == path:
		current_coaster_part = path_owner

func _on_path_completed():
	#check overlapping areas to find next coaster part
	if not detection_area:
		print("No detection area set, cannot switch coaster part.")
		return
	var overlapping_areas = detection_area.get_overlapping_areas()
	for area in overlapping_areas:
		var coaster_part = area.get_parent()
		if _is_valid_coaster_part(coaster_part) and coaster_part != current_coaster_part:
			_switch_to_coaster_path(coaster_part)
			return
		else:
			print("Invalid coaster part or already on the same path: ", coaster_part.name)
	
