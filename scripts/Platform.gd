extends StaticBody2D

export (bool) var is_jumpable

func player_did_jump():
	pass

func player_standing():
	pass

func generate_powerup(pwr_type):
	var pwr = pwr_type.instance()
	pwr.position = Vector2(0, -10)
	add_child(pwr)