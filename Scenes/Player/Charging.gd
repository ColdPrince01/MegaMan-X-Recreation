extends State

@export var idle_state : State
@export var shooting_state : State

const CHARGE_MEGABUSTER_START = 0.68
const FULLY_CHARGED_BUSTER_TIME = 1.6

var charge_timer := 0.0

var string_name = "Charging"


func enter() -> void:
	charge_timer = 0.0
	parent.is_charging = true
	parent.charge_aura_effect()
	parent.aura_timer.start()


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("Shoot") and parent.charge_lvl == 1:
		parent.is_charging = false
		parent.fire_rate.start()
		parent.attack_anim_timer.start()
		return shooting_state
	if Input.is_action_just_released("Shoot") and parent.charge_lvl == 2:
		parent.is_charging = false
		parent.fire_rate.start()
		parent.attack_anim_timer.start()
		return shooting_state
	return null


func process_frame(delta:float) -> State:
	charge_timer += delta
	
	if charge_timer > CHARGE_MEGABUSTER_START:
		parent.charge_lvl = 1
	if charge_timer > FULLY_CHARGED_BUSTER_TIME:
		parent.charge_lvl = 2

	
	return null
	

func exit() -> void:
	parent.aura_timer.stop()
