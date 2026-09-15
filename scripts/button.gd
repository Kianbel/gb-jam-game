class_name TriggerButton
extends StaticBody2D

signal button_triggered

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3

var is_inverted = false;

@onready var area2d = $Area2D

func _ready() -> void:
	setup_collision()

func setup_collision():
	var parent_group = $".."
	if parent_group is InvertedGroup:
		area2d.set_collision_layer_value(NORMAL_COLLISION, false)
		area2d.set_collision_layer_value(INVERTED_COLLISION, true)
		is_inverted = true
	else:
		area2d.set_collision_layer_value(NORMAL_COLLISION, true)
		area2d.set_collision_layer_value(INVERTED_COLLISION, false)
