extends KinematicBody2D

export (bool) var is_player = true
onready var vis_notifier = $VisibilityNotifier2D
onready var RAY_NODE = $RayCast2D

const ACCELERATION = 10
const DECELERATION = 5
const MAX_HORIZONTAL_SPEED = 200
const JUMP_FORCE = 400
const GRAVITY = 10
const FLOOR_NORMAL = Vector2(0, -1)
const UP_RAY_VECTORS = [Vector2(0, -50), Vector2(-5, -48), Vector2(5, -48)]
const DOWN_RAY_VECTORS = [Vector2(0, 15), Vector2(5, 15), Vector2(-5, 15)]
const LATERAL_RAY_VECTORS = [Vector2(15, 0), Vector2(-15, 0)]

var direction = 0
var input_direction = 0
var is_ready = 0
var h_mov_timer = 0
var velocity = Vector2()
var accumulated_speed = 0

var started = false

#func _ready():
#	utils.connect("player_in_platform", self, "slow_speed")

func _physics_process(delta):
	if not vis_notifier.is_on_screen():
		get_tree().reload_current_scene()
	elif started:
		process_movement()
	elif Input.is_action_just_pressed("jump"):
		started = true

func process_movement():
	if input_direction:
        direction = input_direction
	
	if Input.is_action_just_pressed("jump"):
		jump_loop()
	elif Input.is_action_pressed("ui_right") and h_mov_timer == 0:
		input_direction = 1
		velocity.x = min(velocity.x + ACCELERATION, MAX_HORIZONTAL_SPEED)
	elif Input.is_action_pressed("ui_left") and h_mov_timer == 0:
		input_direction = -1 
		velocity.x = max(velocity.x - ACCELERATION, -MAX_HORIZONTAL_SPEED)
	else:
		input_direction = 0
		velocity.x += -direction * min(DECELERATION, abs(velocity.x))
	
	if input_direction == - direction:
		velocity.x /= 3
	if h_mov_timer > 0:
		h_mov_timer -= 1
	autojump()
	
	velocity.y += GRAVITY
	
	var temp_vel = velocity
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	for i in get_slide_count():
		var coll = get_slide_collision(i).normal
		if temp_vel.y < -JUMP_FORCE && coll == FLOOR_NORMAL:
			print(coll)

func autojump():
	if is_ready == 20:
		velocity.y -= (JUMP_FORCE + accumulated_speed)
		is_ready = 0
		accumulated_speed = 0
	
	if is_ready < 20 && is_on_floor():
		is_ready += 1
		velocity.x = 0

func jump_loop():
	if is_on_floor() and is_ready > 10:
		accumulated_speed = JUMP_FORCE
	elif determine_jump_element(UP_RAY_VECTORS):
		velocity.y -= JUMP_FORCE
	elif determine_jump_element(DOWN_RAY_VECTORS):
		velocity.y -= JUMP_FORCE
	elif determine_jump_element(LATERAL_RAY_VECTORS):
		var col_normal = RAY_NODE.get_collision_normal()
		velocity = Vector2(200 * col_normal.x, -JUMP_FORCE)
		direction = col_normal.x
		h_mov_timer = 20



func determine_jump_element(vector_list) -> bool:
	var result = null
	var index = 0
	while vector_list.size() != index and result == null:
		var vector = vector_list[index]
		result = raycast_query(vector)
		index += 1
	return result != null and result.is_jumpable

func raycast_query(vector):
	RAY_NODE.cast_to = vector
	RAY_NODE.force_raycast_update()
	return RAY_NODE.get_collider()
	

func slow_speed():
	print("I'm on a hard platform")



















