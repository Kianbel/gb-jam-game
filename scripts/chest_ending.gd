extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var speed = 100

var saw_player = false
var player: Player = null
var is_moving = false

func _physics_process(delta: float) -> void:
	if is_moving:
		velocity.x += speed * delta
		
	if !is_on_floor():
		velocity.y += speed * 5 * delta
		
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player.velocity.x = 0
		player.velocity.y = 0
		player.is_input_disabled = true
		player.animated_sprite_2d.play("cave_normal_1")
		player.animated_sprite_2d.stop()
		player.animated_sprite_2d.frame = 0
		timer.start(3)


func _on_timer_timeout() -> void:
	animated_sprite.play("walk")
	is_moving = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if player:
		player.is_input_disabled = false
		queue_free()
