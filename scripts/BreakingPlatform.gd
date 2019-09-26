extends "Platform.gd"

onready var brk_texture = preload("res://assets/BrokenBreakingPlatform.png")
onready var brk_piece = preload("res://scenes/BrokenWoodPiece.tscn")

func _ready():
	is_jumpable = true

func player_did_jump():
	destroy_itself()

func player_standing():
	destroy_itself()

func destroy_itself():
	$Sprite.texture = brk_texture
	$Particles2D.emitting = true
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$AudioStreamPlayer2D.play()
	var i1 = brk_piece.instance()
	var i2 = brk_piece.instance()
	i1.position.x = -25
	i1.scale.x *= -1
	add_child(i1)
	add_child(i2)
	