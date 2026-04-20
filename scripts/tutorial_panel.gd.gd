extends Control

@export var close_button: Button

var ui_elements: Array[Control] = []

func _ready():
	var canvas_layer = get_parent()  # Это CanvasLayer
	var names = ["ThunderScreen", "VideoStreamPlayer", "EffectRect", "PlayerUI"]
	for n in names:
		var node = canvas_layer.get_node_or_null(n)
		if node and node is Control:
			ui_elements.append(node)
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	Bus.subscribe(ShowTutorialEvent, _on_show_tutorial)
	if close_button:
		close_button.pressed.connect(_on_button_pressed)

func _on_show_tutorial(event: ShowTutorialEvent):
	for el in ui_elements:
		el.visible = false
	visible = true
	# Даём кнопке фокус, чтобы нажатия точно обрабатывались
	if close_button:
		close_button.grab_focus()

func _on_button_pressed():
	print("Кнопка нажата")
	visible = false
	for el in ui_elements:
		el.visible = true
	Bus.create_event(TutorialClosedEvent.new())
