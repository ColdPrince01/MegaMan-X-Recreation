extends State



@export var fall_state : State
@export var run_state : State
@export var idle_state : State
@export var wall_jump_state : State
@export var dash_wall_state : State
@export var wall_slide_state : State

var wall_direction := 1
var string_name = "Wall_Slide"
var current_animation_pos: float
var dust_particles = 0.0

func enter() -> void:
	super()
	parent.velocity.x = 0.0
	parent.velocity.y = 0.0
	if parent.x_sprite.flip_h: #if the player's sprite is facing left
		wall_direction = 1 #the wall is facing the right
	else: #otherwise if the player sprite is facing right
		wall_direction = -1 #the wall is facing the left


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



