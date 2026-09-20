extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $HitboxComponent

@export var speed: int = 300

enum DIRECTION {
	UP,DOWN,LEFT,RIGHT
}

const SAND_INVERTED_SPRITE = 0
const SAND_NORMAL_SPRITE = 1
const CAVE_INVERTED_SPRITE = 2
const CAVE_NORMAL_SPRITE = 3

var direction: DIRECTION = DIRECTION.LEFT;

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3
var is_inverted = false

const sand_invert_sprite = 0
const sand_normal_sprite = 1

func _ready() -> void:
	setup()
	
func _process(delta: float) -> void:
	match(direction):
		DIRECTION.LEFT:
			position.x -= speed * delta
		DIRECTION.RIGHT:
			position.x += speed * delta
		DIRECTION.UP:
			position.y -= speed * delta
		DIRECTION.DOWN:
			position.y += speed * delta

func setup():
	var parent_group = $".."
	if parent_group is InvertedGroup:
		is_inverted = true
		hitbox.set_collision_layer_value(NORMAL_COLLISION, false)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, true)
		if parent_group.is_in_group("Cave"): animated_sprite.frame = CAVE_INVERTED_SPRITE
		else: animated_sprite.frame = sand_invert_sprite
		
	else:
		hitbox.set_collision_layer_value(NORMAL_COLLISION, true)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, false)
		if parent_group.is_in_group("Cave"): animated_sprite.frame = CAVE_NORMAL_SPRITE
		else: animated_sprite.frame = SAND_NORMAL_SPRITE
