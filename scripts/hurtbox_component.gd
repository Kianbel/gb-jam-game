extends Area2D

@export var is_invertible: bool = true

@onready var parent = $".."
@onready var level = $"../../.."

func _on_body_entered(body: Node2D) -> void:
	#print(level.is_inverted(), parent.is_inverted)
	
	if not is_invertible:
		if body is Player:
			get_tree().reload_current_scene()
			return
	
	if body is Player and (level.is_inverted() == parent.is_inverted):
		get_tree().reload_current_scene()
