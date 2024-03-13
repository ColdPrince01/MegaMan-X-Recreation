extends State

@export var idle_state : State
@export var run_state : State
@export var jump_state : State
@export var wall_slide_state : State
@export var wall_jump_state : State
@export var dash_wall_state : State

@export var coyote_duration = 0.2

var string_name = "Fall"

func enter() -> void:
	super()
	parent.can_dash = false

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("Dash"):
		if Input.is_action_just_pressed("ui_accept"):
			if parent.is_on_wall_only():
				return dash_wall_state
	if Input.is_action_just_pressed("ui_accept"):
		if parent.is_on_wall_only():
			return wall_jump_state
	
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	
	var input_direction = get_movement_input()
	var wall_normal = parent.get_wall_normal()
	
	if input_direction != 0:
		parent.x_sprite.flip_h = input_direction < 0
	parent.velocity.x = input_direction * movement_data.move_speed
	
	
	parent.move_and_slide()
	
	if parent.is_on_wall_only():
		if input_direction == -1 and wall_normal.x == 1:
			return wall_slide_state
	if parent.is_on_wall_only():
		if input_direction == 1 and wall_normal.x == -1:
			return wall_slide_state
	
	if parent.is_on_floor():
		parent.has_jumped = false
		if input_direction != 0:
			return run_state
		return idle_state
	return null


func exit() -> void:
	parent.can_dash = true
	if parent.is_on_floor():
		Sounds.play(Sounds.land)
