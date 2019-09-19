extends Node2D

const ELEVATION_FACTOR = 20
const DIFFICULTY_FACTOR = 300

onready var PlatformHolder = preload("res://scenes/PlatformHolder.tscn")
onready var parent = get_parent()
var previous_elevation = 80
var difficulty_level = 1

func _ready():
	position.y -= 70
	on_camera_elevation(400)

func on_camera_elevation(amount):
	var levels_to_rise = determine_levels(amount)
	if levels_to_rise:
		generate_platforms(levels_to_rise) 
	previous_elevation += amount
	difficulty_level = (previous_elevation / DIFFICULTY_FACTOR)

func update_position():
	position.y -= ELEVATION_FACTOR

func determine_levels(amount):
	var current_elevation = previous_elevation + amount
	return (current_elevation / ELEVATION_FACTOR) - (previous_elevation / ELEVATION_FACTOR)

func generate_platforms(levels):
	for level in levels:
		update_position()
		var i = PlatformHolder.instance()
		i.generate_platforms(difficulty_level)
		i.position = position
		parent.call_deferred("add_child", i)
	
	















