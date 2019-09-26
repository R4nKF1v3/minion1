extends CanvasLayer

var game_state = "starting"

func _ready():
	utils.connect("game_over", self, "on_game_over")
	$Menu/Button.connect("pressed", self, "on_button_pressed")

func on_game_over():
	game_state = "ended"
	$Menu/Title.text = "You Are Dead"
	$Menu/Button.text = "Retry"
	$Menu.show()

func on_button_pressed():
	if game_state == "starting":
		utils.emit_signal("game_started")
		$Menu.hide()
	elif game_state == "ended":
		utils.emit_signal("game_reset")
		$Menu.hide()