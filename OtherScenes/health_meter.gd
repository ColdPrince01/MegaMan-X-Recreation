extends Control

@onready var empty = $Empty
@onready var full = $Full

# Called when the node enters the scene tree for the first time.
func _ready(): 
	update_health_ui() #on ready the game will update the health ui to match max health
	PlayerStats.health_changed.connect(update_health_ui)

func update_health_ui():
	full.size.y = PlayerStats.health * 2 #takes the texture for the full health sprite and configures it based on player's current health value returned 
	

