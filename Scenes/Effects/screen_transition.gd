extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


func fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished

func fade_in_black():
	animation_player.play("fade_in_black")
	await animation_player.animation_finished

func fade_out_black():
	animation_player.play("fade_out_black")
	await animation_player.animation_finished
