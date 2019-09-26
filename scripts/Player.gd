extends KinematicBody2D

export var ACCELERATION = 200
export var MAX_V_SPEED = 1200
export var JUMP_FORCE = 400
export var GRAVITY = 10
export var RAY_VECTORS = [Vector2(0, -25), Vector2(-5, -25), Vector2(5, -25)]

onready var vis_notifier = $VisibilityNotifier2D
onready var RAY_NODE = $RayCast2D
onready var COLL_BOX = $CollisionShape2D
onready var anim_player = $Body/Character/AnimationPlayer
onready var timer = $Timer

const FLOOR_NORMAL = Vector2(0, -1)

var is_ready = 0
var velocity = Vector2()
var accumulated_speed = 0
var active_powers = {}
var extra_life = false
var ledge_collider = null

var started = false

func _ready():
	utils.connect("game_started", self, "on_game_start")
	timer.start()

func on_game_start():
	started = true

### Input loop, determines the different input conditions and responses, 
### and the default response if there wasn't any valid input
func _handle_move_input():
	var move_direction = - int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	velocity.x = lerp(velocity.x, ACCELERATION * move_direction, 0.2)
	if move_direction != 0:
		$Body.scale.x = move_direction
	
func _apply_gravity():
	### Gravity... cuz gravity
	velocity.y += GRAVITY
	
func _apply_movement():
	velocity.y = max(-MAX_V_SPEED ,velocity.y)
	
	### Collision layer change to ascend and descend
	_collision_change()
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		collision.collider.player_standing()
	

func _collision_change():
	if is_ascending():
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, true)
	else:
		set_collision_layer_bit(0, true)
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(1, false)

func is_ascending() -> bool:
	return velocity.y < 0


func determine_jump_element() -> bool:
	var result = null
	var index = 0
	while RAY_VECTORS.size() != index and result == null:
		var vector = RAY_VECTORS[index]
		result = raycast_query(vector)
		index += 1
	return result != null and result.get_parent().is_jumpable

func raycast_query(vector):
	RAY_NODE.cast_to = vector
	RAY_NODE.force_raycast_update()
	return RAY_NODE.get_collider()


## Standard jump function
func jump(collision_element, jump_speed):
	velocity.y -= jump_speed
	collision_element.player_did_jump()
	#utils.emit_signal("player_jumped")


## Powerups
func _process_powerups():
	for key in active_powers:
		if active_powers[key] == 0:
			eliminate_power(key)
			active_powers[key] = - 1
		elif active_powers[key] > 0:
			active_powers[key] -= 1

func get_powerup(pwr, time):
	set_power(pwr, time)
	match pwr:
		utils.powers.superjump:
			JUMP_FORCE = 600
		utils.powers.extralife:
			extra_life = true
	utils.emit_signal("power_grabbed", pwr, time)

func set_power(pwr, time):
	active_powers[pwr] = time

func eliminate_power(pwr):
	match pwr:
		utils.powers.superjump:
			JUMP_FORCE = 400
		utils.powers.extralife:
			extra_life = false
	utils.emit_signal("power_expired", pwr)










