extends State

@export var idle_state : State
@export var shooting_state: State
@export var charging_state : State

var string_name = "Shooting"

var shockwave_offset_X = 2

func enter() -> void:
	if parent.charge_lvl == 0:
		parent.x_buster.fire_lemon()
		#Nested If Statements below are for the shockwave sprite
		if parent.is_wall_sliding and parent.x_sprite.flip_h: #If the player is wall sliding and facing right
			var shockwave = Utils.instantiate_scene_on_world(parent.LemonShockwave, parent.x_buster.buster_pos.global_position + Vector2(shockwave_offset_X,0))
		else: #Otherwise if player is wall sliding and facing left
			if parent.is_wall_sliding and !parent.x_sprite.flip_h:
				var shockwave = Utils.instantiate_scene_on_world_flipped(parent.LemonShockwave, parent.x_buster.buster_pos_2.global_position - Vector2(shockwave_offset_X,0))
		if parent.x_sprite.flip_h:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world_flipped(parent.LemonShockwave, parent.x_buster.buster_pos_2.global_position - Vector2(shockwave_offset_X,0))
		else:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world(parent.LemonShockwave, parent.x_buster.buster_pos.global_position + Vector2(shockwave_offset_X, 0))
	
	if parent.charge_lvl == 1:
		parent.charge_lvl = 0
		parent.x_buster.fire_charge_one()
		
		if parent.is_wall_sliding and parent.x_sprite.flip_h: #If the player is wall sliding and facing right
			var shockwave = Utils.instantiate_scene_on_world(parent.ChargeOneShockwave, parent.x_buster.buster_pos.global_position)
		else: #Otherwise if player is wall sliding and facing left
			if parent.is_wall_sliding and !parent.x_sprite.flip_h:
				var shockwave = Utils.instantiate_scene_on_world_flipped(parent.ChargeOneShockwave, parent.x_buster.buster_pos_2.global_position)
		if parent.x_sprite.flip_h:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world_flipped(parent.ChargeOneShockwave, parent.x_buster.buster_pos_2.global_position)
		else:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world(parent.ChargeOneShockwave, parent.x_buster.buster_pos.global_position)
	
		
	
	if parent.charge_lvl == 2:
		parent.charge_lvl = 0
		parent.x_buster.fire_charge_two()
		#Nested If Statements below are for the shockwave sprite
		if parent.is_wall_sliding and parent.x_sprite.flip_h: #If the player is wall sliding and facing right
			var shockwave = Utils.instantiate_scene_on_world(parent.ChargedShockwave, parent.x_buster.buster_pos.global_position)
		else: #Otherwise if player is wall sliding and facing left
			if parent.is_wall_sliding and !parent.x_sprite.flip_h:
				var shockwave = Utils.instantiate_scene_on_world_flipped(parent.ChargedShockwave, parent.x_buster.buster_pos_2.global_position)
		if parent.x_sprite.flip_h:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world_flipped(parent.ChargedShockwave, parent.x_buster.buster_pos_2.global_position)
		else:
			if parent.is_wall_sliding : return
			var shockwave = Utils.instantiate_scene_on_world(parent.ChargedShockwave, parent.x_buster.buster_pos.global_position)
	


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Shoot") and parent.fire_rate.time_left == 0.0:
		parent.fire_rate.start()
		
		return shooting_state
	if Input.is_action_pressed("Shoot") and not parent.is_charging:
		if parent.fire_rate.time_left <= 0.0:
			return charging_state
	return null

func process_physics(delta:float) -> State:
	if parent.fire_rate.time_left == 0.0:
		return idle_state
		
	
	return null


