extends Node


var sounds_path = "res://Music and Sounds/"

@export var menu_cursor : AudioStream



@onready var sound_players = get_children() #variable for getting the audio players in the scene 



func play(sound_stream, pitch_scale = 1.0, volume_db = 0.0):
	for sound_player in sound_players: #for loop for obtaining child nodes in the Sound Scene
		if not sound_player.playing: #if there is no sound playing
			sound_player.pitch_scale = pitch_scale #set pitch scale equal to pitch scale passed in (default is 1.0)
			sound_player.volume_db = volume_db #set volume equal to volume level passed in (default is 0.0)
			sound_player.stream = sound_stream #load the corresponding sound file with the string passed in (ex. "res://Sounds/bullet.wav")
			if Engine.time_scale < 1.0:
				sound_player.pitch_scale = 0.65
			else:
				sound_player.pitch_scale = 1.0
			sound_player.play() #play the sound 
			return

func stop(sound_stream):
	for sound_player in sound_players:
		if sound_player.is_playing():
			sound_player.stop()
			

func mute(sound_stream):
	for sound_player in sound_players:
		sound_player.volume_db = -80.0
		sound_player.stream = sound_stream


func unmute(sound_stream, value = 1.0):
	for sound_player in sound_players:
		sound_player.volume_db = value
