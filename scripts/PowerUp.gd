extends Node2D

var pwr
var time

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	body.get_powerup(pwr, time)
	queue_free()
