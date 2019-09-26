extends Label

var count = 0

func _ready():
	utils.connect("camera_elevated", self, "on_camera_elevation")
	utils.connect("game_reset", self, "on_game_reset")
	
func on_camera_elevation(amount):
	update_score(amount / 2)

func update_score(amount):
	count += amount
	text = "Score: %d" % count

func on_game_reset():
	count = 0
	text = "Score: %d" % count
	