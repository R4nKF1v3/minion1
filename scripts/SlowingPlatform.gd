extends "Platform.gd"

export var DAMAGE_THRESHOLD = -500
onready var brk_texture = preload("res://assets/BrokenSlowingPlatform.png")

func _ready():
	is_jumpable = false
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.velocity.y < DAMAGE_THRESHOLD:
		body.velocity.y *= 0.9
		destroy_itself()
	else:
		body.velocity.y *= 0.5

func destroy_itself():
	$Sprite.texture = brk_texture
	$Particles2D.emitting = true
	$AudioStreamPlayer2D.play()
	