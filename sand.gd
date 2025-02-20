extends Node2D

@export var grid_size := 1000  # Size of the sand terrain
@export var tile_size := 32     # Size of each sand tile
@export var sand_tile_scene: PackedScene  # Assign SandTile.tscn
@export var sand_tile_min_scale := 0.125  # Minimum tile scale before stopping

func _ready():
	generate_sand()
	add_to_group("sand")

func generate_sand():
	var cols = grid_size / tile_size
	var rows = grid_size / tile_size

	for x in range(cols):
		for y in range(rows):
			var tile = sand_tile_scene.instantiate()
			tile.position = Vector2(x * tile_size, y * tile_size)  # Position in grid
			add_child(tile)

func split_tile(tile: StaticBody2D) -> bool:
	# Returns true if split happened, false otherwise
	var current_scale = tile.scale.x  # Assuming uniform scaling (x and y are the same)
	tile.queue_free()
	tile.alive = false
	
	print_debug(current_scale)
	if current_scale <= sand_tile_min_scale:
		print_debug("DELETEING TILE")
		return false  # Stop splitting if the tile is too small

	var new_scale = current_scale / 2.0  # Each new tile is half the size
	var offsets = [Vector2(-0.5, -0.5), Vector2(0.5, -0.5), Vector2(-0.5, 0.5), Vector2(0.5, 0.5)]

	for offset in offsets:
		var new_tile = sand_tile_scene.instantiate() as StaticBody2D
		add_child(new_tile)
		new_tile.global_position = tile.global_position + offset * (new_scale * tile_size)
		new_tile.scale = Vector2(new_scale, new_scale)

	return true

func split(area):	
	# Get overlapping bodies (tiles)
	var tiles_to_split = []
	for body in area.get_overlapping_bodies():
		if body.is_in_group("sand_tiles") and body.alive:
			tiles_to_split.append(body)

	# Split each tile found
	var tile_split_status = false
	for tile in tiles_to_split:
		if split_tile(tile):
			tile_split_status = true
	
	# Return true for more tiles to split
	return tile_split_status 
