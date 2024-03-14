extends State

@export var idle_state : State
@export var shooting_state: State

var string_name = "Shooting"

var shockwave_offset_X = 2

func enter() -> void:
	parent.x_buster.fire_lemon()
	if parent.is_wall_sliding and parent.x_sprite.flip_h: #If the player is wall sliding and facing right
		var shockwave = Utils.instantiate_scene_on_world(parent.LemonShockwave, parent.x_buster.buster_pos.global_position + Vector2(shockwave_offset_X,0))
	else: #Otherwise if player is wall sliding and facing left
		if parent.is_wall_sliding and !parent.x_sprite.flip_h:
			var shockwave = Utils.instantiate_scene_on_world_flipped(parent.LemonShockwave, parent.x_buster.buster_pos_2.global_position - Vector2(shockwave_offset_X,0))
	if parent.x_sprite.flip_h:
		if not parent.is_dashing:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world_flipped(parent.LemonShockwave, parent.x_buster.buster_pos_2.global_position - Vector2(shockwave_offset_X,0))
	else:
		if not parent.is_dashing:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world(parent.LemonShockwave, parent.x_buster.buster_pos.global_position + Vector2(shockwave_offset_X, 0))


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Shoot") and parent.fire_rate.time_left == 0.0:
		parent.fire_rate.start()
		
		return shooting_state
	return null

func process_physics(delta:float) -> State:
	if parent.fire_rate.time_left == 0.0:
		return idle_state
		
	
	return null


