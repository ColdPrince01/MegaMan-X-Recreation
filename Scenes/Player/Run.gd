extends State


@export var idle_state : State
@export var jump_state : State
@export var fall_state : State
@export var dash_state : State

var string_name = "Run"

func enter() -> void:
	super()
	state_velocity.x = parent.velocity.x

func process_input(event : InputEvent) -> State:
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		return idle_state
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_floor(): #if jump button pressed and parent is on floor
		return jump_state
	if Input.is_action_just_pressed("Dash") and parent.can_dash:
		parent.character_animator.play("dash_enter")
		return dash_state
	return null


func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	
	
	var input_direction = get_movement_input()
	
	if input_direction == 0: #if the player stops moving
		return idle_state #return idle state
	
	parent.x_sprite.flip_h = input_direction < 0 #if movement is negative, flip sprite
	parent.velocity.x = input_direction  * movement_data.move_speed
	parent.move_and_slide() #call move and slide after calculating velocity 
	
	if !parent.is_on_floor(): #if player is in the air 
		return fall_state
	return null #return nothing, if nothing is happening 


func exit():
	state_velocity.x = movement_data.move_speed
