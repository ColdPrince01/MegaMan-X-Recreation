class_name Player
extends CharacterBody2D

const DustEffectScene = preload("res://Scenes/Player/dust_effect.tscn")
const DashDustStart = preload("res://Scenes/Player/dash_start.tscn")
const WallDustScene = preload("res://Scenes/Player/wall_dust.tscn")
const LemonShockwave = preload("res://Scenes/InheritanceScenes/lemon_shockwave.tscn")
const GhostingScene = preload("res://Scenes/Effects/ghosting.tscn")
const WallKickDust = preload("res://Scenes/Player/WallJumpSpark.tscn")
const ChargedShockwave = preload("res://OtherScenes/charged_shockwave.tscn")
const ChargeOneShockwave = preload("res://OtherScenes/charge_one_shockwave.tscn")
const ChargedParticles = preload("res://OtherScenes/charge_particles.tscn")
const DamageNumber = preload("res://Unrelated/damage_number.tscn")
const JumpEffect = preload("res://Scenes/Effects/jump_effect.tscn")

@export var movement_data : PlayerMovementData
@export var death_time := 0.33
@export var dev_menu := true
@export var spawn_time := 2.0
@export var death_state : State

@onready var x_sprite = $XSprite
@onready var character_animator = $CharacterAnimator
@onready var movement_component = $MovementComponent
@onready var state_machine = $StateMachine
@onready var coyote_timer = $CoyoteTimer
@onready var vertical_collision = $VerticalCollision
@onready var horizontal_collision = $HorizontalCollision
@onready var dust_point = $DustPoint
@onready var wall_dust = $WallDust
@onready var dust_point_2 = $DustPoint2
@onready var wall_dust_2 = $WallDust2
@onready var label = $Labels/Label
@onready var label_2 = $Labels/Label2
@onready var label_3 = $Labels/Label3
@onready var label_4 = $Labels/Label4
@onready var attack_machine = $AttackMachine
@onready var x_buster = $X_Buster
@onready var fire_rate = $Timers/FireRate
@onready var attack_anim_timer = $Timers/AttackAnimTimer
@onready var label_5 = $Labels/Label5
@onready var dust_timer = $Timers/DustTimer
@onready var dust_animation = $DustAnimation
@onready var label_6 = $Labels/Label6
@onready var ghost_timer = $Timers/GhostTimer
@onready var wall_kick = $WallKick
@onready var wall_kick_2 = $WallKick2
@onready var aura_timer = $Timers/AuraTimer
@onready var invincibility = $Timers/Invincibility
@onready var hurt_box_component = $HurtBoxComponent
@onready var damage_flash = $DamageFlash
@onready var charge_flash = $ChargeFlash
@onready var spawn_anim = $SpawnAnim
@onready var camera = $Camera
@onready var charge_timer = $Timers/ChargeTimer
@onready var effects_spawner = $EffectsSpawner
@onready var center = $Center
@onready var wall_cast = $WallCast


var state_velocity := Vector2.ZERO
var charge_lvl = 0
var has_control := true
var has_jumped = false
var is_dashing = false
var can_dash = !is_on_wall() and is_on_floor()
var can_wall_slide = is_on_wall() and !is_on_floor() and velocity.y >= 0.0
var dust_point_position 
var has_fired = false
var is_wall_sliding = false
var is_damaged = false
var is_charging = false
var y_offset = 8
var can_fire_charge = true 
var on_spawn = false
var room_pause = false
var released_charge = false
var no_shockwave = is_dashing and is_on_floor()
var is_dead = false
var transit_factor := 1.67 #variable that multiplies the position smoothing of the camera based on the current fps

func _enter_tree():
	MainInstances.player = self


func _exit_tree():
	MainInstances.player = null


func _ready():
	PlayerStats.set_health(PlayerStats.max_health)
	PlayerStats.no_health.connect(death)
	on_spawn = true
	state_machine.init(self, movement_component)
	attack_machine.init(self, movement_component)
	await get_tree().create_timer(spawn_time).timeout
	on_spawn = false


func _physics_process(delta):
	state_machine.process_physics(delta)
	attack_machine.process_physics(delta)
	state_velocity.x = velocity.x
	if x_sprite.flip_h:
		wall_cast.target_position.x = abs(wall_cast.target_position.x) * -1
	else:
		wall_cast.target_position.x = abs(wall_cast.target_position.x)
	charge_animation()
	if not is_dashing:
		ghost_timer.stop()
				
		


func _process(delta):
	state_machine.process_frame(delta)
	attack_machine.process_frame(delta)
	change_transit()
	


func _unhandled_input(event):
	if has_control:
		state_machine.process_input(event)
		attack_machine.process_input(event)



func dash_start_dust():
	if x_sprite.flip_h:
		var dust_start = Utils.instantiate_scene_on_world_flipped(DashDustStart, dust_point_2.global_position)
	else:
		var dust_start = Utils.instantiate_scene_on_world(DashDustStart, dust_point.global_position)
		

func create_dust_effect():
	if is_on_floor_only():
		if x_sprite.flip_h:
			Utils.instantiate_scene_on_world(DustEffectScene, dust_point_2.global_position)
		else:
			Utils.instantiate_scene_on_world(DustEffectScene, dust_point.global_position)
	

func wall_dust_effect():
	if is_on_wall_only():
		if x_sprite.flip_h:
			Utils.instantiate_scene_on_world(WallDustScene, wall_dust.global_position)
		else:
			Utils.instantiate_scene_on_world(WallDustScene, wall_dust_2.global_position)

func set_direction():
	if Vector2.RIGHT:
		x_sprite.flip_h = false
		wall_cast.target_position.x *= 1
	if Vector2.LEFT:
		x_sprite.flip_h = true
		wall_cast.target_position.x *= -1

func blit_damage_number(number):
	var damage_number_inst = Utils.instantiate_scene_on_world(DamageNumber, global_position + Vector2(0, -12)) #offset the global_position 
	damage_number_inst.number = number
	


func charge_aura_effect():
	var aura = Utils.instantiate_scene_on_world(ChargedParticles, global_position - Vector2(0, y_offset))

func get_direction():
	return Vector2.LEFT if x_sprite.flip_h else Vector2.RIGHT
	

func instance_ghosting():
	var ghost : Sprite2D = GhostingScene.instantiate()
	ghost.global_position = x_sprite.global_position
	ghost.texture = x_sprite.texture
	ghost.hframes = x_sprite.hframes
	ghost.vframes = x_sprite.vframes
	ghost.frame = x_sprite.frame
	ghost.flip_h = x_sprite.flip_h
	
	get_parent().add_child(ghost)
	

func charge_animation():
	if charge_lvl == 1:
		charge_flash.play("Charge_One")
	if charge_lvl == 2:
		charge_flash.play("Charge_Two")


func wall_spark_effect():
	if is_on_wall_only():
		if x_sprite.flip_h:
			Utils.instantiate_scene_on_world(WallKickDust, wall_kick_2.global_position)
		else:
			Utils.instantiate_scene_on_world(WallKickDust, wall_kick.global_position)

func _on_ghost_timer_timeout():
	instance_ghosting()


func _on_aura_timer_timeout():
	charge_aura_effect()


func spawn_effect_one():
	Sounds.play(Sounds.fade_in, 1.0, -10.0)

func spawn_effect_two():
	Sounds.play(Sounds.spawn_comp, 1.0, -12.0)

func _on_hurt_box_component_hurt(hitbox, damage):
	is_damaged = true
	Events.add_screenshake.emit(2, 0.1)
	PlayerStats.health -= damage
	blit_damage_number(damage)
	
	

func death():
	get_tree().paused = true
	await get_tree().create_timer(death_time).timeout
	get_tree().paused = false
	Events.player_died.emit()
	state_machine.change_state(death_state)
	camera.global_position = global_position #grab current pos and set as camera position
	camera.reparent(get_tree().current_scene, true)
	await get_tree().create_timer(0.5).timeout
	ScreenTransition.fade_in()


func _on_room_detector_area_entered(area):
	if on_spawn:
		camera.position_smoothing_enabled = false
	else:
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 3 * transit_factor
		print(camera.position_smoothing_speed)
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size : Vector2 = collision_shape.shape.extents * 2 #variable size set equal to the extents of the shape of the collision shape times 2
	
	camera.limit_top = collision_shape.global_position.y - size.y/2
	camera.limit_left = collision_shape.global_position.x - size.x/2
	camera.limit_right = camera.limit_left + size.x
	camera.limit_bottom = camera.limit_top + size.y
	
	


func add_screenshake(shake_intensity : float, shake_length : float):
	Events.add_screenshake.emit(shake_intensity, shake_length)


func _on_room_detector_area_exited(area):
	await get_tree().create_timer(0.5).timeout
	camera.position_smoothing_enabled = false
	#if the player leaves a room, and there is no room after it, the position smoothing will stay able upon reentering the initial room
	#this is due to the area exited function never being called upon reentering the prior room so position smoothing is never allowed to be turned back on
	#this problem is easily avoided, by simply having an ample number of rooms within the level scene. 

func change_transit():
	var current_fps = Engine.get_frames_per_second()
	if current_fps <= 60:
		transit_factor = 1.5
	else:
		transit_factor = 1
