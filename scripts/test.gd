extends Node2D


func _ready() -> void:
	var e = TestEvent.new()
	
	e.value = "TEST VALUE 123"
	
	Bus.create_event(e)
