extends Label


func _ready() -> void:
	Bus.subscribe(HintEvent, display_hint)
	



func display_hint(event: HintEvent):
	text = event.hint
	
	
