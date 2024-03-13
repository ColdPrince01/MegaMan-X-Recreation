extends State


@export var dash_fall_state : State

@export var air_time := 0.2



var jump_timer := 0.0
var string_name = "Dash_Wall_Jump"

func enter() -> void:
	super()
	Sounds.play(Sounds.jump)
	parent.velocity.y = -movement_data.jump_velocity #set parent's velocity equal to jump force
	parent.can_dash = false
	
	jump_timer = air_time


func process_physics(delta: float) -> State:
	jump_timer -= delta
	var wall_normal = parent.get_wall_normal()
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.jump_velocity, movement_data.max_fall_speed)
	
	var input_direction = get_movement_input()
	
	
	if input_direction !=0:
		parent.x_sprite.flip_h = input_direction < 0 #whether or not the player sprite flips is determined by the direction of movement
		
	if jump_timer > 0.0:
		parent.velocity.x = 0.0
		parent.velocity.x = wall_normal.x * movement_data.dash_speed
	
	else:
		
		
		parent.velocity.x = movement_data.dash_speed * input_direction
		
	parent.move_and_slide()
	
	
	
	if parent.velocity.y >= 0.0:
		return dash_fall_state
	
	return null
