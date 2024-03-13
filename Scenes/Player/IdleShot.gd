extends State

@export var idle_state : State
@export var shooting_state: State

var string_name = "Shooting"


func enter() -> void:
	parent.x_buster.fire_lemon()
	
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Shoot") and parent.fire_rate.time_left == 0.0:
		parent.fire_rate.start()
		
		return shooting_state
	return null

func process_physics(delta:float) -> State:
	if parent.fire_rate.time_left == 0.0:
		return idle_state
		
	
	return null


