extends CharacterBody2D

signal sawPlayer
signal chestWalk

var speed: int = 100

var isWalking: bool = false;

var player: Player = null

@onready var player_detector: Area2D = $PlayerDetector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += speed * delta
	
	if isWalking:
		velocity.x += speed * delta
		
	move_and_slide()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player_detector.monitorable = false
		player_detector.monitoring = false
		sawPlayer.emit()
		player = body
		player.is_input_disabled = true
		player.velocity.x = 0
		player.velocity.y = 0
		player.animated_sprite_2d.play("invert_1")
		player.animated_sprite_2d.stop()
		player.animated_sprite_2d.frame = 0
		player.set_camera_limit_bottom(440)

func _on_saw_player() -> void:
	animated_sprite.play("invert_stand")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "invert_stand":
		chestWalk.emit()


func _on_chest_walk() -> void:
	animated_sprite.play("invert_walk")
	isWalking = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if player:
		player.is_input_disabled = false
		queue_free()
