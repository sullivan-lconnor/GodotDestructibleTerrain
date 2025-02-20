extends RigidBody2D

@export var explosion_radius := 50
@export var explosion_delay := 1.5

var explosion_area: Area2D  # Store the explosion area reference

func _ready():
	$Timer.wait_time = explosion_delay
	$Timer.start()
	
	# Create a temporary Area2D for collision detection
	explosion_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius  # Correct the radius reference

	# Set up collision detection
	collision_shape.shape = shape
	explosion_area.add_child(collision_shape)
	explosion_area.set_deferred("monitoring", true)  # Ensure it's monitoring physics
	add_child(explosion_area)  # Attach it to the bomb

#func explode():
	#print_debug("FUSE!")
#
	## Position the explosion area at the bomb’s position
	#explosion_area.global_position = global_position
	#
	## Find the sand node and call split with the query
	#var sand = get_tree().get_first_node_in_group("sand")
	#var split_status = sand.split(explosion_area)
	#
	## If the split status is true reset the timer for the shortest time possible
	#
	## ELSE
	#print_debug("BOOM!")
	#queue_free()  # Destroy the bomb

func explode():
	print_debug("FUSE!")
	
	# Freeze the bomb so it can't move anymore
	freeze = true

	# Position the explosion area at the bomb’s position
	explosion_area.call_deferred("set_global_position", global_position)
	
	# Find the sand node and call split with the query
	var sand = get_tree().get_first_node_in_group("sand")
	if sand:
		var split_status = sand.split(explosion_area)

		# If the split status is true, reset the timer for the shortest time possible
		if split_status:
			$Timer.wait_time = 0.05
			$Timer.start()
		else:
			print_debug("BOOM!")
			queue_free()  # Destroy the bomb
	else:
		print_debug("No sand node found!")
		print_debug("BOOM!")
		queue_free()
		
func _on_timer_timeout() -> void:
	explode()
