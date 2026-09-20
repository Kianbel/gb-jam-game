class_name TriggerButton
extends StaticBody2D

signal button_triggered

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3

var is_inverted = false
var is_pushed = false

@onready var area2d = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	setup()

func setup():
	var parent_group = $".."
	if parent_group is InvertedGroup:
		area2d.set_collision_layer_value(NORMAL_COLLISION, false)
		area2d.set_collision_layer_value(INVERTED_COLLISION, true)
		is_inverted = true
		if parent_group.is_in_group("Cave"):
			animated_sprite_2d.play("cave_inverted")
			animated_sprite_2d.stop()
			animated_sprite_2d.frame = 0
		else:
			animated_sprite_2d.play("sand_inverted")
			animated_sprite_2d.stop()
			animated_sprite_2d.frame = 0
	else:
		area2d.set_collision_layer_value(NORMAL_COLLISION, true)
		area2d.set_collision_layer_value(INVERTED_COLLISION, false)
		if parent_group.is_in_group("Cave"):
			animated_sprite_2d.play("cave_normal")
			animated_sprite_2d.stop()
			animated_sprite_2d.frame = 0
		else:
			animated_sprite_2d.play("sand_normal")
			animated_sprite_2d.stop()
			animated_sprite_2d.frame = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_pushed && body is Player:
		is_pushed = true
		
		var parent_group = $".."
		if parent_group.is_in_group("Cave"):
			if is_inverted: animated_sprite_2d.play("cave_inverted")
			else: animated_sprite_2d.play("cave_normal")
		else:
			if is_inverted: animated_sprite_2d.play("sand_inverted")
			else: animated_sprite_2d.play("sand_normal")
