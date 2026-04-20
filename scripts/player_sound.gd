extends AudioStreamPlayer2D

func _ready() -> void:
	Bus.subscribe(PlayerStartMove, play_steps)
	Bus.subscribe(PlayerStopMove, stop_steps)
	
func play_steps(e):
	play()
	
func stop_steps(e):
	stop()
