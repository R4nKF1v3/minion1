extends Node2D

onready var screen_size = get_viewport_rect().size
onready var player = $Player
onready var walls = $walls
onready var PlatformPointer = $platforms/PlatformPointer
onready var background = $ParallaxBackground
onready var camera_position = screen_size / 2

func _ready():
	update_camera()

func _process(delta):
	update_camera()

func update_camera():
	if (camera_position.y > player.position.y):
		var difference = int(round(camera_position.y - player.position.y))
		utils.emit_signal("camera_elevated", difference)
		PlatformPointer.on_camera_elevation(difference)
		camera_position.y = player.position.y
	
	var movement = -camera_position + screen_size / 2
	get_viewport().canvas_transform[2] = movement
	background.scroll_offset = movement
	walls.position.y = -movement.y
