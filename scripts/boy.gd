extends Area2D

@export var message_text: String
@onready var message = get_node("../Label")

var _is_player_in: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		message.text = message_text

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		message.text = ""
