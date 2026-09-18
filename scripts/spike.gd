extends Trap

@export var trigger: TriggerButton

@onready var hitbox = $HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_triggered = false;

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3

func _ready() -> void:
	if trigger:
		visible = false
		trigger.button_triggered.connect(on_trap_triggered)
	else:
		setup()
	
func setup():
	var parent_group = $".."
	if parent_group is InvertedGroup:
		hitbox.set_collision_layer_value(NORMAL_COLLISION, false)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, true)
		animated_sprite_2d.play("sand_inverted")
		animated_sprite_2d.stop()
		var frame_count: int = animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation)
		animated_sprite_2d.frame = randi() % frame_count
		
	else:
		hitbox.set_collision_layer_value(NORMAL_COLLISION, true)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, false)
		animated_sprite_2d.play("sand_normal")
		animated_sprite_2d.stop()
		var frame_count: int = animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation)
		animated_sprite_2d.frame = randi() % frame_count


func on_trap_triggered():
	if not is_triggered: 
		visible = true
		setup()
		is_triggered = true
