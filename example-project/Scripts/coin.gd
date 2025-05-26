extends Area2D

# Onready

@onready var animation_player := $AnimationPlayer
@onready var gui := %GUI
@onready var collectsfx := $Collectcoin

# Variables

var collected := false

# Signals

func _on_body_entered(body: Node2D) -> void:
	if !collected:
		animation_player.play("collect")
		gui.coins += 1
		collectsfx.play()
		collected = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free() 
