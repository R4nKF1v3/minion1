extends "res://scripts/Platform.gd"

export var DAMAGE_THRESHOLD = -400

func _ready():
	is_jumpable = false
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.velocity.y < DAMAGE_THRESHOLD:
		print("Player slows down a little and i will break")
		body.velocity.y *= 0.9
	else:
		print("Player slows down")
		body.velocity.y *= 0.5
