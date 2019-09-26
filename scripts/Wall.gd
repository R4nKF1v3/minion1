extends "Platform.gd"

func _ready():
	is_jumpable = false
	utils.connect("camera_elevated", self, "on_camera_elevation")

func on_camera_elevation(amount):
	position.y -= amount