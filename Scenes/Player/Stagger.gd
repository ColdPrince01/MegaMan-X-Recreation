extends State

const KNOCKBACK_VELOCITY := 45.0
const KNOCKBACK_JUMP := 170.0

@export var knockback_time := 0.4
@export var idle_state : State
@export var run_state : State 
@export var jump_state : State 
@export var fall_state : State 

var string_name = "Stagger"
var input_action = "Null"
var knockback_timer = 0.0

func enter() -> void:
	super()
	parent.is_damaged = true
	Sounds.play(Sounds.hurt)
	parent.velocity.y = -KNOCKBACK_JUMP
	knockback_timer = knockback_time
	

func process_physics(delta: float) -> State:
	parent.velocity.x = -parent.get_direction().x * KNOCKBACK_VELOCITY
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	parent.move_and_slide()
	
	var input_direction = get_movement_input()
	
	if !parent.is_damaged and parent.is_on_floor(): #if parent is not damaged any longer, and is on floor
		if input_direction !=0: #if they return input left or right 
			return run_state #send them to move state
		return idle_state #if not moving return idle 
		
	if !parent.is_damaged and !parent.is_on_floor(): #if parent is not damaged any longer, and is not on floor
		return fall_state
	
	
	if knockback_timer <= 0.0:
		if input_direction != 0:
			if parent.is_on_floor():
				return run_state
			return fall_state
		return idle_state
	
	return null 

func process_frame(delta:float) -> State:
	knockback_timer -= delta
	
	return null

func exit() -> void:
	parent.is_damaged = false
