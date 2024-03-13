extends State


@export var fall_state : State
@export var idle_state : State
@export var run_state : State
@export var dash_fall_state : State

@export var dash_time := 0.5

var dash_timer := 0.0
var string_name = "Dash_Jump"

func enter():
	super()
	Sounds.play(Sounds.jump)
	parent.velocity.y = -movement_data.jump_velocity #set parent's velocity equal to jump force

func process_input(event: InputEvent) -> State:
	if not parent.is_on_floor():
		if Input.is_action_just_released("ui_accept") and parent.velocity.y < 0.0: #for when the jump button is released
			parent.velocity.y = -movement_data.jump_velocity / 10 #lowers jump to 1/10th of its typical trajectory
	
	return null 

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	
	
	if parent.velocity.y > 0.0:
		return dash_fall_state
	
	var input_direction = get_movement_input()
	
	if input_direction !=0:
		parent.x_sprite.flip_h = input_direction < 0 #whether or not the player sprite flips is determined by the direction of movement
		
	
	parent.velocity.x = input_direction * movement_data.dash_speed
	parent.move_and_slide() #call move and slide after movement calculations
	

	
	if parent.is_on_floor(): #if the player is on the floor
		if input_direction != 0: #and they are moving
			return run_state #set state = to move state
		return idle_state #if on the floor and not moving, set state = idle_state
	
	return null #if nothing changes return null 
