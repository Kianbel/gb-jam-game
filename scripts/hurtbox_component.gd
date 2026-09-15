class_name Hurtbox
extends Area2D

func _on_area_entered(area: Area2D) -> void:
	print(area.get_parent())
	
	if area is Hitbox:
		get_tree().reload_current_scene()
		return
	
	# TODO: transfer this to Button or somewhere there
	if area.get_parent() is TriggerButton:
		var button = area.get_parent()
		button.button_triggered.emit()
