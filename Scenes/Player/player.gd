extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var pickaxe_scene: PackedScene

var pickaxe_instance # Variable to hold the instantiated pickaxe
func _ready():
	if pickaxe_scene:
		pickaxe_instance = pickaxe_scene.instantiate()
		add_child(pickaxe_instance)
		#pickaxe_instance.visible = false  # Initially hide it, assuming it has a visible component

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed( 1 ): # Left click
		var mouse_position = $Camera2D.get_global_mouse_position()
		pickaxe_instance.activate(global_position, mouse_position)
	
	# Check for bomb spawn input
	if Input.is_action_just_pressed("use_item"):
		spawn_bomb()
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

@export var bomb_scene: PackedScene  # Assign Bomb.tscn in the Inspector
func spawn_bomb():
	if bomb_scene:  # Check if the bomb scene is assigned
		var bomb = bomb_scene.instantiate()  # Correct way to instantiate
		bomb.global_position = global_position + Vector2(0, 20)  # Position below the player
		get_parent().add_child(bomb)  # Add to the scene tree
	else:
		print("Error: Bomb scene not assigned!")
