extends Node2D



func _ready() -> void:
	self.visible = false
	for child in get_children():
		child.visible = false
	Bus.subscribe(MoodChangedEvent, mood_changed)
	
	
func mood_changed(e) -> void:
	self.visible = true
	for child in get_children():
		child.visible = true
