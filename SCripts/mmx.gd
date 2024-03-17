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

@export var movement_data : PlayerMovementData
@export var death_time := 0.33
@export var dev_menu := true


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

var no_shockwave = is_dashing and is_on_floor()

func _enter_tree():
	MainInstances.player = self


func _exit_tree():
	MainInstances.player = null


func _ready():
	state_machine.init(self, movement_component)
	attack_machine.init(self, movement_component)


func _physics_process(delta):
	state_machine.process_physics(delta)
	attack_machine.process_physics(delta)
	if dev_menu == true: #Dev Menu for basic parameters
		label.text = str("FPS:") + str(Engine.get_frames_per_second())
		label_2.text = str("Vel_x:") + str(velocity.x)
		label_3.text = str("Vel_y:") + str(velocity.y)
		label_4.text = str("State:") + str(state_machine.current_state.string_name)
		label_5.text = str("Attack_State:") + str(attack_machine.current_state.string_name)
		label_6.text = str("Input:") + str(state_machine.current_state.input_action)
	if not is_dashing:
		ghost_timer.stop()
		


func _process(delta):
	state_machine.process_frame(delta)
	attack_machine.process_frame(delta)


func _unhandled_input(event):
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
	if Vector2.LEFT:
		x_sprite.flip_h = true



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
	

func wall_spark_effect():
	if is_on_wall_only():
		if x_sprite.flip_h:
			Utils.instantiate_scene_on_world(WallKickDust, wall_kick_2.global_position)
		else:
			Utils.instantiate_scene_on_world(WallKickDust, wall_kick.global_position)

func _on_ghost_timer_timeout():
	instance_ghosting()
