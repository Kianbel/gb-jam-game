class_name Hurtbox
extends Area2D

@onready var death_sfx: AudioStream = load("res://sounds/died.wav")

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if get_parent() is Player:
			var player: Player = get_parent()
			var playing = SoundManager.play_sound(death_sfx, 1.5, 1.6, -10)
			player.is_input_disabled = true
			player.velocity = Vector2.ZERO
			
			if playing:
				await playing.finished
		
		get_tree().call_deferred("reload_current_scene")
		return
	
	if area.get_parent() is TriggerButton:
		var button = area.get_parent()
		button.button_triggered.emit()
