extends Label


func _ready() -> void:
	Bus.subscribe(PlayerPhraseEvent, display_text)
	Bus.subscribe(PlayerStopMove, hide_text )
	Bus.subscribe(PlayerStartMove, hide_text)

func display_text(event: PlayerPhraseEvent):
	text = event.text
	
func hide_text(e):
	text = ""
	
