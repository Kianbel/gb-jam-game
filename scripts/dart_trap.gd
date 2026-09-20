extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var arrow_spawn: Node2D = $ArrowSpawn

@export var trigger: TriggerButton

enum DIRECTION {
	UP,DOWN,LEFT,RIGHT
}

@export var direction: DIRECTION = DIRECTION.LEFT

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3
var is_inverted = false

var has_shot = false

const arrow_scene = preload("res://scenes/arrow.tscn")

const SAND_INVERT_SPRITE = 0
const SAND_NORMAL_SPRITE = 1
const CAVE_INVERT_SPRITE = 2
const CAVE_NORMAL_SPRITE = 3

func _ready() -> void:
	setup()

func setup():
	if trigger:
		trigger.button_triggered.connect(shoot)
	
	var parent_group = $".."
	if parent_group is InvertedGroup:
		set_collision_layer_value(NORMAL_COLLISION, false)
		set_collision_layer_value(INVERTED_COLLISION, true)
		is_inverted = true
		if parent_group.is_in_group("Cave"): animated_sprite.frame = CAVE_INVERT_SPRITE
		else: animated_sprite.frame = SAND_INVERT_SPRITE
	else:
		set_collision_layer_value(NORMAL_COLLISION, true)
		set_collision_layer_value(INVERTED_COLLISION, false)
		if parent_group.is_in_group("Cave"): animated_sprite.frame = CAVE_NORMAL_SPRITE
		else: animated_sprite.frame = SAND_NORMAL_SPRITE

func shoot():
	if not has_shot:
		var arrow = arrow_scene.instantiate()
		arrow.direction = direction
		arrow.set_global_rotation_degrees(global_rotation_degrees)
		
		arrow.global_position = arrow_spawn.global_position
		get_parent().call_deferred("add_child", arrow)
		has_shot = true
