extends Control

# packed scenes for coaster parts
@export var loop_track_scene: PackedScene
# Example button callback for selecting a curved track piece
func _on_loop_track_button_pressed():
	var part_data = {
		"scene": loop_track_scene,
		"size": 1,
		"name": "Curved Track"
	}
	GameManager.set_held_coaster_part(part_data)
	
	# Optional: Update UI to show which part is selected
	update_selection_ui("Loop Track")


# Clear selection button
func _on_clear_selection_button_pressed():
	GameManager.clear_held_coaster_part()
	update_selection_ui("")

# Helper function to update UI feedback
func update_selection_ui(part_name: String):
	# Example: Update a label to show what's selected
	if has_node("SelectedPartLabel"):
		var label = get_node("SelectedPartLabel")
		if part_name and part_name != "":
			label.text = "Selected: " + part_name
			label.modulate = Color.GREEN
		else:
			label.text = "No part selected"
			label.modulate = Color.WHITE
	
	# Example: Highlight the pressed button
	highlight_selected_button(part_name)

func highlight_selected_button(selected_part: String):
	# Reset all button styles
	for button in get_tree().get_nodes_in_group("part_selection_buttons"):
		button.modulate = Color.WHITE
	
	# Highlight the selected button
	match selected_part:
		"Loop Track":
			if has_node("LoopTrackButton"):
				get_node("LoopTrackButton").modulate = Color.YELLOW
