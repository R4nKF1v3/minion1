extends Node2D

const ELEVATION_FACTOR = 50
const DIFFICULTY_FACTOR = 2300

onready var PlatformHolder = preload("res://scenes/PlatformHolder.tscn")
onready var parent = get_parent()
var previous_elevation = 50
var difficulty_level = 0
var previous_difficulty = 0

func _ready():
	update_position()
	on_camera_elevation(400)
	utils.connect("camera_elevated", self, "on_camera_elevation")

func on_camera_elevation(amount):
	previous_difficulty = difficulty_level
	var levels_to_rise = determine_levels(amount)
	previous_elevation += amount
	difficulty_level = (previous_elevation / DIFFICULTY_FACTOR)
	if previous_difficulty != difficulty_level:
		generate_level_platform()
		generate_platforms(levels_to_rise - 1)
	else:
		generate_platforms(levels_to_rise) 

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

func generate_level_platform():
	update_position()
	var i = PlatformHolder.instance()
	i.generate_level_platform(difficulty_level)
	i.position = position
	parent.call_deferred("add_child", i)















