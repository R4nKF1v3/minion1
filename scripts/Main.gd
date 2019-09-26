extends Node2D

onready var scene_template = preload("res://scenes/Level.tscn")

func _ready():
	utils.connect("game_reset", self, "on_game_reset")

func on_game_reset():
	var new_scene = scene_template.instance()
	var old_scene = get_child(1)
	remove_child(old_scene)
	add_child(new_scene)
	old_scene.queue_free()
	utils.emit_signal("game_started")
	
