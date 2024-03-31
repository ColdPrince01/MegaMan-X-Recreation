extends Control

@onready var full = $Full
@onready var empty = $Empty

# Called when the node enters the scene tree for the first time.
func _ready(): 
	update_health_ui() #on ready the player's health bar should be updated to match current health
	PlayerStats.health_changed.connect(update_health_ui)
	PlayerStats.max_health_changed.connect(update_max_health_ui)

func update_health_ui():
	full.size.y = PlayerStats.health  #Size of health sprite (in px.) should be equivalent to the player's health in units (1 pixel size for every 1 unit of player health)
	if PlayerStats.health <= 0.0:
		full.size.y = 0
	

func update_max_health_ui():
	empty.size.y = PlayerStats.max_health * 2
