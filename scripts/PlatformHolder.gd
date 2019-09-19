extends Node2D

func _ready():
	position.x = utils.LIMITS

func generate_platforms(difficulty_level):
	randomize()
	var amount_of_platforms = int(round(rand_range(0, 2)))
	for i in amount_of_platforms:
		generate_new_platform(difficulty_level)

func generate_new_platform(difficulty_level):
	var platform_type = utils.determine_platform_type(difficulty_level)
	var pl = platform_type.instance()
	var child_position = utils.determine_platform_position(position.y)
	pl.position = child_position
	self.add_child(pl)
	fix_children_overlap()

func fix_children_overlap():
	var children = get_children()
	children.pop_front()
	children.sort_custom(NodePositionXSorter, "sort")
	while children.size() > 1:
		var child = children.pop_front()
		var next_child = children[0]
		var difference = abs(child.position.x - next_child.position.x)
		if difference < utils.PLATFORM_AREA:
			next_child.position.x -= difference


func _on_viewport_exited(viewport):
	for child in self.get_children():
		child.queue_free()
	self.queue_free()


class NodePositionXSorter:
    static func sort(a, b):
        if a.position.x < b.position.x:
            return true
        return false
