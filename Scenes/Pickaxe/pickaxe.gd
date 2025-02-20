extends Node2D

@export var cooldown := 0.01
@export var radius := 10
@export var pickaxe_radius = 50

var hit_area: Area2D
var can_activate := true  # Variable to track if activation is allowed

func _ready():
	# Set cooldown time
	$Timer.wait_time = cooldown
	
	# Create a temporary Area2D for collision detection
	hit_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	collision_shape.shape = shape
	hit_area.add_child(collision_shape)
	hit_area.set_deferred("monitoring", true)
	add_child(hit_area)

func activate(player_location, mouse_location) -> void:
	var location = mouse_location
	if can_activate:
		
		var mouse_distance_from_player = player_location.distance_to(location)
		if mouse_distance_from_player >= pickaxe_radius:
			# Change the location to the clamped interpolated distance between the two points pickaxe_radius away
			var direction = (location - player_location).normalized()
			var clamped_location = player_location + direction * pickaxe_radius
			hit_area.global_position = clamped_location
		else:
			# Position the explosion area at the desired position
			hit_area.global_position = location
		
		# Find the sand node and call split with the query
		var sand = get_tree().get_first_node_in_group("sand")
		if sand:
			sand.split(hit_area)
		
		can_activate = false  # Disable further activation until timer expires
		$Timer.start()  # Start the cooldown timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	can_activate = true  # Re-enable activation after the cooldown
