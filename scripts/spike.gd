extends StaticBody2D

var is_inverted: bool = false

func _ready() -> void:
	var parent_group = $".."
	if parent_group is InvertedGroup:
		is_inverted = true
