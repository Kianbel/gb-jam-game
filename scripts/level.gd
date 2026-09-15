class_name Level
extends Node

@export var MAX_INVERTS: int = 5
var _is_inverted: bool = false

@export var inverted_domain: InvertedGroup
@export var noninverted_domain: NonInvertedGroup
@export var inverted_tilemaplayer: TileMapLayer
@export var noninverted_tilemaplayer: TileMapLayer

@onready var player = $Player

func _ready() -> void:
	inverted_domain.visible = false
	inverted_tilemaplayer.enabled = false

func invert_level() -> void:
	_is_inverted = !_is_inverted
	inverted_domain.visible = !inverted_domain.visible
	noninverted_domain.visible = !noninverted_domain.visible
	inverted_tilemaplayer.enabled = !inverted_tilemaplayer.enabled
	noninverted_tilemaplayer.enabled = !noninverted_tilemaplayer.enabled
	
func is_inverted() -> bool:
	return _is_inverted
