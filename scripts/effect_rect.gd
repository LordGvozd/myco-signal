extends ColorRect


func _ready() -> void:
	Bus.subscribe(CloseElectrod, set_shader)
	
func set_shader(event: CloseElectrod) -> void:
	$"../OnDonePlayer".stream = event.sound
	$"../OnDonePlayer".play()
	var deafult_material = material
	material = event.shader
	if event.sound.resource_path == "res://sounds/matadora dubbing x omagad.mp3":
		print("Catchgged")
		$"../VideoStreamPlayer".play()
	else:
		
		
		color = Color.WHITE
	await get_tree().create_timer(event.sound.get_length()).timeout
	material = deafult_material
	color.a = 0
	$"../VideoStreamPlayer".stop()
