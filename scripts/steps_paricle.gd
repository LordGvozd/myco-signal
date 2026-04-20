extends GPUParticles2D

func _ready() -> void:
	emitting = false
	Bus.subscribe(PlayerStartMove, func(e): emitting = true )
	Bus.subscribe(PlayerStopMove, func(e): emitting = false )
	
