extends Camera2D

onready var screen_size = get_viewport_rect().size

onready var player
var smooth_zoom = 1
var target_zoom = 1
const ZOOM_SPEED = 0.5

func _ready():
	position = screen_size / 2

func _process(delta):
	if (position.y > player.position.y):
		var difference = int(round(position.y - player.position.y))
		utils.emit_signal("camera_elevated", difference)
		position.y = player.position.y
		target_zoom = 1.15
	else:
		target_zoom = 1
	
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	if smooth_zoom != target_zoom:
		zoom = Vector2(smooth_zoom, smooth_zoom)