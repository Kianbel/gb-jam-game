class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var current_level: Level = get_parent()
@onready var inverts_amount: int = current_level.MAX_INVERTS

@onready var sprite2d = $Sprite2D
@onready var invertsLeftLabel = $Camera2D/LabelInvertsLeft

func _ready() -> void:
	invertsLeftLabel.text = "Inverts left: " + str(inverts_amount)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("invert_level")):
		handle_invert()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction < 0:
		sprite2d.flip_h = true
	elif direction > 0:
		sprite2d.flip_h = false

	move_and_slide()
	
func handle_invert() -> void:
	
	if inverts_amount > 1:
		current_level.invert_level()
		inverts_amount -= 1
	else:
		print("you inverted too much")
		get_tree().reload_current_scene()
		
	if invertsLeftLabel:
		invertsLeftLabel.text = "Inverts left: " + str(inverts_amount)
	
