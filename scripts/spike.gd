extends Trap

@export var trigger: TriggerButton


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var hitbox: Hitbox

var is_triggered = false;

const NORMAL_COLLISION = 2
const INVERTED_COLLISION = 3

const SAND_INVERT_SPRITES = [0,1]
const SAND_NORMAL_SPRITES = [2,3]
const CAVE_INVERT_SPRITES = [4,5]
const CAVE_NORMAL_SPRITES = [6,7]


func _ready() -> void:
	if get_child(-1) is Hitbox:
		hitbox = get_child(-1)
	
	if trigger:
		visible = false
		trigger.button_triggered.connect(on_trap_triggered)
	else:
		setup()
	
func setup():
	var parent_group = $".."
	if parent_group is InvertedGroup:
		if hitbox:
			hitbox.set_collision_layer_value(NORMAL_COLLISION, false)
			hitbox.set_collision_layer_value(INVERTED_COLLISION, true)
		if parent_group and parent_group.is_in_group("Cave"): animated_sprite_2d.frame = CAVE_INVERT_SPRITES.pick_random()
		else: animated_sprite_2d.frame = SAND_INVERT_SPRITES.pick_random()
		
	else:
		if hitbox:
			hitbox.set_collision_layer_value(NORMAL_COLLISION, true)
			hitbox.set_collision_layer_value(INVERTED_COLLISION, false)
		if parent_group and parent_group.is_in_group("Cave"): animated_sprite_2d.frame = CAVE_NORMAL_SPRITES.pick_random()
		else: animated_sprite_2d.frame = SAND_NORMAL_SPRITES.pick_random()


func on_trap_triggered():
	if not is_triggered: 
		visible = true
		setup()
		is_triggered = true
