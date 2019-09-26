extends Node2D

func _ready():
	position.x = utils.LIMITS

func generate_platforms(difficulty_level):
	randomize()
	var amount_of_platforms = utils.determine_platform_amount()
	for i in amount_of_platforms:
		generate_new_platform(difficulty_level)

func generate_new_platform(difficulty_level):
	var pl = utils.determine_platform_type(difficulty_level).instance()
	var children = get_children()
	var child_position = utils.determine_platform_position(position.y)
	while position_overlaps(child_position, children):
		child_position = utils.determine_platform_position(position.y)
	pl.position = child_position
	var powerup = utils.determine_powerup(difficulty_level)
	if powerup:
		pl.generate_powerup(powerup)
	self.add_child(pl)

func position_overlaps(child_position, children) -> bool:
	for child in children:
		if child.position.distance_to(child_position) < utils.PLATFORM_AREA:
			return true
	return false

func _on_viewport_exited(viewport):
	for child in self.get_children():
		child.queue_free()
	self.queue_free()

func generate_level_platform(difficulty_level):
	var pl = utils.get_level_platform_type(difficulty_level).instance()
	pl.position = Vector2(utils.get_x_center(), 0)
	add_child(pl)

