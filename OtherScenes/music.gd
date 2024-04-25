extends Node

@export var level_theme : AudioStream

var current_song

@onready var audio_stream_player = $AudioStreamPlayer
@onready var sound_players = get_children() #variable for getting the audio players in the scene 


func _physics_process(delta):
	for audio in sound_players:
		if Engine.time_scale < 1.0:
			audio.pitch_scale = 0.55
		else:
			audio.pitch_scale = 1.0

func play(song, from_position = 0.0, pitch_scale = 1.0, volume_db = 0.0):
	for audio in sound_players:
		if not audio.playing:
			audio.stream = song
			audio.volume_db = volume_db
			audio.pitch_scale = pitch_scale
			audio.play(from_position)
			return

#function for fading the music out
func fade(duration = 1.5):
	var previous_volume_db = audio_stream_player.volume_db
	var volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN) #creates the properties of the music to be tweened
	volume_fade.tween_property(audio_stream_player, "volume_db", -80.0, duration) #takes the tween of the volume fade variable, and causes it so slowly fade out from its
	#current volume 
	await volume_fade.finished #wait untilt he fade has finished
	audio_stream_player.stop() #then stop the song 
	audio_stream_player.volume_db = previous_volume_db

func stop():
	if audio_stream_player.playing:
		audio_stream_player.stop()
