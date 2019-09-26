extends Node

# warning-ignore:unused_signal
signal game_started
signal game_over
signal game_reset
signal camera_elevated(amount)
signal player_jumped
signal power_grabbed(pwr, time)
signal power_expired(pwr)

const LIMITS = 10
var AREA = ProjectSettings.get_setting("display/window/size/width") - (LIMITS * 2)
var PLATFORM_AREA = AREA / 4
var platform_types = []
var level_platform_types = []

# warning-ignore:unused_class_variable
var powers = {'superjump': 1, 'extralife': 2 }
var power_types = []

func _ready():
	platform_types.push_back(preload("res://scenes/StaticPlatform.tscn"))
	platform_types.push_back(preload("res://scenes/SlowingPlatform.tscn"))
	platform_types.push_back(preload("res://scenes/BreakingPlatform.tscn"))
	platform_types.push_back(preload("res://scenes/MovingPlatform.tscn"))
	power_types.push_back(preload("res://scenes/PWSuperJump.tscn"))
	power_types.push_back(preload("res://scenes/PWExtraLife.tscn"))
	level_platform_types.push_back(preload("res://scenes/LevelPlatform.tscn"))

func determine_platform_amount():
	return int(round(rand_range(0, 2)))

# warning-ignore:unused_argument
func determine_platform_type(difficulty_level: float):
	var difficulty_variant = (difficulty_level / (difficulty_level + 5)) * 1.5
	var random_number = rand_range(0, platform_types.size() - 1)
	var index = int(round(min(random_number * difficulty_variant, platform_types.size() - 1)))
	return platform_types[index]

# warning-ignore:unused_argument
func determine_platform_position(height):
	var chosen_position = rand_range(0,3)
	var ret = Vector2(LIMITS + (chosen_position * PLATFORM_AREA), 0)
	return ret

func determine_powerup(difficulty_level):
	var random_number = int(round(rand_range(0, power_types.size() + 20)))
	if (power_types.size() - 1) >= random_number:
		return power_types[random_number]
	else:
		return null

func get_level_platform_type(difficulty_level):
	return level_platform_types[0]

func get_x_center():
	return AREA / 2




