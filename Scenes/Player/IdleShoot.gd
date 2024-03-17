extends State


@export var shooting_state : State
@export var charging_state : State

var string_name = "Idle"


func enter() -> void:
	pass
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Shoot") and parent.fire_rate.time_left == 0.0:
		parent.fire_rate.start()
		parent.attack_anim_timer.start()
		return shooting_state
	
	if Input.is_action_pressed("Shoot") and not parent.is_charging:
		return charging_state
	return null


