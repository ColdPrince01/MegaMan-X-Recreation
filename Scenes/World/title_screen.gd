extends ColorRect

@export var next_scene : PackedScene

const FullyChargedBlast = preload("res://Scenes/InheritanceScenes/fully_charged_buster.tscn")

@onready var mega_text_anim = $MegaTextAnim
@onready var x_text_anim = $XTextAnim
@onready var text_x = $TextX
@onready var title_text_mega = $TitleTextMega
@onready var start = $Buttons/VBoxContainer/Start
@onready var exit = $Buttons/VBoxContainer/Exit
@onready var shadow_labels = $ShadowLabels
@onready var buttons = $Buttons
@onready var button_anim = $ButtonAnim
@onready var shadow_text = $ShadowText
@onready var copy_right = $CopyRight
@onready var copy_right_text = $CopyRightText
@onready var x_icon = $XIcon
@onready var player_anim = $XIcon/PlayerAnim




func _ready():
	x_icon.modulate.a = 0
	copy_right.modulate.a = 0
	shadow_labels.modulate.a = 0
	buttons.modulate.a = 0
	text_x.visible = false
	x_icon.global_position.y = 108.5
	mega_text_anim.play("slide_in")
	await mega_text_anim.animation_finished
	copy_right_text.play("fade_in")
	text_x.visible = true
	x_text_anim.play("slide_in")
	await x_text_anim.animation_finished
	mega_text_anim.play("flash")
	x_text_anim.play("flash")
	await mega_text_anim.animation_finished
	button_anim.play("fade_in")
	shadow_text.play("fade_in")
	player_anim.play("fade_in")
	await button_anim.animation_finished
	start.grab_focus()
	




func _on_start_focus_entered():
	x_icon.global_position.y = start.global_position.y


func _on_exit_focus_entered():
	x_icon.global_position.y = exit.global_position.y


func _on_start_pressed():
	player_anim.play("fire")
	Sounds.play(Sounds.fully_charged)
	var lemon = Utils.instantiate_scene_on_world(FullyChargedBlast, x_icon.global_position + Vector2(8, 0))
	lemon.update_velocity()
	lemon.velocity.x = lemon.speed