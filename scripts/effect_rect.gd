extends ColorRect


func _ready() -> void:
	Bus.subscribe(CloseElectrod, set_shader)
	$"../../EnviromentPlayer".stream = preload("res://sounds/enviroment/birds.mp3")
	$"../../EnviromentPlayer".play()
	
	
func set_shader(event: CloseElectrod) -> void:
	$"../OnDonePlayer".stream = event.sound
	$"../OnDonePlayer".play()
	var deafult_material = material
	material = event.shader
	if event.sound.resource_path == "res://sounds/matadora dubbing x omagad.mp3":
		$"../VideoStreamPlayer".play()
		
	else:
		color = Color.WHITE
	await get_tree().create_timer(event.sound.get_length()).timeout
	material = deafult_material
	color.a = 0
	$"../VideoStreamPlayer".stop()
	
	# Change mood
	if event.sound.resource_path == "res://sounds/matadora dubbing x omagad.mp3":
		$"../ThunderScreen/ThunderAnimationPlayer".play("thunder")
		$"../../EnviromentPlayer".stream = preload("res://sounds/enviroment/rain.mp3")
		$"../../EnviromentPlayer".play()
		await get_tree().create_timer(.4).timeout
		
		Bus.create_event(MoodChangedEvent.new())
		$"../../GPUParticles2D".emitting = true
