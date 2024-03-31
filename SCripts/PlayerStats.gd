extends Stats



@export var max_lives = 3 : set = set_max_lives
@onready var lives = max_health : set = set_lives

signal no_lives #signal for when the health has reached zero 
signal lives_changed
signal max_lives_changed


func set_max_lives(value):
	max_health = value
	max_lives_changed.emit()



func set_lives(value):
	lives = clamp(value, 0, max_lives)
	lives_changed.emit()
	if lives <= 0: no_lives.emit()
