extends Trap

@export var trigger: TriggerButton

@onready var hitbox = $HitboxComponent

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3

func _ready() -> void:
	if trigger:
		visible = false
		trigger.button_triggered.connect(on_trap_triggered)
	else:
		setup_collision()
	
func setup_collision():
	var parent_group = $".."
	if parent_group is InvertedGroup:
		hitbox.set_collision_layer_value(NORMAL_COLLISION, false)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, true)
	else:
		hitbox.set_collision_layer_value(NORMAL_COLLISION, true)
		hitbox.set_collision_layer_value(INVERTED_COLLISION, false)


func on_trap_triggered():
	visible = true
	setup_collision()
