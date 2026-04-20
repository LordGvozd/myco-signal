extends Node2D


func _ready() -> void:
	var e = SporeEvent.new()
	e.target_position = $Mushroom2.global_position
	
	Bus.create_event(e)
