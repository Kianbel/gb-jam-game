extends Control

@onready var start_button: Button = $StartButton
@onready var exit_button: Button = $ExitButton
@onready var title: Sprite2D = $Title
@onready var selector: Label = $Selector
@onready var start_position: Node2D = $StartPosition
@onready var end_position: Node2D = $EndPosition

var isStartButtonHovered = false
var isExitButtonHovered = false
var buttonScale = Vector2(1.2,1.2)
var lerpWeight = 10
var defaultButtonScale = Vector2(1,1)

var time = 0
var frequency = 5
var initial_y = 0
var amplitude = 2.5

var selected: Button

@onready var selection_sfx = load("res://sounds/jump.wav")

func _ready() -> void:
	selected = start_button

func _process(delta: float) -> void:
	handle_input()
	
	if isStartButtonHovered:
		start_button.scale = lerp(start_button.scale, buttonScale, lerpWeight * delta)
	else:
		start_button.scale = lerp(start_button.scale, defaultButtonScale, lerpWeight * delta)

	if isExitButtonHovered:
		exit_button.scale = lerp(exit_button.scale, buttonScale, lerpWeight * delta)
	else:
		exit_button.scale = lerp(exit_button.scale, defaultButtonScale, lerpWeight * delta)

func handle_input():
	var pitch = 2
	if Input.is_action_just_pressed("click"):
		SoundManager.play_sound(selection_sfx, pitch, pitch, -10)
		selected.pressed.emit()
	elif Input.is_action_just_pressed("up"):
		SoundManager.play_sound(selection_sfx, pitch, pitch, -10)
		selector.global_position = start_position.global_position - Vector2(0, selector.size.y / 2.0)
		selected = start_button
	elif Input.is_action_just_pressed("down"):
		SoundManager.play_sound(selection_sfx, pitch, pitch, -10)
		selector.global_position = end_position.global_position - Vector2(0, selector.size.y / 2.0)
		selected = exit_button

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_mouse_entered() -> void:
	isStartButtonHovered = true

func _on_start_button_mouse_exited() -> void:
	isStartButtonHovered = false

func _on_exit_button_mouse_entered() -> void:
	isExitButtonHovered = true

func _on_exit_button_mouse_exited() -> void:
	isExitButtonHovered = false
