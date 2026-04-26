extends GPUParticles2D

@export var speed: int = 100

var wave_amplitude: float = 5 
var accuracy: float = 4   

var direction: Vector2 = Vector2.ZERO
var target: Vector2 

var moving: bool = false
var time: float = 0.0
var pmaterial: ParticleProcessMaterial

func _ready() -> void:
	Bus.subscribe(SporeEvent, spore_to)
	pmaterial = process_material

func spore_to(event: SporeEvent) -> void:
	target = event.target_position
	moving = true
	emitting = true
	$"Timer".start(randi_range(1, 3))
	
func resize():
	var new_emission_box_extends_x = randf_range(-3, 3)
	if pmaterial.emission_box_extents.x + new_emission_box_extends_x > 1 and pmaterial.emission_box_extents.x + new_emission_box_extends_x < 7:
		pmaterial.emission_box_extents.x += new_emission_box_extends_x
	
	$"Timer".start(randi_range(1, 3))
	
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

		
	elif self.global_position.x < target.x:
		direction.x = 1
	
		

	if abs(self.global_position.y - target.y) < 2:
		direction.y = 0
	elif self.global_position.y > target.y:
		direction.y = -1
		
	elif self.global_position.y < target.y:
		direction.y = 1
		
	move(delta)
		

	
func move(delta: float) -> void:
	time += delta
	
	
	self.global_position.x += direction.x * delta * speed
	self.global_position.y += direction.y * delta * speed


	global_position += Vector2(randi_range(-wave_amplitude, wave_amplitude), randi_range(-wave_amplitude, wave_amplitude))


func _on_timer_timeout() -> void:
	resize()
