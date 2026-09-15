class_name NextLevel
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var curr_scene_file_path = get_tree().current_scene.scene_file_path
		var next_level_number = curr_scene_file_path.to_int() + 1
		
		var next_level_file_path = "res://scenes/levels/level_" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_file_path)
