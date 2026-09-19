extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $HitboxComponent

@export var speed: int = 300

enum DIRECTION {
	UP,DOWN,LEFT,RIGHT
}

var direction: DIRECTION = DIRECTION.LEFT;

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3
var is_inverted = false

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
		animated_sprite.play("sand_invert")
		animated_sprite.stop()
		
	else:
		hitbox.set_collision_layer_value(NORMAL_COLLISION, true)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, false)
		animated_sprite.play("sand_normal")
		animated_sprite.stop()


func _on_hitbox_component_body_entered(body: Node2D) -> void:
	pass
