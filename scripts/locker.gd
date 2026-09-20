extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var on_saw_player = false

var player: Player = null

@onready var endingText1: Label = get_parent().get_node("Text").get_node("DaviJonesText1")
@onready var endingText2: Label = get_parent().get_node("Text").get_node("DaviJonesText2")
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2

func saw_player():
	animated_sprite.play("default")
	endingText1.visible = true
	timer.start(6)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player.velocity.x = 0
		player.velocity.y = 0
		player.is_input_disabled = true
		player.animated_sprite_2d.play("cave_normal_1")
		player.animated_sprite_2d.stop()
		player.animated_sprite_2d.frame = 0
		
		saw_player()

func _on_timer_timeout() -> void:
	endingText1.visible = false
	endingText2.visible = true
	timer_2.start(6)


func _on_timer_2_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/title_menu.tscn")
