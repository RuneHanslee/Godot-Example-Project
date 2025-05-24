extends CharacterBody2D
class_name Player

# Export Variables

@export var walk_speed := 2200.0
@export var friction := 0.94
@export var jump_length := 0.1
@export var jump_per_length := 1800.0
@export var jump_height := 200.0
@export var gravity := 900.0

# Onready Variables

@onready var sprite := $AnimatedSprite2D

# Variables

var can_jump := false
var x_input := 0
var jump_left := 0.0

# Functions
func movement(delta: float):
	velocity.x += x_input * walk_speed * delta # X Movement
	velocity.x *= pow(friction / 100000, delta)
	velocity.y += gravity * delta
	
	if jump_left > 0.0 && Input.is_action_pressed("Jump") && !is_on_ceiling() && !is_on_floor(): # Increases Velocity if jump key is held
		jump_left = max(jump_left - delta, 0.0)
		velocity.y -= jump_per_length * delta
	else:
		jump_left = 0
	
	if can_jump && Input.is_action_just_pressed("Jump"): # Initializes Jump
		jump_left = jump_length
		velocity.y -= jump_height

func do_animations():
	var anim = "Idle"
	if x_input != 0:
		anim = "Walk"
	if !is_on_floor():
		anim = "Air"
	if sprite.animation != anim:
		sprite.play(anim)


# Process

func _process(delta: float) -> void:
	x_input = Input.get_axis("Left","Right")
	if x_input == 1:
		sprite.flip_h = false
	elif x_input == -1:
		sprite.flip_h = true
	can_jump = is_on_floor()
	movement(delta)
	move_and_slide()
	do_animations()
