extends "res://scripts/StateMachine.gd"

func _ready():
	_init_states()
	call_deferred("set_state", states.idle)

func _init_states():
	add_state("idle")
	add_state("starting_jump")
	add_state("jumping")
	add_state("falling")
	add_state("landing")
	add_state("grabbing_ledge")
	add_state("dead")

func _input(event):
	if event.is_action_pressed("jump"):
		if state == states.starting_jump:
			parent.accumulated_speed = parent.JUMP_FORCE
		elif parent.timer.is_stopped() && parent.determine_jump_element():
			parent.ledge_collider = parent.RAY_NODE.get_collider().get_parent()
			parent.accumulated_speed = parent.velocity.y
			parent.velocity.y = 0
			set_state(states.grabbing_ledge)

func _state_logic(delta):
	if !parent.vis_notifier.is_on_screen():
		if parent.extra_life:
			parent.velocity.y = -600
			parent.eliminate_power(utils.powers.extralife)
			_process_movement()
		elif parent.timer.is_stopped():
			set_state(states.dead)
			utils.emit_signal("game_over")
	elif state != states.dead:
		_process_movement()

func _process_movement():
	parent._process_powerups()
	if [states.landing, states.starting_jump, states.idle, states.grabbing_ledge].has(state):
		parent.velocity.x = 0
	else:
		parent._handle_move_input()
	if state != states.grabbing_ledge:
		parent._apply_gravity()
	parent._apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent.started:
				if parent.is_on_floor():
					return states.landing
				elif parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling
		states.starting_jump:
			if parent.velocity.y < 0:
				return states.jumping
			elif parent.velocity.y > 0:
				return states.falling
		states.jumping:
			if parent.velocity.y > 0:
				return states.falling
			elif parent.velocity.y == 0 && parent.is_on_floor():
				return states.landing
		states.falling:
			if parent.velocity.y < 0:
				return states.jumping
			elif parent.is_on_floor():
				return states.landing
		states.landing:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling
	
	return null


func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.starting_jump:
			parent.anim_player.play("starting_jump")
		states.jumping:
			parent.anim_player.play("jumping")
		states.falling:
			parent.anim_player.play("falling")
		states.landing:
			parent.anim_player.play("landing")
		states.grabbing_ledge:
			parent.anim_player.play("grabbing_ledge")

func _exit_state(old_state, new_state):
	pass

func execute_autojump():
	parent.jump(parent.get_slide_collision(0).collider, parent.JUMP_FORCE + parent.accumulated_speed)
	parent.accumulated_speed = 0

func execute_ledgejump():
	parent.jump(parent.ledge_collider, parent.JUMP_FORCE)
	parent.velocity.y = min(-parent.JUMP_FORCE + parent.accumulated_speed, -parent.JUMP_FORCE * 1.5)
	parent.accumulated_speed = 0
	parent.timer.start()
	set_state(states.jumping)

func enter_starting_jump():
	set_state(states.starting_jump)
