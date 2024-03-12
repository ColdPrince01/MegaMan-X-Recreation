extends State

@export var idle_state : State
@export var run_state : State
@export var jump_state : State

@export var coyote_duration = 0.2

func enter() -> void:
	super()
	parent.can_dash = false

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		if parent.is_on_floor() or parent.coyote_timer.time_left > 0.0 and parent.velocity.y > 0.0:
			parent.has_jumped = true
			return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	
	var input_direction = get_movement_input()
	
	if input_direction != 0:
		parent.x_sprite.flip_h = input_direction < 0
	parent.velocity.x = input_direction * movement_data.move_speed
	parent.move_and_slide()
	
	
	if parent.is_on_floor():
		parent.has_jumped = false
		if input_direction != 0:
			return run_state
		return idle_state
	return null


func exit() -> void:
	parent.can_dash = true
