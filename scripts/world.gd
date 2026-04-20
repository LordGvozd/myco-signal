extends Node2D


func _ready() -> void:
	var event = MushroomDone.new()
	event.number = 0
	
	Bus.create_event(event)
