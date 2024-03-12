class_name Player
extends CharacterBody2D


@export var movement_data : PlayerMovementData
@export var death_time := 0.33

@onready var x_sprite = $XSprite
@onready var character_animator = $CharacterAnimator
@onready var movement_component = $MovementComponent
@onready var state_machine = $StateMachine
@onready var coyote_timer = $CoyoteTimer


var has_control := true
var has_jumped = false
var is_dashing = false
var can_dash = true

func _ready():
	state_machine.init(self, movement_component)
	


func _physics_process(delta):
	state_machine.process_physics(delta)
	if Input.is_action_pressed("ui_up"):
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1.0
	

func _process(delta):
	state_machine.process_frame(delta)
	


func _unhandled_input(event):
	state_machine.process_input(event)
	

func set_direction():
	if Vector2.RIGHT:
		x_sprite.flip_h = false
	if Vector2.LEFT:
		x_sprite.flip_h = true


func get_direction():
	return Vector2.LEFT if x_sprite.flip_h else Vector2.RIGHT
	
