extends Node2D


@onready var spawn_area = $SpawnArea


func _ready():
	Events.player_died.connect(end_music)
	await get_tree().create_timer(2.0).timeout
	Music.play(Music.level_theme, 0.0, 1.0, -12.0)


func end_music():
	Music.stop()
