extends NinePatchRect

# Export 
@export var speed := 900

# Onready
@onready var collision := $Area2D/CollisionShape2D
@onready var player := %Player
@onready var gravitysfx := $GravityInverter

# Variables
var frame := 0.0
var in_player := false

# Ready
func _ready() -> void:
	collision.scale = size - Vector2(32,32)
	collision.position = collision.scale / 2 + Vector2(16,16)

func _process(delta: float) -> void:
	if in_player:
		frame += delta * speed / 60
	else:
		frame += delta * speed / 200
	if frame > 8:
		frame = 0
	if frame < 0:
		frame = 8
	region_rect.position.x = floor(frame)*48
	if in_player:
		var rot := rotation - deg_to_rad(90)
		player.velocity += Vector2(cos(rot), sin(rot)) * speed * delta
		player.remove_gravity = true
	
# Signals

func _on_area_2d_body_entered(body: Node2D) -> void:
	in_player = true
	player.velocity /= 3
	gravitysfx.play()


func _on_area_2d_body_exited(body: Node2D) -> void:
	in_player = false
	player.remove_gravity = false
	#player.velocity *= 1.2
