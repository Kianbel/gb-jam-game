class_name Hurtbox
extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		get_tree().call_deferred("reload_current_scene")
		return
	
	if area.get_parent() is TriggerButton:
		var button = area.get_parent()
		button.button_triggered.emit()
