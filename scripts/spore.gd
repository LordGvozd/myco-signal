extends GPUParticles2D

@export var speed: int = 100

var wave_amplitude: float = 15.0  
var accuracy: float = 10   

var direction: Vector2 = Vector2.ZERO
var target: Vector2 

var moving: bool = false
var time: float = 0.0

func _ready() -> void:
	Bus.subscribe(SporeEvent, spore_to)

func spore_to(event: SporeEvent) -> void:
	target = event.target_position
	moving = true
	emitting = true
	
func _process(delta: float) -> void:
	if not moving:
		return
		
	
	if abs(self.global_position.x - target.x) < accuracy and abs(self.global_position.y - target.y) < accuracy:
		print("Targer achived")
		direction = Vector2.ZERO
		moving = false
		emitting = false
	
	if abs(self.global_position.x - target.x) < 2:
		direction.x = 0
	elif self.global_position.x > target.x:
		direction.x = -1
		move(delta)
		return
	elif self.global_position.x < target.x:
		direction.x = 1
		move(delta)
		return

	if abs(self.global_position.y - target.y) < 2:
		direction.y = 0
	elif self.global_position.y > target.y:
		direction.y = -1
		move(delta)
		return
	elif self.global_position.y < target.y:
		direction.y = 1
		move(delta)
		return

	
func move(delta: float) -> void:
	time += delta
	
	
	self.global_position.x += direction.x * delta * speed
	self.global_position.y += direction.y * delta * speed
	

	global_position += Vector2(randi_range(-wave_amplitude, wave_amplitude), randi_range(-wave_amplitude, wave_amplitude))
