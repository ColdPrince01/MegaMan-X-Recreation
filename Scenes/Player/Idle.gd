extends State

@export var idle_state : State
@export var run_state : State
@export var jump_state : State
@export var fall_state : State
@export var dash_state : State
@export var stagger_state : State

var string_name = "Idle"
var input_action = "null"

func enter() -> void:
	super()
	parent.can_dash = true
	parent.is_dashing = false
	parent.velocity.x = 0
	


func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		return idle_state
	if Input.is_action_just_pressed("ui_accept") and parent.is_on_floor() or parent.coyote_timer.time_left > 0.0:
		return jump_state #return jump state if jump key is pressed and is on ground
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return run_state #return move state is left or right key is pressed
	if Input.is_action_just_pressed("Dash") and parent.can_dash:
		return dash_state
	return null


func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta #at every physics step apply gravity
	parent.move_and_slide() #call move_and_slide after
	
	if parent.velocity.y != 0:
		if !parent.is_on_floor() and parent.velocity.y > 0.0:
			return fall_state
		
	
	if parent.is_damaged:
		return stagger_state
	
	return null

func process_frame(delta: float) -> State:
	
	if parent.attack_anim_timer.time_left > 0.0:
		if parent.charge_timer.time_left > 0.0:
			parent.character_animator.play("Charge_Shot")
		else:
			parent.character_animator.play("idle_shoot")
	if parent.attack_anim_timer.time_left <= 0.0:
		return idle_state
	


	return null
