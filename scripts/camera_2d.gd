extends Camera2D

@export var target: CharacterBody2D
@export var follow_speed: float = 12.0  # Быстрая реакция


var world_size: Size

func limit_camera() -> void:
	if world_size:
		limit_bottom = world_size.bottom_right_corner.global_position.y
		limit_right = world_size.bottom_right_corner.global_position.x
		limit_top = world_size.top_left_corner.global_position.y
		limit_left = world_size.top_left_corner.global_position.x

	
		limit_enabled = true
