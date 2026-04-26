extends Area2D

@export var sprite: AnimatedSprite2D

@export_group("Base messages")
@export var messages_list: Array[String]
@export var sounds_list: Array[AudioStreamMP3]

@export_group("Random messages")
@export var random_messages_list: Array[String]
@export var random_sounds_list: Array[AudioStreamMP3]

@export_group("Dark messages")
@export var dark_messages_list: Array[String]
@export var dark_sounds_list: Array[AudioStreamMP3]

@onready var message = $"DialogBubble/Label"

@onready var message_text
var current_index: int = 0

var _is_player_in: bool = false
var _printing: bool = false
var _show_mark: bool = true
var _is_dark: bool = false

func _ready() -> void:
	message_text = messages_list[0]

	message.text = ""
	$"DialogBubble/Label".visible = false
	$"DialogBubble/TextureRect".visible = false
	
	Bus.subscribe(MoodChangedEvent, func(e):
		sprite.play("dark")
		random_messages_list = dark_messages_list
		random_sounds_list = dark_sounds_list
		_show_mark = false
		_is_dark = true
)

func _process(delta: float) -> void:
	if _is_player_in and Input.is_action_pressed("interact") and not _printing:
		next_message()
		
func next_message():
	if not _show_mark:
		current_index = randi_range(0, len(random_messages_list) - 1)
		message_text = random_messages_list[current_index]
		display_text()
		return
		
	if current_index >= len(messages_list) - 1:
		_show_mark = false
		current_index = 0
	else:
		current_index += 1
	message_text = messages_list[current_index]
	display_text()

func display_text() -> void:
	# Play sound
	if _show_mark:
		$SoundsPlayer.stream = sounds_list[current_index]
	else:
		$SoundsPlayer.stream = random_sounds_list[current_index]
	$SoundsPlayer.play()
	
	message.text = ""
	$"DialogBubble/Label".visible = true
	$"DialogBubble/TextureRect".visible = true
	_is_player_in = true
	_printing = true
	for w in message_text:
		await get_tree().create_timer(.1).timeout
		if _is_player_in:
			message.text += w
		else:
			break
	_printing = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$DialogBubble/TextureRect2.visible = false
		display_text()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_index = 0
		_is_player_in = false
		message.text = ""
		$"DialogBubble/Label".visible = false
		$"DialogBubble/TextureRect".visible = false
		if _show_mark:
			$DialogBubble/TextureRect2.visible = true
