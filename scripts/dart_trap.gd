extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var arrow_spawn: Node2D = $ArrowSpawn

@export var trigger: TriggerButton

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3
var is_inverted = false

var has_shot = false

const arrow_scene = preload("res://scenes/arrow.tscn")

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
		animated_sprite.play("sand_invert")
		animated_sprite.stop()
		animated_sprite.frame = 0
	else:
		set_collision_layer_value(NORMAL_COLLISION, true)
		set_collision_layer_value(INVERTED_COLLISION, false)
		animated_sprite.play("sand_normal")
		animated_sprite.stop()
		animated_sprite.frame = 0

func shoot():
	if not has_shot:
		var arrow = arrow_scene.instantiate()
		arrow.global_position = arrow_spawn.global_position
		get_parent().add_child(arrow)
		has_shot = true
