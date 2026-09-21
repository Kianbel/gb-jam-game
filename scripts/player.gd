class_name Player
extends CharacterBody2D



@export var speed := 90.0
@export var acceleration := 1000.0
@export var friction := 2000.0

@export var jump_velocity := -200.0
@export var gravity := 700.0
@export var fall_gravity := 900.0
@export var max_fall_speed := 900.0

@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12

const NORMAL_COLLISION := 2
const INVERTED_COLLISION := 3

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

var is_input_disabled = false

var old_stage: int = 1

@export var invert_sfx: AudioStream
@export var jump_sfx: AudioStream
@export var walk_sfx: AudioStream
@export var death_sfx: AudioStream


@onready var current_level: Level = get_parent()
@onready var inverts_amount: int = current_level.MAX_INVERTS

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $HurtboxComponent
@onready var camera: Camera2D = $Camera2D

var is_cave: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("invert_level"):
		handle_invert()

func _physics_process(delta: float) -> void:
	if !is_input_disabled:
		update_coyote_time(delta)
		update_jump_buffer(delta)

		handle_jump()
		handle_movement(delta)
		update_sprite()

	handle_gravity(delta)
	handle_sound()
	move_and_slide()

func set_camera_limit_bottom(limit: int = 100000000):
	if camera:
		camera.limit_bottom = limit

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
		
	if current_level.is_inverted:
		if is_cave: animated_sprite_2d.play("cave_invert_jump_" + str(old_stage))
		else: animated_sprite_2d.play("invert_jump_" + str(old_stage))
	else:
		if is_cave: animated_sprite_2d.play("cave_normal_jump_" + str(old_stage))
		else: animated_sprite_2d.play("normal_jump_" + str(old_stage))

	velocity.y = min(velocity.y, max_fall_speed)

func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0:
		if is_on_floor():
			if current_level.is_inverted:
				if is_cave: animated_sprite_2d.play("cave_invert_" + str(old_stage))
				else: animated_sprite_2d.play("invert_" + str(old_stage))
			else:
				if is_cave: animated_sprite_2d.play("cave_normal_" + str(old_stage))
				else: animated_sprite_2d.play("normal_" + str(old_stage))
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		if is_on_floor():
			if current_level.is_inverted:
				if is_cave:
					animated_sprite_2d.play("cave_invert_" + str(old_stage))
					animated_sprite_2d.stop()
					animated_sprite_2d.frame = 0
				else:
					animated_sprite_2d.play("invert_" + str(old_stage))
					animated_sprite_2d.stop()
					animated_sprite_2d.frame = 0
			else:
				if is_cave:
					animated_sprite_2d.play("cave_normal_" + str(old_stage))
					animated_sprite_2d.stop()
					animated_sprite_2d.frame = 0
				else:
					animated_sprite_2d.play("normal_" + str(old_stage))
					animated_sprite_2d.stop()
					animated_sprite_2d.frame = 0

func update_sprite() -> void:
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false

func handle_sound():
	if Input.is_action_just_pressed("invert_level"):
		SoundManager.play_sound(invert_sfx, 1.8,1.9, -15)
	
	if Input.is_action_just_pressed("jump"):
		SoundManager.play_sound(jump_sfx, 2.3, 2.4, -10)
	
	if is_on_floor() and abs(velocity.x) > 10.0:
		if $Audio/StepTimer.is_stopped():
			SoundManager.play_sound(walk_sfx, 0.9, 1.0, -20)
			$Audio/StepTimer.start(0.35)
	else:
		$Audio/StepTimer.stop()

func handle_invert() -> void:
	if inverts_amount < 1:
		print("you inverted too much")
		SoundManager.play_sound(death_sfx, 1.0, 1.1, -10)
		get_tree().reload_current_scene()
		return

	current_level.invert_level()
	inverts_amount -= 1
	old_stage += 1
	if old_stage > 4: old_stage = 4

	if current_level.is_inverted:
		set_collision_mask_value(NORMAL_COLLISION, false)
		set_collision_mask_value(INVERTED_COLLISION, true)

		hurtbox.set_collision_mask_value(NORMAL_COLLISION, false)
		hurtbox.set_collision_mask_value(INVERTED_COLLISION, true)
	
		animated_sprite_2d.set_animation("inverted_idle")
	else:
		set_collision_mask_value(NORMAL_COLLISION, true)
		set_collision_mask_value(INVERTED_COLLISION, false)

		hurtbox.set_collision_mask_value(NORMAL_COLLISION, true)
		hurtbox.set_collision_mask_value(INVERTED_COLLISION, false)
		
		animated_sprite_2d.set_animation("normal_idle")
