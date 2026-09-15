class_name Level
extends Node

@export var MAX_INVERTS: int = 5
var is_inverted: bool = false

@export var inverted_domain: InvertedGroup
@export var noninverted_domain: NonInvertedGroup
@export var inverted_tilemaplayer: TileMapLayer
@export var noninverted_tilemaplayer: TileMapLayer

@onready var player = $Player

func _ready() -> void:
	inverted_domain.visible = false
	inverted_tilemaplayer.enabled = false

func _process(delta: float) -> void:
	var inverts_left = $Player.inverts_amount
	$IngameUI/InvertsLeftLabel.text = "Inverts left: " + str(inverts_left)

func invert_level() -> void:
	is_inverted = !is_inverted
	inverted_domain.visible = !inverted_domain.visible
	noninverted_domain.visible = !noninverted_domain.visible
	inverted_tilemaplayer.enabled = !inverted_tilemaplayer.enabled
	noninverted_tilemaplayer.enabled = !noninverted_tilemaplayer.enabled
