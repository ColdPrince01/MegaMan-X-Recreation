extends Node

var metals = {
	"copper": {"quantity": 50, "price": 50},
	"silver": {"quantity": 20, "price": 150},
	"gold": {"quantity": 3, "price": 500},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for i in range(4):
		print(get_metal())


func get_metal():
	var random_metal = metals.values()[randi() % metals.size()]
	# Returns a random metal value dictionary every time the code runs.
	# The same metal may be selected multiple times in succession.
	return random_metal
