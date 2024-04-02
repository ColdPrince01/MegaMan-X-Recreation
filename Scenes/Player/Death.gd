extends State

var string_name = "Death"
var input_action = "Null"

var death_timer := 0.0
var death_time := 0.12

func enter()-> void:
	super()
	Sounds.play(Sounds.death)
	parent.add_screenshake(2, 0.3)
	death_timer = death_time
	parent.velocity.x = 0.0
	parent.velocity.y = 0.0
	parent.is_dead = true #player is dead
	parent.has_control = false
	parent.hurt_box_component.is_invincible = true
	parent.effects_spawner.spawn_death_particles(parent.global_position + Vector2(0,-8))
	print("effects spawned")


func process_physics(delta : float) -> State:
	parent.velocity.x = 0.0
	parent.velocity.y = 0.0
	death_timer -= delta
	
	
	return null
	


func process_input(event : InputEvent) -> State:
	return null
