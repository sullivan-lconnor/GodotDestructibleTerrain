extends StaticBody2D

@export var split_scale_limit = 0.125
var alive := true

func _ready():
	add_to_group("sand_tiles")
	
func destroy():
	queue_free()  # Remove the tile
