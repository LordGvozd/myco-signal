extends Area2D

@export var message_text: String
@onready var message = $"../DialogBubble/Label"

var _is_player_in: bool = false

func _ready() -> void:
	message.text = ""
	$"../DialogBubble/Label".visible = false
	$"../DialogBubble/TextureRect".visible = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$"../DialogBubble/Label".visible = true
		$"../DialogBubble/TextureRect".visible = true
		_is_player_in = true
		for w in message_text:
			await get_tree().create_timer(.2).timeout
			if _is_player_in:
				message.text += w
			else:
				break

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_is_player_in = false
		message.text = ""
		$"../DialogBubble/Label".visible = false
		$"../DialogBubble/TextureRect".visible = false
