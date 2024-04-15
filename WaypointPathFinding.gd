extends Node2D


@export var waypoint_buffer_distance = 8

var waypoints = [] #empty array that will contain Vector2D's
var target : Node2D #variable target that looks for node2D
var pathfinding_next_position: Vector2

@onready var ray_cast_2d = $RayCast2D



func _physics_process(delta):
	if not MainInstances.player is Node2D: return #if the main instance of the player doesn't exist, return 
	target = MainInstances.player.center #target variable will be set to Player instance (if it exists) 
	if not target is Node2D: return #if there is no target to be found, exit
	
	if can_see_target(global_position): #if the target can be seen from our current position
		pathfinding_next_position = target.global_position #the next position to find will be the target's current global position
		waypoints.clear()#if the player can be seen, waypoints aren't necessary, clear the waypoints array
	else:
		if not waypoints.is_empty(): #if our waypoints aren't empty
			pathfinding_next_position = waypoints.front() #first set next position to the waypoint at the front array 
			
			if not can_see_target(waypoints.back()): #If the enemy cannot see the target, can the last way point see the target?
				waypoints.append(target.global_position) #pushes target position back to the end of the array
				
			
			if global_position.distance_to(waypoints.front()) <= waypoint_buffer_distance: #if the enemy is within the distance of the waypoint
				waypoints.pop_front() #remove the waypoint and put the next one in front 
				
			
		else: #if the waypoints are empty
			if not can_see_target(global_position): #and we cannot see the target from the current waypoint position
				waypoints.append(target.global_position) #append the target's current or last seen position




func can_see_target(from):
	ray_cast_2d.global_position = from #raycast 2D's global position is set to variable "from"
	ray_cast_2d.target_position = target.global_position - from #ray cast target position (end of the arrow) is set equal to the global position minus distance from raycast origin
	# basically gives us the position of the target relative to the raycast origin
	ray_cast_2d.force_raycast_update() #forces raycast collision update to happen right away (instead of only happening at the next physics frame) 
	return not ray_cast_2d.is_colliding() #return that the ray cast 2D is not colliding with any bodies (basically that the raycast can see the player 
