extends State

@export var idle_state : State
@export var run_state : State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	
	var input_direction = get_movement_input()
	
	if input_direction != 0:
		parent.x_sprite.flip_h = input_direction < 0
	parent.velocity.x = input_direction * movement_data.move_speed
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if input_direction != 0:
			return run_state
		return idle_state
	return null
