extends InteractableArea

@export var number: int = 0

func _ready():
	super._ready()
	Bus.subscribe(MushroomDone, _on_mushroom_done)
	Bus.subscribe(TutorialClosedEvent, _on_tutorial_closed)
	$CollisionShape2D.disabled = true

func _on_mushroom_done(event: MushroomDone):
	if event.number == number:
		$CollisionShape2D.disabled = false
	else:
		$CollisionShape2D.disabled = true

func _process(delta):
	if _is_player_in and Input.is_action_just_pressed("interact"):
		Bus.create_event(ShowTutorialEvent.new())

func _on_tutorial_closed(event: TutorialClosedEvent):
	queue_free()
	var done_event = MushroomDone.new()
	done_event.number = number + 1
	Bus.create_event(done_event)
