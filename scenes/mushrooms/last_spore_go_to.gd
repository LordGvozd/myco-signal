extends Node2D


func _ready() -> void:
	$Area2D/CollisionShape2D.disabled = true
	Bus.subscribe(MushroomDone, func(e): 
		if e.number == 7:
			$Area2D/CollisionShape2D.disabled = false
	)


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/KINO.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/KINO.tscn")
	pass # Replace with function body.
