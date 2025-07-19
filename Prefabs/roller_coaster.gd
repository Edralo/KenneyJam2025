@tool
extends Node3D
# the track. It's a list of packed scenes. It automatically instantiates and places them along the track.

@export var track_path: Array[PackedScene] : set = _set_tracks

var instantiated_nodes: Array[Node3D] = []

func _set_tracks(value):
	track_path = value
	if Engine.is_editor_hint():
		call_deferred("_auto_place_objects")

func _ready():
	if Engine.is_editor_hint():
		call_deferred("_auto_place_objects")

# This gets called when properties change in the editor
func _validate_property(property: Dictionary):
	if property.name == "track_path":
		# Force refresh when the property is changed
		if Engine.is_editor_hint():
			call_deferred("_auto_place_objects")

func _clear_instantiated_nodes():
	# Remove previously instantiated nodes
	for node in instantiated_nodes:
		if is_instance_valid(node):
			node.queue_free()
	instantiated_nodes.clear()

func _auto_place_objects():
	_clear_instantiated_nodes()
	
	var current_position = Vector3.ZERO
	var current_rotation = Vector3.ZERO
	
	for i in range(track_path.size()):
		if track_path[i] and track_path[i] is PackedScene:
			# Instantiate the packed scene
			var instance = track_path[i].instantiate()
			if instance is Node3D:
				# Add to scene and position
				add_child(instance)
				instance.name = "TrackPart_" + str(i)
				instance.position = current_position
				instance.rotation = current_rotation
				instantiated_nodes.append(instance)
				
				# Set owner for editor persistence
				if Engine.is_editor_hint():
					instance.owner = get_tree().edited_scene_root
				
				# Update position for next piece using end_point if available
				if instance.has_method("get") and instance.get("end_point") != null:
					var end_point = instance.get("end_point")
					if end_point is Node3D:
						# Calculate next position based on the end_point's global position
						current_position = instance.to_global(end_point.position) - global_position
						# Optionally use end_point's rotation for the next piece
						current_rotation = instance.rotation + end_point.rotation
				else:
					# Fallback to simple X-axis placement if no end_point
					current_position += Vector3(2, 0, 0)

# Manual function you can call from inspector for testing
@export var update_positions: bool : set = _force_update

func _force_update(value):
	if value and Engine.is_editor_hint():
		_auto_place_objects()

func manual_place_objects():
	_auto_place_objects()
