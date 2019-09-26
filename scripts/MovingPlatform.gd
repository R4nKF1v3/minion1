extends KinematicBody2D

export (bool) var is_jumpable = true
const MOVEMENT_SPEED = 10
var direction
var velocity = Vector2.ZERO

func _ready():
	$Area2D.connect("body_entered", self, "on_element_entered")
	$Area2D.connect("area_entered", self, "on_element_entered")
	$Sprite/AnimationPlayer.play("default")
	var rand = randi() % 2
	direction = 1 if rand == 1 else -1

func _physics_process(delta):
	position.x += direction * MOVEMENT_SPEED * delta

func on_element_entered(e):
	direction *= -1

func player_did_jump():
	pass

func player_standing():
	pass

func generate_powerup(pwr_type):
	var pwr = pwr_type.instance()
	pwr.position = Vector2(0, -10)
	add_child(pwr)