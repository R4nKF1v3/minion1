extends Node

signal camera_elevated(amount)

const LIMITS = 10
var AREA = ProjectSettings.get_setting("display/window/size/width") - (LIMITS * 2)
var PLATFORM_AREA = AREA / 5
var platform_types = []

func _ready():
	platform_types.push_front(preload("res://scenes/StaticPlatform.tscn"))
	platform_types.push_front(preload("res://scenes/BreakingPlatform.tscn"))
	pass

func determine_platform_type(difficulty_level):
	var random_number = int(round(rand_range(0, platform_types.size() - 1)))
	return platform_types[random_number]

func determine_platform_position(height):
	var chosen_position = rand_range(0,4)
	var ret = Vector2(LIMITS + (chosen_position * PLATFORM_AREA), 0)
	return ret