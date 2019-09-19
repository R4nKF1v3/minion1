extends Label

var count = 0

func _ready():
	utils.connect("camera_elevated", self, "on_camera_elevation")
	
func on_camera_elevation(amount):
	update_score(amount / 2)

func update_score(amount):
	count += amount
	text = "Score: %d" % count