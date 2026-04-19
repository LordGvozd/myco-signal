extends Label


func _ready() -> void:
	Bus.subscribe(HintEvent, display_hint)
	Bus.subscribe(PlayerPhraseEvent, hide_text )

	

func display_hint(event: HintEvent):
	text = event.hint
	
func hide_text(e):
	text = ""
	
