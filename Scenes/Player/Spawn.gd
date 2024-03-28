extends State

@export var idle_state: State
@export var spawn_time := 1.6

var spawn_timer := 0.0
var string_name = "Spawn"
var input_action = "null"


func enter() -> void:
	parent.spawn_anim.play("Spawn")
	spawn_timer = spawn_time
	parent.on_spawn = true


func process_input(event: InputEvent) -> State:
	return null



func process_physics(delta: float) -> State:
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		return idle_state
	return null


func exit() -> void:
	parent.on_spawn = false
