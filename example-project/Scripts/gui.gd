extends CanvasLayer

class_name GUI

# Onready

@onready var animation_player := $AnimationPlayer
@onready var coin_counter := $"Coin Counter"
@onready var color_overlay := $ColorRect

# Variables

var coins := 0

# Ready

func _ready() -> void:
	color_overlay.visible = true
	visible = true
	animation_player.play("fade_in")

# Process

func _process(delta: float) -> void:
	coin_counter.text = str(coins)
