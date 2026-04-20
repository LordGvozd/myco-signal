class_name InteractableArea extends Area2D

@export var phrase_text: String
@export var hint_message: String = "Нажмите E для взаимодействия"

var _is_player_in: bool = false

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func _process(delta: float) -> void:
	if _is_player_in and Input.is_action_just_pressed("interact"):
		var event = PlayerPhraseEvent.new()
		event.text = phrase_text
		Bus.create_event(event)
		get_viewport().set_input_as_handled()

func on_body_entered(body: Node2D) -> void:
	if _is_player(body):
		_is_player_in = true
		var hint_event = HintEvent.new()
		hint_event.hint = hint_message
		Bus.create_event(hint_event)

func on_body_exited(body: Node2D) -> void:
	if _is_player(body):
		_is_player_in = false
		var hide_hint = HintEvent.new()
		hide_hint.hint = ""
		Bus.create_event(hide_hint)

func _is_player(body: Node2D) -> bool:
	return body.is_in_group("player")
