extends State



@export var fall_state : State
@export var run_state : State
@export var idle_state : State
@export var wall_jump_state : State
@export var dash_wall_state : State
@export var wall_slide_state : State

var string_name = "Wall_Slide"
var current_animation_pos: float
var input_action = "arrow"

func enter() -> void:
	super()
	parent.velocity.x = 0.0
	parent.velocity.y = 0.0
	parent.is_wall_sliding = true


func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("Dash") or Input.is_action_just_pressed("Dash"):
		if Input.is_action_just_pressed("ui_accept"):
			return dash_wall_state
	if Input.is_action_just_pressed("ui_accept"):
		return wall_jump_state
	
	return null


func process_physics(delta:float) -> State:
	
	var input_direction = get_movement_input()
	if input_direction != 0:
		parent.velocity.x = 0.0
		parent.velocity.y += movement_data.gravity * delta
		parent.velocity.y = clamp(parent.velocity.y, 0, movement_data.max_wall_speed)
		
		
	else:
		return fall_state
	

	
	parent.move_and_slide()
	
	
	
	if parent.is_on_floor():
		Sounds.play(Sounds.land)
		return idle_state
	
	return null


func process_frame(delta : float) -> State:

	
	if parent.attack_anim_timer.time_left > 0.0:
		parent.character_animator.play("wall_shoot")
	
	if parent.attack_anim_timer.time_left <= 0.0:
		parent.character_animator.play("wall_slide")
	
	
	return null

func exit() -> void:
	parent.is_wall_sliding = false

