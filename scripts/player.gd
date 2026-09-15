class_name Player
extends CharacterBody2D



@export_category("Movement")
@export var speed := 300.0
@export var acceleration := 1500.0
@export var friction := 2000.0

@export_category("Jump")
@export var jump_velocity := -500.0
@export var gravity := 1200.0
@export var fall_gravity := 1800.0
@export var max_fall_speed := 900.0

@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12

const NORMAL_COLLISION := 2
const INVERTED_COLLISION := 3

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

@onready var current_level: Level = get_parent()
@onready var inverts_amount: int = current_level.MAX_INVERTS

@onready var sprite2d: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $HurtboxComponent

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("invert_level"):
		handle_invert()

func _physics_process(delta: float) -> void:
	update_coyote_time(delta)
	update_jump_buffer(delta)

	handle_jump()
	handle_gravity(delta)
	handle_movement(delta)
	update_sprite()

	move_and_slide()

func update_coyote_time(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

func update_jump_buffer(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

func handle_jump() -> void:
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity

		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

func handle_gravity(delta: float) -> void:
	if is_on_floor():
		return

	if velocity.y < 0:
		velocity.y += gravity * delta
	else:
		velocity.y += fall_gravity * delta

	velocity.y = min(velocity.y, max_fall_speed)

func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

func update_sprite() -> void:
	if velocity.x < 0:
		sprite2d.flip_h = true
	elif velocity.x > 0:
		sprite2d.flip_h = false

func handle_invert() -> void:
	if inverts_amount <= 1:
		print("you inverted too much")
		get_tree().reload_current_scene()
		return

	current_level.invert_level()
	inverts_amount -= 1

	if current_level.is_inverted:
		set_collision_mask_value(NORMAL_COLLISION, false)
		set_collision_mask_value(INVERTED_COLLISION, true)

		hurtbox.set_collision_mask_value(NORMAL_COLLISION, false)
		hurtbox.set_collision_mask_value(INVERTED_COLLISION, true)
	else:
		set_collision_mask_value(NORMAL_COLLISION, true)
		set_collision_mask_value(INVERTED_COLLISION, false)

		hurtbox.set_collision_mask_value(NORMAL_COLLISION, true)
		hurtbox.set_collision_mask_value(INVERTED_COLLISION, false)
