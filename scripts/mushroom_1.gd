extends InteractableArea

@export var melody: Melody
@export var sound: AudioStreamMP3
@export var shader: ShaderMaterial
@export var number: int

func _ready() -> void:
	super._ready()
	Bus.subscribe(MushroomDone, shows)
	$CollisionShape2D.disabled = true
	
func shows(e):
	if e.number == number: 
		$CollisionShape2D.disabled = false
		
		var spore_event = SporeEvent.new()
		spore_event.target_position = global_position
		
		Bus.create_event(spore_event)
	else:
		$CollisionShape2D.disabled = true

func _process(delta: float) -> void:
	if _is_player_in and Input.is_action_just_pressed("interact"):
		
		var event = OpenElectrod.new()
		event.melody = melody
		event.sound = sound
		event.shader = shader
		
		var on_done_event = MushroomDone.new()
		on_done_event.number = number + 1
		event.on_done_event = on_done_event
		
		Bus.create_event(event)
		
