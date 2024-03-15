extends State

@export var fall_state: State


@export var air_time := 0.2
@export var wall_kickback = 75.0


var jump_timer := 0.0
var string_name = "Wall_Jump"
var current_animation_pos: float
var input_action = "Space"

func enter() -> void:
	super()
	Sounds.play(Sounds.jump)
	parent.velocity.y = -movement_data.jump_velocity #set parent's velocity equal to jump force
	parent.can_dash = false
	parent.wall_spark_effect()
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
		parent.velocity.x = wall_normal.x * movement_data.move_speed
	
	else:
		parent.velocity.x = movement_data.move_speed * input_direction
	
	
	
	parent.move_and_slide()
	
	
	if parent.velocity.y >= 0.0:
		return fall_state
	
	return null


func process_frame(delta: float) -> State:
	if parent.attack_anim_timer.time_left > 0.0:
		current_animation_pos = parent.character_animator.current_animation_position
		parent.character_animator.play("wall_jump_shoot")
		parent.character_animator.seek(current_animation_pos, true)
	
	if parent.attack_anim_timer.time_left <= 0.0:
		current_animation_pos = parent.character_animator.current_animation_position
		parent.character_animator.play("wall_jump")
		parent.character_animator.seek(current_animation_pos, true)
	
	
	return null
