extends Node2D

@export var dev_menu := true

const PlayerScene = preload("res://Scenes/Player/mmx.tscn")

@onready var label = $CanvasLayer/Labels/Label
@onready var label_6 = $CanvasLayer/Labels/Label6
@onready var label_2 = $CanvasLayer/Labels/Label2
@onready var label_3 = $CanvasLayer/Labels/Label3
@onready var label_4 = $CanvasLayer/Labels/Label4
@onready var label_5 = $CanvasLayer/Labels/Label5
@onready var label_7 = $CanvasLayer/Labels/Label7
@onready var ready_text = $CanvasLayer/Ready
@onready var stage_level = $StageLevel




@onready var player = MainInstances.player
@onready var camera : PlayerCamera = MainInstances.camera

@export var init_room : Room

var world_ready := false

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	await ScreenTransition.fade_out_black()
	ready_text.visible = true
	await get_tree().create_timer(1.0).timeout
	ready_text.play("new_animation")
	await get_tree().create_timer(1.5).timeout
	ready_text.queue_free()

func _physics_process(delta):
	if dev_menu == true and player != null:
		label.text = str("FPS:") + str(Engine.get_frames_per_second())
		label_2.text = str("Vel_x:") + str(player.velocity.x)
		label_3.text = str("Vel_y:") + str(player.velocity.y)
		label_4.text = str("State:") + str(player.state_machine.current_state.string_name)
		label_5.text = str("Attack_State:") + str(player.attack_machine.current_state.string_name)
		label_6.text = str("Input:") + str(player.state_machine.current_state.input_action)
		label_7.text = str("Charge_lvl:") + str(player.charge_lvl)
		
	if Input.is_action_pressed("ui_up"):
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1.0
