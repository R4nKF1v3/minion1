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
	match started:
		true:
			process_movement()
		false:
			if Input.is_action_just_pressed("jump"):
				started = true

func process_movement():
	### User input check, preserves old direction if the user input was 0 in the previous frame
	if input_direction:
        direction = input_direction
	
	### Input loop
	input_loop()
	
	### Idle loop (Always executes)
	idle_loop()
	
	### Gravity... cuz gravity
	velocity.y += GRAVITY
	
	var temp_vel = velocity
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	for i in get_slide_count():
		var coll = get_slide_collision(i).normal
		if temp_vel.y < -JUMP_FORCE && coll == FLOOR_NORMAL:
			print("Am i hitting a ceiling?")
			print(is_on_ceiling())
			print("Am i hitting a floor?")
			print(is_on_floor())
			print("My hitting speed is:")
			print(temp_vel)
			print("My leftover speed is:")
			print(velocity)
			print(coll)

### Input loop, determines the different input conditions and responses, 
### and the default response if there wasn't any valid input
func input_loop():
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

### Conditions for the jump input
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

### Idle loop with conditions that are always automatically checked
func idle_loop():
	if input_direction == - direction:
		velocity.x /= 3
	if h_mov_timer > 0:
		h_mov_timer -= 1
	autojump()

### Helper function that checks for the autojump cycle
func autojump():
	if is_ready == 20:
		velocity.y -= (JUMP_FORCE * 4 )#+ accumulated_speed)
		is_ready = 0
		accumulated_speed = 0
		print("Autojump executing")
	
	if is_ready < 20 && is_on_floor() && velocity.y >= 0:
		print("Autojump charging")
		print("Because:")
		print("Is_ready: %d" %is_ready)
		print("Is_on_floor:" + str(is_on_floor()))
		print("velocity.y: %d" %velocity.y)
		is_ready += 1
		velocity.x = 0

### Raycast function that determines if there was any collision for the raycast projection
### returning bool and preserving the raycast state for future use
func determine_jump_element(vector_list) -> bool:
	var result = null
	var index = 0
	while vector_list.size() != index and result == null:
		var vector = vector_list[index]
		result = raycast_query(vector)
		index += 1
	return result != null and result.is_jumpable

### Helper function that checks collision with the raycast for a given objective vector
func raycast_query(vector):
	RAY_NODE.cast_to = vector
	RAY_NODE.force_raycast_update()
	return RAY_NODE.get_collider()
	




















