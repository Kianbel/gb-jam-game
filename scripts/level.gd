class_name Level
extends Node

@export var MAX_INVERTS: int = 5
var is_inverted: bool = false

@export var inverted_domain: InvertedGroup
@export var noninverted_domain: NonInvertedGroup
@export var inverted_tilemaplayer: TileMapLayer
@export var noninverted_tilemaplayer: TileMapLayer

@onready var player = $Player
@export var parallax: Parallax2D

@onready var ingame_ui: CanvasLayer = $IngameUI
@onready var ui_animated_sprite: AnimatedSprite2D = $IngameUI/AnimatedSprite2D


func _ready() -> void:
	inverted_domain.visible = false
	inverted_tilemaplayer.enabled = false
	if get_child(1).is_in_group("Cave"): player.is_cave = true

func _process(_delta: float) -> void:
	var mapped = remap(player.inverts_amount, MAX_INVERTS, 0, 0, MAX_INVERTS)
	if player.is_cave:
		if is_inverted: ui_animated_sprite.play("cave_invert")
		else: ui_animated_sprite.play("cave_normal")
	else:
		if is_inverted: ui_animated_sprite.play("sand_invert")
		else: ui_animated_sprite.play("sand_normal")

	if player.inverts_amount > 0:
		ui_animated_sprite.frame = clampi(int(round(mapped)), 0, MAX_INVERTS)
	else:
		ui_animated_sprite.frame = 4
			


func invert_level() -> void:
	is_inverted = !is_inverted
	inverted_domain.visible = !inverted_domain.visible
	noninverted_domain.visible = !noninverted_domain.visible
	inverted_tilemaplayer.enabled = !inverted_tilemaplayer.enabled
	noninverted_tilemaplayer.enabled = !noninverted_tilemaplayer.enabled
	
	# change bg
	const normal = 0
	const inverted = 1
	var bg: AnimatedSprite2D = parallax.get_node("AnimatedSprite2D")
	bg.frame = inverted if is_inverted else normal
	
