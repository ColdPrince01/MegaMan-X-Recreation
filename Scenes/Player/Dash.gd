extends State

@export var idle_state : State
@export var run_state : State
@export var fall_state : State
@export var dash_state : State
@export var dash_jump_state : State

@export var dash_time := 0.5

var direction := 1
var dash_timer := 0.0
var timer_paused := false

func enter() -> void:
	super()
	parent.velocity.y = 0.0
	parent.is_dashing = true
	dash_timer = dash_time
	
	if parent.x_sprite.flip_h:
		direction = -1
	else:
		direction = 1
		

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("Dash"):
		if get_movement_input() != 0.0:
			return run_state
		return idle_state
		
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_floor():
		
		return dash_jump_state
	return null


func process_physics(delta: float) -> State:
	dash_timer -= delta
	if dash_timer <= 0.0:
		if get_movement_input() !=0:
			return run_state
		return idle_state
	

	parent.velocity.x = movement_data.dash_speed * direction
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	
	if parent.is_on_wall():
		parent.velocity.x = 0.0
	
	return null

func exit() -> void:
	parent.is_dashing = false
