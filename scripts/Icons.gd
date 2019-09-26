extends Node2D

func _ready():
	utils.connect("power_grabbed", self, "on_power_grabbed")
	utils.connect("power_expired", self, "on_power_expired")
	utils.connect("game_reset", self, "on_game_reset")

func on_power_grabbed(pwr, time):
	match pwr:
		utils.powers.superjump:
			$PWSJIcon.visible = true
		utils.powers.extralife:
			$PWELIcon.visible = true

func on_power_expired(pwr):
	match pwr:
		utils.powers.superjump:
			$PWSJIcon.visible = false
		utils.powers.extralife:
			$PWELIcon.visible = false

func on_game_reset():
	for child in get_children():
		child.visible = false