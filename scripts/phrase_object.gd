extends Area2D


@export
var shape: CollisionShape2D

@export
var phrase_text: String

var _is_player_in: bool = false




func _process(delta: float) -> void:
	if _is_player_in:
		var event = HintEvent.new()
		
	if Input.is_action_just_pressed("interact") and _is_player_in:
		var event = PlayerPhraseEvent.new()
		event.text = phrase_text
		
		Bus.create_event(event)


func _on_body_entered(body: Node2D) -> void:
	var name = body.get_script().get_global_name()
	if name == "Player":
		_is_player_in = true


func _on_body_exited(body: Node2D) -> void:
	var name = body.get_script().get_global_name()
	if name == "Player":
		_is_player_in = false
