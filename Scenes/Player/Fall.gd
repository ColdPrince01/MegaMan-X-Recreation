extends State

@export var idle_state : State
@export var run_state : State
@export var jump_state : State
@export var wall_slide_state : State
@export var wall_jump_state : State
@export var dash_wall_state : State
@export var stagger_state : State

@export var coyote_duration = 0.2

var string_name = "Fall"
var current_animation_pos: float
var input_action = "null"

func enter() -> void:
	super()
	parent.can_dash = false
	parent.velocity.x = parent.state_velocity.x


func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	
	var input_direction = get_movement_input()
	var wall_normal = parent.get_wall_normal()
	
	if input_direction != 0:
		parent.x_sprite.flip_h = input_direction < 0
	
	if parent.is_dashing:
		parent.velocity.x = input_direction * movement_data.dash_speed
	else:
		parent.velocity.x = input_direction * movement_data.move_speed
	
	
	parent.move_and_slide()
	
	if parent.is_damaged:
		return stagger_state
	
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

func process_frame(delta: float) -> State:
	if parent.attack_anim_timer.time_left > 0.0:
		current_animation_pos = parent.character_animator.current_animation_position
		parent.character_animator.play("jump_fall_shoot")
		parent.character_animator.seek(current_animation_pos, true)
		
	
	if parent.attack_anim_timer.time_left <= 0.0:
		current_animation_pos = parent.character_animator.current_animation_position
		parent.character_animator.play("jump_fall")
		parent.character_animator.seek(current_animation_pos, true)
	
	return null



func exit() -> void:
	parent.is_dashing = false
	parent.can_dash = true
	if parent.is_on_floor():
		Utils.instantiate_scene_on_world(parent.JumpEffect, parent.global_position)
		Sounds.play(Sounds.land)
	
