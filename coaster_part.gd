extends Node3D

# Reference to the end point where the next coaster part should be placed
@export var end_point: Node3D

# Reference to the path that the wagon should follow through this coaster part
@export var coaster_path: Path3D

# Area3D to detect when the wagon enters this coaster part (also used for hover detection)
@onready var detection_area: Area3D

# New properties for hover system
@export var part_size: int = 1  # Size of this coaster part (used for replacement compatibility)
var hover_preview: Node3D = null
var is_hovered: bool = false

func _ready():
	setup_hover_detection()

func setup_hover_detection():
	# Use existing detection_area for hover detection
	if detection_area:
		# Set up input events for hover detection on the existing area
		detection_area.input_event.connect(_on_area_input_event)
	else:
		# Create detection area if it doesn't exist (fallback)
		detection_area = Area3D.new()
		add_child(detection_area)
		
		# Create collision shape for detection
		var collision_shape = CollisionShape3D.new()
		var box_shape = BoxShape3D.new()
		box_shape.size = Vector3(2, 2, 2)  # Adjust size based on your coaster part dimensions
		collision_shape.shape = box_shape
		detection_area.add_child(collision_shape)
		
		# Set up input events for hover detection
		detection_area.input_event.connect(_on_area_input_event)

func _on_area_input_event(_camera: Node, event: InputEvent, _pos: Vector3, _normal: Vector3, _shape_idx: int):
	# This gets called when mouse events happen over the area
	if event is InputEventMouseMotion:
		if GameManager.is_holding_coaster_part() and not is_hovered:
			_on_hover_enter()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Handle click to place coaster part
		if GameManager.is_holding_coaster_part():
			_try_replace_part()

func _on_hover_enter():
	if GameManager.is_holding_coaster_part():
		is_hovered = true
		show_hover_preview()

func _on_hover_exit():
	is_hovered = false
	hide_hover_preview()

# Check if mouse has left the area (called from _process if needed)
func _check_mouse_exit():
	if is_hovered and not detection_area.has_overlapping_bodies():
		var space_state = get_world_3d().direct_space_state
		var camera = get_viewport().get_camera_3d()
		if camera:
			var mouse_pos = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse_pos)
			var to = from + camera.project_ray_normal(mouse_pos) * 1000
			
			var query = PhysicsRayQueryParameters3D.create(from, to)
			var result = space_state.intersect_ray(query)
			
			if not result or not is_ancestor_of(result.collider):
				_on_hover_exit()

func show_hover_preview():
	var held_part = GameManager.get_held_coaster_part()
	if not held_part or not held_part.has("scene"):
		return
	
	# Remove existing preview
	hide_hover_preview()
	
	# Create preview instance
	hover_preview = held_part.scene.instantiate()
	add_child(hover_preview)
	
	# Position at same location as this part
	hover_preview.global_transform = global_transform
	
	# Make it transparent and colored based on compatibility
	var can_replace = can_be_replaced_with(held_part.get("size", 1))
	var preview_color = Color.GREEN if can_replace else Color.RED
	preview_color.a = 0.5  # Semi-transparent
	
	apply_preview_material(hover_preview, preview_color)

func hide_hover_preview():
	if hover_preview:
		hover_preview.queue_free()
		hover_preview = null

func apply_preview_material(node: Node3D, color: Color):
	# Apply transparent colored material to all MeshInstance3D children recursively
	for child in node.get_children():
		if child is MeshInstance3D:
			var material = StandardMaterial3D.new()
			material.albedo_color = color
			material.flags_transparent = true
			material.no_depth_test = true
			material.flags_unshaded = true
			material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Show from all angles
			child.material_override = material
		elif child.get_child_count() > 0:
			apply_preview_material(child, color)

func can_be_replaced_with(other_part_size: int) -> bool:
	return part_size == other_part_size

func _try_replace_part():
	var held_part = GameManager.get_held_coaster_part()
	if not held_part:
		return
	
	if can_be_replaced_with(held_part.get("size", 1)):
		# TODO: Implement actual replacement logic here
		# This would involve removing this part from the track and inserting the new one
		print("Replacing coaster part with: ", held_part.get("name", "Unknown"))
		GameManager.clear_held_coaster_part()
		hide_hover_preview()
	else:
		print("Cannot replace: size mismatch")

# Optional: Use _process to continuously check mouse position for smoother hover detection
func _process(_delta):
	if is_hovered:
		_check_mouse_exit()
