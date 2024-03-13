extends State


@export var run_state : State
@export var idle_state : State
@export var fall_state : State

var string_name = "Jump"

func enter() -> void:
	super()
	parent.velocity.y = -movement_data.jump_velocity #set parent's velocity equal to jump force
	parent.can_dash = false
	Sounds.play(Sounds.jump)

func process_input(event: InputEvent) -> State:
	if not parent.is_on_floor():
		if Input.is_action_just_released("ui_accept") and parent.velocity.y < 0.0: #for when the jump button is released
			parent.velocity.y = -movement_data.jump_velocity / 10 #lowers jump to 1/10th of its typical trajectory
	
	
	return null 

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	
	
	if parent.velocity.y > 0.0:
		return fall_state
	
	var input_direction = get_movement_input()
	
	if input_direction !=0:
		parent.x_sprite.flip_h = input_direction < 0 #whether or not the player sprite flips is determined by the direction of movement
		
	
	parent.velocity.x = input_direction * movement_data.move_speed
	parent.move_and_slide() #call move and slide after movement calculations
	

	
	if parent.is_on_floor(): #if the player is on the floor
		if input_direction != 0: #and they are moving
			return run_state #set state = to move state
		return idle_state #if on the floor and not moving, set state = idle_state
	
	return null #if nothing changes return null 


func exit() -> void:
	parent.can_dash = true
