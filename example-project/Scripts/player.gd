extends CharacterBody2D
class_name Player

# Export Variables

@export var walk_speed := 2000.0
@export var friction := 0.94
@export var jump_length := 0.1
@export var jump_per_length := 1500.0
@export var jump_height := 180.0
@export var gravity := 900.0

# Onready Variables

@onready var jumpsfx := $SFX/Jump
@onready var floorsfx := $SFX/Floor
@onready var sprite := $AnimatedSprite2D

# Variables

var remove_gravity := false
var can_jump := false
var x_input := 0
var jump_left := 0.0
var just_on_floor := false

var squish_physics := Vector2(1,1)
var squish_velocity := Vector2(0,0)

# Functions
func movement(delta: float):
	velocity.x += x_input * walk_speed * delta # X Movement
	velocity.x *= pow(friction / 100000, delta)
	sprite.rotation = lerp_angle(sprite.rotation,deg_to_rad(x_input*4),0.03)
	if !remove_gravity:
		velocity.y += gravity * delta
	
	if jump_left > 0.0 && Input.is_action_pressed("Jump") && !is_on_ceiling() && !is_on_floor(): # Increases Velocity if jump key is held
		jump_left = max(jump_left - delta, 0.0)
		velocity.y -= jump_per_length * delta
		squish_velocity += Vector2(-0.05,0.05)
		jumpsfx.play()
	else:
		jump_left = 0 
	
	if can_jump && Input.is_action_just_pressed("Jump"): # Initializes Jump
		jump_left = jump_length
		velocity.y -= jump_height
	remove_gravity = false
	

func do_animations():
	var anim = "Idle"
	if x_input != 0:
		anim = "Walk"
	if !is_on_floor():
		anim = "Air"
	if sprite.animation != anim:
		sprite.play(anim)
	if is_on_floor() && !just_on_floor:
		if !just_on_floor:
			squish_velocity += Vector2(0.3,-0.3)
			floorsfx.play()
		just_on_floor = true
	if !is_on_floor():
		just_on_floor = false

func do_squish_physics(delta):
	squish_velocity.x = lerpf(squish_velocity.x, (1-squish_physics.x) * 0.2, 0.3)
	squish_velocity.y = lerpf(squish_velocity.y, (1-squish_physics.y) * 0.2, 0.3)
	squish_physics+=squish_velocity
	sprite.scale = squish_physics

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
	do_squish_physics(delta)
