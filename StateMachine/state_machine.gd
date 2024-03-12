class_name State
extends Node


@export var movement_data : PlayerMovementData
@export var animation_name : String


var parent: Player
var move_component
var state_velocity = Vector2.ZERO



#called as soon as the player enters the state 
func enter() -> void:
	parent.character_animator.play(animation_name)

#function called when the state is exited, last function called 
func exit() -> void:
	pass
	

#function for processing player input 
func process_input(event: InputEvent) -> State:
	return null
	

#function for processing tied to idle frames
func process_frame(delta: float) -> State:
	return null
	

#function for processing, tied to physics frames 
func process_physics(delta: float) -> State:
	return null


func get_movement_input() -> float:
	return move_component.get_movement_direction() #return the movement component obtaining player movement direction
	
